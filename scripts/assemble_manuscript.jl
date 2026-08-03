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

function main()
    outdir = joinpath("reports", "generated")
    mkpath(outdir)

    note_paths = [
        joinpath("notes", "Governing Equations and Turbulence Closure.md"),
        joinpath("notes", "Closures.md"),
        joinpath("notes", "Types.md"),
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
end

main()