EMACS   ?= emacs
PORT    ?= 8080
PUBDIR  ?= docs
SRCBRANCH ?= src

.PHONY: default biblio build serve watch _httpd preview _preview-build _preview-watch _preview-httpd publish clean help

default: build

# ── Bibliographie : data/biblio.yml est la source unique ────
# rb-website-publish régénère src-org/biblio.org (rb-website-biblio) si le
# YAML est plus récent ; le CV Typst (~/code/typst) lit directement le YAML.
biblio:
	$(EMACS) --batch \
	  -l ~/.emacs.d/mylibs/rb-website.el \
	  --eval "(rb-website-biblio t)"

# ── Build one-shot ───────────────────────────────────────────
build:
	$(EMACS) --batch \
	  -l ~/.emacs.d/mylibs/rb-website.el \
	  --eval "(rb-website-publish t)"

# ── Preview local : build + server + watcher en parallèle ────
# Ouvre http://localhost:$(PORT) dans le navigateur.
serve: build
	@echo "→ Serving $(PUBDIR)/ on http://localhost:$(PORT)"
	@(sleep 1 && xdg-open http://localhost:$(PORT) 2>/dev/null) &
	@$(MAKE) -j2 watch _httpd

_httpd:
	cd $(PUBDIR) && python3 -m http.server $(PORT)

watch:
	@command -v inotifywait >/dev/null || \
	  { echo "inotifywait missing — install inotify-tools" >&2; exit 1; }
	@echo "→ Watching src-org/ css/ templates/ for changes (Ctrl-C to stop)"
	@while inotifywait -qq -r -e modify,create,delete,move \
	         src-org/ css/ templates/; do \
	   $(EMACS) --batch \
	     -l ~/.emacs.d/mylibs/rb-website.el \
	     --eval "(rb-website-publish nil)" ; \
	 done

# ── Preview avec brouillons : _preview/ (hors git), drafts/ → /drafts/ ──
preview: _preview-build
	@echo "→ Serving _preview/ on http://localhost:$(PORT) (drafts under /drafts/)"
	@(sleep 1 && xdg-open http://localhost:$(PORT)/drafts/ 2>/dev/null) &
	@$(MAKE) -j2 _preview-watch _preview-httpd

_preview-build:
	$(EMACS) --batch \
	  -l ~/.emacs.d/mylibs/rb-website.el \
	  --eval "(rb-website-preview t)"

_preview-httpd:
	cd _preview && python3 -m http.server $(PORT)

_preview-watch:
	@command -v inotifywait >/dev/null || \
	  { echo "inotifywait missing — install inotify-tools" >&2; exit 1; }
	@echo "→ Watching src-org/ drafts/ css/ templates/ for changes (Ctrl-C to stop)"
	@while inotifywait -qq -r -e modify,create,delete,move \
	         src-org/ drafts/ css/ templates/; do \
	   $(EMACS) --batch \
	     -l ~/.emacs.d/mylibs/rb-website.el \
	     --eval "(rb-website-preview nil)" ; \
	 done

# ── Publication GitHub Pages ─────────────────────────────────
# Commit dans le sous-module docs/ (= origin/master), puis enregistre le
# nouveau pointeur du sous-module sur $(SRCBRANCH) et pousse les deux.
# Refuse de tourner hors de $(SRCBRANCH) : la branche source poussée doit
# être celle qui référence le site publié.
publish:
	@branch=$$(git rev-parse --abbrev-ref HEAD); \
	 test "$$branch" = "$(SRCBRANCH)" || \
	   { echo "publish: on '$$branch', switch to '$(SRCBRANCH)' first" >&2; exit 1; }
	$(MAKE) build
	@test -f $(PUBDIR)/.nojekyll || touch $(PUBDIR)/.nojekyll
	cd $(PUBDIR) && \
	  git add -A && \
	  (git diff --cached --quiet || git commit -m "publish $$(date -I)") && \
	  git push origin HEAD:master
	git diff HEAD --quiet -- $(PUBDIR) || \
	  git commit -m "$(PUBDIR): publish $$(date -I)" -- $(PUBDIR)
	git push origin HEAD:$(SRCBRANCH)

clean:
	rm -rf $(PUBDIR)/*.html $(PUBDIR)/teaching $(PUBDIR)/css

help:
	@echo "make biblio   — regenerate src-org/biblio.org from data/biblio.yml"
	@echo "make build    — generate docs/ from src-org/"
	@echo "make serve    — build + serve docs/ locally + watch sources"
	@echo "make watch    — rebuild on source changes (no server)"
	@echo "make preview  — like serve, plus drafts/, into _preview/ (never published)"
	@echo "make publish  — build + commit+push docs/ to GitHub Pages, record it on src"
	@echo "make clean    — remove generated HTML"
