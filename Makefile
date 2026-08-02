.PHONY: bootstrap cases99 manifold assemble-manuscript paper clean

LATEXMK ?= latexmk
LATEXMKFLAGS ?= -pdf -interaction=nonstopmode -halt-on-error -file-line-error

bootstrap:
	julia --project=. -e 'using Pkg; Pkg.instantiate()'

cases99:
	julia --project=. scripts/run_cases99.jl

manifold:
	julia --project=. scripts/plot_manifold.jl

assemble-manuscript:
	julia --project=. scripts/assemble_manuscript.jl

paper: assemble-manuscript
	@if command -v $(LATEXMK) >/dev/null 2>&1; then \
		$(LATEXMK) $(LATEXMKFLAGS) -outdir=reports/generated reports/generated/paper.tex; \
	else \
		pdflatex -interaction=nonstopmode -halt-on-error -output-directory reports/generated reports/generated/paper.tex; \
		pdflatex -interaction=nonstopmode -halt-on-error -output-directory reports/generated reports/generated/paper.tex; \
	fi

clean:
	rm -rf reports/generated