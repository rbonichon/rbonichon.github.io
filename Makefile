default: watch

.phony: watch publish

watch:
	(cd src; compass watch) & hugo server

PUBLISH_DIR = docs

publish: $(PUBLISH_DIR)
	hugo 
	(cd $(PUBLISH_DIR); \
	 git add -f *; \
	 git commit -am "publish"; \
	 git push -f origin master; \
	)

# I seem to type make push a lot instead of make publish
push: publish

$(PUBLISH_DIR):
	mkdir -p $(PUBLISH_DIR)
	git submodule add -b master \
	git@github.com:rbonichon/rbonichon.github.io.git \
	$@
