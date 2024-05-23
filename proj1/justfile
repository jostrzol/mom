build:
  pandoc \
    -V lang=pl \
    -H disable_float.tex \
    -f markdown+tex_math_dollars+pipe_tables+yaml_metadata_block \
    -F mermaid-filter \
    -o report.pdf \
    report.md
