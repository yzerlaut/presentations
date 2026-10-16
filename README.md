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
- `slides/light/`, `slides/dark/`, `slides/common.scss`, `slides/*.lua`, `slides/title-slide.html` — 16:9 talk template (light & dark variants), see below

## Decks

- `demo-presentation.qmd` — syntax demo
- `Template.qmd` — talk template showcase (title slide, frame figure, thanks & acknowledgments)
- `visual-stimulation-decoding.qmd` — Visual Stimulation for Decoding Ambiguous Visual Scenes (draft for Sofia)

## New deck

Copy an existing `.qmd`, rename it, edit. Slides are separated by `---`; slide titles are `# ` / `## ` headings. It renders automatically on push.

## Talk template

Start from `slides/Template.qmd` (decks must sit in `slides/`: the template paths are relative to the deck). The variant is one line in the YAML header:

```yaml
metadata-files: [dark/talk.yml]   # or light/talk.yml
date: "2026-10-16"
location: "Paris Brain Institute, Paris"
```

- `common.scss` — shared layout (16:9, title lines, bottom line + logo, centered content); `<variant>/colors.scss` — colors
- `<variant>/talk.yml` — theme, logo, filters, title-slide background (`talk-bg`)
- `title-slide.html` — title slide with `date` + `location`
- `<variant>/frame.svg` — blank Inkscape canvas (1180×570 = slide content area); copy it, draw, then `![](my-figure.svg){.frame}`. With several Inkscape layers, the layers appear one per click (`svg-layers.lua`)
- closing slide: `## {.thanks-slide data-state="is-thanks-slide"}`; top-aligned slide: `## Title {.top}`

## Pairing with the other repos

- Draft ideas in **private-notes** daily notes, lift sections into a `.qmd` here
- Reference the analysis scripts that produced each figure by their **Lab-notebook** archive path
