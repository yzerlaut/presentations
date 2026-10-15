# 🎤 Presentations

Quarto + reveal.js decks, rendered automatically by GitHub Actions and served on GitHub Pages.

## Usage (iPad)

The repo is plain markdown — edit the `.qmd` files in Obsidian, then:

```sh
alias sync='cd /mnt/notes/presentations && git pull && git add -A && git commit -m update; git push'
```

Push to `main` → GitHub Actions runs `quarto render` → the deck is live on Pages a minute later.

## Structure

- `slides/*.qmd` — one file per deck (`.qmd` = markdown + YAML header)
- `figures/` — images/SVGs referenced by slides
- `slides/_quarto.yml` — shared reveal.js theme options (slide numbers, scrollable slides, embedded resources)

## New deck

Copy `slides/demo-presentation.qmd`, rename it, edit. Slides are separated by `---`; slide titles are `# ` / `## ` headings. It renders automatically on push.

## Pairing with the other repos

- Draft ideas in **private-notes** daily notes, lift sections into a `.qmd` here
- Reference the analysis scripts that produced each figure by their **Lab-notebook** archive path

## One-time setup

Settings → Pages → Source: **GitHub Actions** (not "Deploy from a branch").
