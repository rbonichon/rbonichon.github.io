default: watch

.phony: watch publish

watch:
	(cd src; compass watch) & hugo server

PUBLISH_DIR = docs

publish: $(PUBLISH_DIR)
	hugo 
	(cd $(PUBLISH_DIR); \
	 git add *; \
	 git commit -am "publish"; \
	 git push -f origin master; \
	)


$(PUBLISH_DIR):
	git submodule add -b master \
	git@github.com:rbonichon/rbonichon.github.io.git 
	$@
