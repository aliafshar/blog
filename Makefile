
preview: clean build
	./site preview

build:
	ghc --make site.hs

clean:
	rm site.hi site.o
	rm -rf _site _cache
