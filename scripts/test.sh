#!/bin/bash
# Compile manuscript and bibliography from repository root
latexmk -pdf Papers/JAS_Paper1/main.tex

# Clean build artifacts
latexmk -c Papers/JAS_Paper1/main.tex

# Validate references.bib for duplicate keys
uv run python -c "
import re
with open('Papers/BibTeX/references.bib') as f:
    keys = re.findall(r'@\w+\{([^,]+),', f.read())
dups = set([k for k in keys if keys.count(k) > 1])
print(f'Duplicates: {dups}' if dups else f'Valid: {len(keys)} entries.')
"