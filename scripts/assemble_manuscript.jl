#!/usr/bin/env julia
# scripts/assemble_manuscript.jl

using Dates

function read_text(path::String)
    return read(path, String)
end

function sanitize_latex_controls(text::String)
    # Guard against accidental '\t' escape interpretation that can strip
    # leading backslashes from common LaTeX commands during intermediate processing.
    fixes = Dict(
        string('\t', "extit") => "\\textit",
        string('\t', "extbf") => "\\textbf",
        string('\t', "heta")  => "\\theta",
        string('\t', "ilde")  => "\\tilde",
        string('\t', "au")    => "\\tau",
        string('\t', "oprule") => "\\toprule",
    )

    cleaned = text
    for (broken, fixed) in fixes
        cleaned = replace(cleaned, broken => fixed)
    end
    return cleaned
end

function render_template(template::String, context::Dict{String,String})
    rendered = template
    for (k, v) in context
        rendered = replace(rendered, "{{{$k}}}" => v)
        rendered = replace(rendered, "{{$k}}" => v)
    end
    return rendered
end

function notes_exist(paths::Vector{String})
    return all(isfile, paths)
end

function build_sections(section_dir::String, context::Dict{String,String})
    # Canonical logical section order for academic publication
    canonical_order = [
        "abstract.tex.mustache",
        "introduction.tex.mustache",
        "governing_equations.tex.mustache",
        "closures.tex.mustache",
        "results_figures.tex.mustache",
        "notes_traceability.tex.mustache"
    ]

    all_files = filter(name -> endswith(name, ".tex.mustache"), readdir(section_dir))

    # Sort files according to canonical_order; append any unlisted templates to the end
    ordered_files = String[]
    for name in canonical_order
        if name in all_files
            push!(ordered_files, name)
        end
    end

    # Add any extra templates not explicitly listed in canonical_order
    for name in sort(all_files)
        if !(name in ordered_files)
            push!(ordered_files, name)
        end
    end

    blocks = String[]
    for file in ordered_files
        path = joinpath(section_dir, file)
        rendered = render_template(read_text(path), context)
        rendered = sanitize_latex_controls(rendered)
        push!(blocks, "% --- Begin Section: $(path) ---\n" * rendered * "\n% --- End Section: $(path) ---")
    end
    return join(blocks, "\n\n")
end

function copy_bibliography(outdir::String)
    src_bib = joinpath("notes", "manuscript", "paper1.bib")
    dst_bib = joinpath(outdir, "paper1.bib")
    if isfile(src_bib)
        cp(src_bib, dst_bib; force=true)
        println("Copied bibliography to ", dst_bib)
    else
        @warn "Bibliography source not found" src_bib
    end
end

function run_latexmk(outdir::String)
    tex_path = joinpath(outdir, "paper.tex")
    cmd = `latexmk -pdf -outdir=$outdir $tex_path`
    if !success(cmd)
        @warn "latexmk initial pass failed; retrying with -g to clear stale dependency/error state" tex_path
        retry_cmd = `latexmk -pdf -g -outdir=$outdir $tex_path`
        run(retry_cmd)
    end
end

function summarize_build_diagnostics(outdir::String)
    log_path = joinpath(outdir, "paper.log")
    if !isfile(log_path)
        println("Build diagnostics: no LaTeX log found at ", log_path)
        return
    end

    log_text = read_text(log_path)
    missing_citations = collect(eachmatch(r"Citation .* undefined", log_text))
    undefined_refs = collect(eachmatch(r"Reference .* undefined", log_text))
    missing_graphics = collect(eachmatch(r"File `[^`]+` not found", log_text))

    println("Build diagnostics summary:")
    println("  Missing citations: ", length(missing_citations))
    println("  Undefined references: ", length(undefined_refs))
    println("  Missing graphics: ", length(missing_graphics))
end

function main()
    outdir = joinpath("reports", "generated")
    mkpath(outdir)

    note_paths = [
        joinpath("notes", "theory", "governing-equations-and-turbulence-closure.md"),
        joinpath("notes", "implementation", "implementation-notes.md"),
        joinpath("notes", "reviews", "manuscript-review-notes.md"),
    ]
    if !notes_exist(note_paths)
        missing = filter(path -> !isfile(path), note_paths)
        error("Missing required notes for manuscript assembly: " * join(missing, ", "))
    end

    context = Dict{String,String}(
        "title_tex" => "{5DGSPTSBL: Geometric Fast-Slow Stable Boundary Layer Model}",
        "author_tex" => "{David E. England, PhD and 5DGSPTSBL Contributors}",
        "date_tex" => "{" * string(Dates.today()) * "}",
    )

    section_dir = joinpath("templates", "sections")
    context["sections_tex"] = build_sections(section_dir, context)

    paper_template = read_text(joinpath("templates", "paper.tex.mustache"))
    paper_tex = render_template(paper_template, context)
    paper_tex = sanitize_latex_controls(paper_tex)
    outpath = joinpath(outdir, "paper.tex")
    write(outpath, paper_tex)

    println("Wrote ", outpath)
    copy_bibliography(outdir)
    run_latexmk(outdir)
    summarize_build_diagnostics(outdir)
end

main()