default: watch

.phony: watch publish

watch:
	hugo server

PUBLISH_DIR = docs

publish: $(PUBLISH_DIR)
	hugo 
	(cd $(PUBLISH_DIR); \
	 touch .nojekyll; \
	 git add -f *; \
	 git commit -am "publish"; \
	 git push -f origin master; \
	)

# I seem to type make push a lot instead of make publish
push: publish

$(PUBLISH_DIR):
	git submodule add -b master \
	git@github.com:rbonichon/rbonichon.github.io.git \
	$@

clean_publish:
	git rm $(PUBLISH_DIR)
