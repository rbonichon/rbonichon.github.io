default: watch

.phony: watch publish

watch:
	(cd src; compass watch) & hugo server

PUBLISH_DIR = docs

publish:
	hugo 
	(cd $(PUBLISH_DIR))
