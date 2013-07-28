
preview: clean build
	./site preview

site:
	ghc --make site.hs

build: site
	./site rebuild

clean:
	rm site.hi site.o
	rm -rf _site _cache

github: build
	./tools/ghp-import
	git push origin gh-pages
	git branch -D gh-pages
