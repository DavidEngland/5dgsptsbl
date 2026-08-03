.PHONY: bootstrap cases99 manifold figures assemble-manuscript paper paper-all clean

LATEXMK ?= latexmk
LATEXMKFLAGS ?= -pdf -interaction=nonstopmode -halt-on-error -file-line-error

bootstrap:
	julia --project=. -e 'using Pkg; Pkg.instantiate()'

cases99:
	julia --project=. scripts/run_cases99.jl

manifold:
	julia --project=. scripts/plot_manifold.jl

figures: cases99 manifold

assemble-manuscript:
	mkdir -p reports/generated/figures
	@if [ -d paper/figures ]; then cp -r paper/figures/* reports/generated/figures/ 2>/dev/null || true; fi
	julia --project=. scripts/assemble_manuscript.jl

paper: assemble-manuscript
	@if command -v $(LATEXMK) >/dev/null 2>&1; then \
		$(LATEXMK) $(LATEXMKFLAGS) -outdir=reports/generated reports/generated/paper.tex; \
	else \
		pdflatex -interaction=nonstopmode -halt-on-error -output-directory reports/generated reports/generated/paper.tex; \
		pdflatex -interaction=nonstopmode -halt-on-error -output-directory reports/generated reports/generated/paper.tex; \
	fi

paper-all: figures paper

clean:
	rm -rf reports/generated