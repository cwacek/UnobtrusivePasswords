JS_SRC = unobtrusive.js
BUILD_DIR = build
SOURCES = img lib gear_wheel.png icon.png autocomplete.js unobtrusive.js
SOURCES += p_form.html p_settings.html popup.html popup.css manifest.json

all: $(JS_SRC)

.PHONY: all clean dist

%.js: %.coffee
	coffee -c $<

clean:
	-rm $(JS_SRC)
	-rm -r $(BUILD_DIR)

dist: $(JS_SRC)
	mkdir -p $(BUILD_DIR)
	cp -R $(SOURCES) $(BUILD_DIR)
	cd $(BUILD_DIR) && zip -r UnobtrusivePasswords.zip $(SOURCES)
