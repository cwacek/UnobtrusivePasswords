JS_SRC = unobtrusive.js 

all: $(JS_SRC)

.PHONY: all

%.js: %.coffee
	coffee -c $<

clean:
	rm $(JS_SRC)
