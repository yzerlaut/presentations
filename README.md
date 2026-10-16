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

## Decks

- `demo-presentation.qmd` — syntax demo
- `visual-stimulation-decoding.qmd` — Visual Stimulation for Decoding Ambiguous Visual Scenes (draft for Sofia)

## New deck

Copy an existing `.qmd`, rename it, edit. Slides are separated by `---`; slide titles are `# ` / `## ` headings. It renders automatically on push.

## Pairing with the other repos

- Draft ideas in **private-notes** daily notes, lift sections into a `.qmd` here
- Reference the analysis scripts that produced each figure by their **Lab-notebook** archive path
