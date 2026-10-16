#!/usr/bin/env bash
# Create a new talk folder using the 16:9 talk template (Quarto extensions).
#
# usage:  ./create_new.sh <folder> [--light]
#
#   <folder>   path of the new presentation folder (must not exist, or be empty)
#   --light    use the light variant (default: dark)
#
# creates:
#   <folder>/_extensions/yzerlaut/   the template (quarto add yzerlaut/presentations,
#                                    or a copy of this repo's _extensions/ when offline)
#   <folder>/Talk.qmd                starter deck
#   <folder>/figure.svg              blank Inkscape canvas (full slide frame)
set -euo pipefail

usage() { sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

folder=""
variant="dark"
for arg in "$@"; do
    case "$arg" in
        --light) variant="light" ;;
        --dark) variant="dark" ;;
        -h|--help) usage ;;
        -*) echo "unknown option: $arg" >&2; usage ;;
        *) [ -z "$folder" ] && folder="$arg" || usage ;;
    esac
done
[ -n "$folder" ] || usage

command -v quarto >/dev/null || { echo "quarto not found (https://quarto.org)" >&2; exit 1; }
if [ -e "$folder" ] && [ -n "$(ls -A "$folder" 2>/dev/null)" ]; then
    echo "'$folder' already exists and is not empty" >&2; exit 1
fi

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$folder"
cd "$folder"

# --- template: from GitHub, or from this repo when offline
echo "installing the talk template..."
if ! quarto add yzerlaut/presentations --no-prompt >/dev/null 2>&1; then
    echo "  (GitHub not reachable, copying $repo/_extensions)"
    mkdir -p _extensions/yzerlaut
    cp -R "$repo"/_extensions/talk-* _extensions/yzerlaut/
fi

# --- blank figure canvas
cp "_extensions/yzerlaut/talk-$variant/frame.svg" figure.svg

# --- starter deck
title="$(basename "$folder" | tr '_-' '  ')"
cat > Talk.qmd <<EOF
---
title: "$title"
subtitle: "Lab Meeting"
author: "Yann Zerlaut"
date: "$(date +%Y-%m-%d)"
location: "Paris Brain Institute, Paris"
format:
  talk-$variant-revealjs:       # or talk-$( [ "$variant" = dark ] && echo light || echo dark )-revealjs
    transition: slide
---

## Introduction

- First point
- Second point

## A figure

<!-- figure.svg: blank 1180x570 canvas = the free area of a slide.
     Draw in Inkscape (each extra layer appears on the next click),
     or save a matplotlib figure made with plot_tools.set_style('slides-$variant') -->
![](figure.svg){.frame}

## Results {.top}

::: incremental
- First finding
- Second finding
:::

## {.thanks-slide data-state="is-thanks-slide"}

[Thank you for your attention]{.thanks-text}

[Questions?]{.thanks-questions}

## Acknowledgments

:::: {.columns}

::: {.column width="50%"}
### Lab members

- Name Surname
- Name Surname
:::

::: {.column width="50%"}
### Funding

::: {.funding-logos}
{{< talk-logo ICM >}}
{{< talk-logo SU >}}
:::
:::

::::
EOF

echo "created $folder/ ($variant variant):"
echo "  Talk.qmd     the deck   -> quarto preview $folder/Talk.qmd"
echo "  figure.svg   blank full-slide figure (Inkscape)"
