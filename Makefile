#  This makefile generates the eBooks from the HTML files using Pandoc

# This is the version of the build system, just to tell apart different renderings
# Build 1 is everything came before the numbering scheme =)
BUILD = 2

#Set the correct shell
#Under Ubuntu, for example, /bin/sh point to /bin/dash
#which does not support "[[" and other bash things
SHELL = /bin/bash

#  Constants
DIR = _build
OUTPUT = Practical_Common_Lisp
KINDLEGEN = $(which kindlegen)
GENERALOPTS = --standalone --table-of-contents -V title:"Practical Common Lisp" -V author:"Peter Seibel" -V date:"June 29, 2012 - Build ${BUILD}"
PDFOPTS = --top-level-division=chapter ${GENERALOPTS}
EPUBOPTS = ${GENERALOPTS}
HTML_FILES = index.html blurbs.html letter-to-reader.html introduction-why-lisp.html lather-rinse-repeat-a-tour-of-the-repl.html practical-a-simple-database.html syntax-and-semantics.html functions.html variables.html macros-standard-control-constructs.html macros-defining-your-own.html practical-building-a-unit-test-framework.html numbers-characters-and-strings.html collections.html they-called-it-lisp-for-a-reason-list-processing.html beyond-lists-other-uses-for-cons-cells.html files-and-file-io.html practical-a-portable-pathname-library.html object-reorientation-generic-functions.html object-reorientation-classes.html a-few-format-recipes.html beyond-exception-handling-conditions-and-restarts.html the-special-operators.html programming-in-the-large-packages-and-symbols.html loop-for-black-belts.html practical-a-spam-filter.html practical-parsing-binary-files.html practical-an-id3-parser.html practical-web-programming-with-allegroserve.html practical-an-mp3-database.html practical-a-shoutcast-server.html practical-an-mp3-browser.html practical-an-html-generation-library-the-interpreter.html practical-an-html-generation-library-the-compiler.html conclusion-whats-next.html
MD_FILES = index.md blurbs.md letter-to-reader.md introduction-why-lisp.md lather-rinse-repeat-a-tour-of-the-repl.md practical-a-simple-database.md syntax-and-semantics.md functions.md variables.md macros-standard-control-constructs.md macros-defining-your-own.md practical-building-a-unit-test-framework.md numbers-characters-and-strings.md collections.md they-called-it-lisp-for-a-reason-list-processing.md beyond-lists-other-uses-for-cons-cells.md files-and-file-io.md practical-a-portable-pathname-library.md object-reorientation-generic-functions.md object-reorientation-classes.md a-few-format-recipes.md beyond-exception-handling-conditions-and-restarts.md the-special-operators.md programming-in-the-large-packages-and-symbols.md loop-for-black-belts.md practical-a-spam-filter.md practical-parsing-binary-files.md practical-an-id3-parser.md practical-web-programming-with-allegroserve.md practical-an-mp3-database.md practical-a-shoutcast-server.md practical-an-mp3-browser.md practical-an-html-generation-library-the-interpreter.md practical-an-html-generation-library-the-compiler.md conclusion-whats-next.md


#  ---------------------------------
#  Public targets
all: clean create_pdf create_epub create_kindle remove_files

pdf: clean create_pdf remove_files

epub: clean create_epub remove_files

kindle: clean create_kindle remove_files

clean:
	if [ -d "${DIR}" ]; \
		then rm -r ${DIR}; \
	fi

#  ---------------------------------
#  Private targets
#  If the build directory does not exist, create it
create_folder:
	if [ ! -d "${DIR}" ]; then \
		mkdir ${DIR}; \
		mkdir ${DIR}/figures; \
		mkdir ${DIR}/screenshots; \
		cp html/* ${DIR}; \
		cp html/figures/* ${DIR}/figures; \
		cp html/screenshots/* ${DIR}/screenshots; \
	fi

#  Generate PDF
create_pdf: create_folder
	cd ${DIR}; \
	pandoc ${PDFOPTS} -o ${OUTPUT}.pdf ${MD_FILES}

#  Generate EPUB
create_epub: create_folder
	cd ${DIR}; \
	pandoc ${EPUBOPTS} -o ${OUTPUT}.epub ${MD_FILES}

#  Create Kindle version (ignoring the error that it outputs)
create_kindle: create_epub
	@if [[ ! -z "${KINDLEGEN}" ]]; then ${KINDLEGEN} ${DIR}/${OUTPUT}.epub; else echo "KindleGen cannot be found - unable to create Kindle format"; fi

#  Clean up, so that only the product files remain
remove_files: create_folder
	cd ${DIR}; \
	rm -f *.png; \
	rm -f *.jpg; \
	rm -f *.css; \
	rm -rf figures/; \
	rm -rf screenshots/; \
	rm -f *.html

