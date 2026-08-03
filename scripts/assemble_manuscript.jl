#!/usr/bin/env julia
# scripts/assemble_manuscript.jl

using Dates

function read_text(path::String)
    return read(path, String)
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
    files = sort(filter(name -> endswith(name, ".tex.mustache"), readdir(section_dir)))
    blocks = String[]
    for file in files
        path = joinpath(section_dir, file)
        rendered = render_template(read_text(path), context)
        push!(blocks, "% --- Begin Section: $(path) ---\n" * rendered * "\n% --- End Section: $(path) ---")
    end
    return join(blocks, "\n\n")
end

function copy_bibliography(outdir::String)
    src_bib = joinpath("notes", "manuscript", "paper1.bib")
    dst_bib = joinpath(outdir, "paper1.bib")
    if isfile(src_bib)
        cp(src_bib, dst_bib; force = true)
        println("Copied bibliography to ", dst_bib)
    else
        @warn "Bibliography source not found" src_bib
    end
end

function run_latexmk(outdir::String)
    tex_path = joinpath(outdir, "paper.tex")
    cmd = `latexmk -pdf -outdir=$outdir $tex_path`
    run(cmd)
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
        "author_tex" => "{5DGSPTSBL Contributors}",
        "date_tex" => "{" * string(Dates.today()) * "}",
    )

    section_dir = joinpath("templates", "sections")
    context["sections_tex"] = build_sections(section_dir, context)

    paper_template = read_text(joinpath("templates", "paper.tex.mustache"))
    paper_tex = render_template(paper_template, context)
    outpath = joinpath(outdir, "paper.tex")
    write(outpath, paper_tex)

    println("Wrote ", outpath)
    copy_bibliography(outdir)
    run_latexmk(outdir)
    summarize_build_diagnostics(outdir)
end

main()