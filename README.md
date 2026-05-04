# trungtpham.github.io

Personal site of Trung Pham — Principal Research Scientist at NVIDIA Cosmos Lab.

Plain HTML + CSS. No build step, no frameworks, no Jekyll. The whole site is two pages, one stylesheet, and a few lines of JavaScript for the dark-mode toggle.

## Preview locally

Just open `index.html` in your browser:

```bash
open ~/Documents/trungtpham.github.io/index.html
```

That's it. Refresh after each edit. (For nicer absolute-path behavior — the 404 page uses `/`-prefixed URLs — you can optionally serve the folder with Python's built-in HTTP server: `python3 -m http.server 4000` and visit <http://127.0.0.1:4000>.)

## Deploy

GitHub Pages serves the repo as-is. The `.nojekyll` file at the root tells Pages "no build, just publish files." Push to `main` and you're live.

```bash
git add .
git commit -m "Refresh personal site"
git push
```

## What goes where

| To change… | Edit… |
|---|---|
| Bio, news, contact pills | `index.html` |
| Publications | `publications.html` |
| Colors, typography, spacing | `assets/css/style.css` |
| Dark-mode toggle behavior | `assets/js/theme.js` |
| Favicon | `assets/img/favicon.svg` |
| Profile photo | drop a square JPG at `assets/img/profile.jpg` (it auto-hides if missing) |

## Design notes

- Typography: Instrument Serif (hero name), Inter (body), JetBrains Mono (dates, venues, link tags). Loaded from Google Fonts.
- Accent color: NVIDIA green (`#76B900`), used sparingly — name highlight, link hover underline, the favicon.
- Auto light/dark with system-preference default and a manual toggle (preference is saved to `localStorage`).
- ~720 px reading column, generous whitespace, fully responsive.
- The two pages duplicate the header/footer markup — that's intentional; with only two pages it's far simpler than introducing a templating system.
