EMACS   ?= emacs
PORT    ?= 8080
PUBDIR  ?= docs

.PHONY: default build serve watch _httpd publish clean help

default: build

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

# ── Publication GitHub Pages ─────────────────────────────────
# Commit dans le sous-module docs/ (= origin/master) + push branche source.
publish: build
	@test -f $(PUBDIR)/.nojekyll || touch $(PUBDIR)/.nojekyll
	cd $(PUBDIR) && \
	  git add -A && \
	  (git diff --cached --quiet || \
	    (git commit -m "publish $$(date -I)" && git push origin HEAD:master))
	git push origin HEAD

clean:
	rm -rf $(PUBDIR)/*.html $(PUBDIR)/teaching $(PUBDIR)/css

help:
	@echo "make build    — generate docs/ from src-org/"
	@echo "make serve    — build + serve docs/ locally + watch sources"
	@echo "make watch    — rebuild on source changes (no server)"
	@echo "make publish  — build + commit+push docs/ to GitHub Pages"
	@echo "make clean    — remove generated HTML"
