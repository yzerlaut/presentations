# 🎤 Presentations

Quarto + reveal.js decks. GitHub Actions renders every push and **commits the self-contained HTML** into `docs/`, which is served by **GitHub Pages**.

## View the slides

**https://yzerlaut.github.io/presentations/slides/visual-stimulation-decoding.html**

(replace the filename to open another deck — see the list below)

## Usage (iPad)

The repo is plain markdown — edit the `.qmd` files in Obsidian, then:

```sh
alias sync='cd /mnt/notes/presentations && git pull && git add -A && git commit -m update; git push'
```

Push to `main` → GitHub Actions renders → the HTML lands in `docs/` → live on Pages a minute later. `git pull` also gives you the self-contained HTML locally for offline use.

## Structure

- `slides/*.qmd` — one file per deck (`.qmd` = markdown + YAML header)
- `figures/` — images/SVGs referenced by slides
- `docs/` — rendered output (auto-committed, don't edit by hand)
- `slides/_quarto.yml` — shared reveal.js options (slide numbers, scrollable slides, embedded resources)
- `_extensions/` — 16:9 talk template (Quarto extensions `talk-dark`, `talk-light`), see below

## Decks

- `demo-presentation.qmd` — syntax demo
- `Template.qmd` — talk template showcase (title slide, frame figure, thanks & acknowledgments)
- `visual-stimulation-decoding.qmd` — Visual Stimulation for Decoding Ambiguous Visual Scenes (draft for Sofia)

## New deck

Copy an existing `.qmd`, rename it, edit. Slides are separated by `---`; slide titles are `# ` / `## ` headings. It renders automatically on push.

## Talk template (Quarto extension, usable from anywhere)

16:9 talk template in two variants, packaged as Quarto extensions in `_extensions/`:
`talk-dark`, `talk-light` (+ `talk-common`, the shared layout, filters & title slide).

### Create a new talk

```sh
./create_new.sh ~/talks/lab-meeting-11-2026            # dark variant
./create_new.sh ~/talks/journal-club --light           # light variant
```

creates the folder with:

- `_extensions/yzerlaut/` — the template (from GitHub via `quarto add`; copied from this repo when offline)
- `Talk.qmd` — starter deck: title slide (title from the folder name, today's date), text, figure, incremental list, thanks and acknowledgments slides
- `figure.svg` — blank full-slide canvas to draw in (Inkscape)

then `quarto preview <folder>/Talk.qmd` (or `Cmd+Shift+K` in VS Code) and edit.
The folder must not exist yet (or be empty).

### Use the template in an existing folder

**Install** (copies the extensions into `./_extensions/`):

```sh
quarto add yzerlaut/presentations
```

**In the deck:**

```yaml
---
title: "My talk"
subtitle: "Lab Meeting"
author: "Yann Zerlaut"
date: "2026-10-16"
location: "Paris Brain Institute, Paris"
format: talk-dark-revealjs        # or talk-light-revealjs
---
```

- full example: `slides/Template.qmd` (decks in `slides/` use the extensions through the `slides/_extensions` link)
- figures filling a slide: copy `_extensions/talk-<variant>/frame.svg` (1180×570 = slide content area), draw, then `![](my-figure.svg){.frame}`; with several Inkscape layers, the layers appear one per click. Matplotlib: `plot_tools.set_style('slides-dark')` / `'slides-light'` gives the same size
- logos of the current variant: `{{< talk-logo ICM >}}`, `{{< talk-logo SU >}}`
- vertical space: `{{< vspace 3em >}}` (any CSS length: `2em`, `40px`, ...; a bare number means `em`; default `1em`), on its own line or inside a paragraph
- horizontal space in a line: `Label{{< hspace 4em >}}value` (same units, default `1em`); at the start of a line it indents that line
- references / credits at the bottom of a slide (small, muted, above the bottom line): a `::: aside` block (or `::: {.ref}`) anywhere in the slide
- slide layout: `## Title {indent=5em spacing=0.8em}` sets the left indent of the slide content (default `4em`) and the vertical gap between items (paragraphs, lists, list items; default `1.5em`); deck-wide defaults in the YAML header: `slide-indent: 4em`, `slide-spacing: 0.6em` (a slide's own options win)
- closing slide: `## {.thanks-slide data-state="is-thanks-slide"}`; top-aligned slide: `## Title {.top}`
- update a deck's copy of the template: `quarto update yzerlaut/presentations`

## Pairing with the other repos

- Draft ideas in **private-notes** daily notes, lift sections into a `.qmd` here
- Reference the analysis scripts that produced each figure by their **Lab-notebook** archive path
