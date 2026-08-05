# .latexmkrc
$pdf_mode = 1; # Generate PDF directly via pdflatex
$bibtex = 'biber'; # Or 'bibtex' depending on your manuscript package
$max_repeat = 5;

# Automatically monitor references.bib across subdirectories
@default_files = ('Papers/JAS_Paper1/main.tex');
