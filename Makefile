STYLE-PATH= ${HOME}/Library/texmf/tex/latex/
LANGSCI-PATH=~/Documents/Dienstlich/Projekte/LangSci/Git-HUB/latex/


all: germanic.pdf


SOURCE=/Users/stefan/Documents/Dienstlich/Bibliographien/biblio.bib $(wildcard *.tex)

.SUFFIXES: .tex


%.pdf: %.tex $(SOURCE)
	xelatex -shell-escape -no-pdf $* |grep -v math
	biber $*
	xelatex -shell-escape -no-pdf $* |grep -v math
	biber $*
	xelatex $* -shell-escape -no-pdf |egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'
	correct-toappear
	correct-index
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.adx
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.ldx
	sed -i.backup 's/\\protect \\active@dq \\dq@prtct {=}/"=/g' *.adx
	sed -i.backup 's/{\\O }/Oe/' *.adx
	python3 fixindex.py
	mv $*mod.adx $*.adx
	sed -i.backup 's/\\MakeCapital //g' *.adx
	makeindex -gs index.format-plus -o $*.and $*.adx
	makeindex -gs index.format -o $*.ind $*.idx
	makeindex -gs index.format -o $*.lnd $*.ldx
	xelatex -shell-escape $* | egrep -v 'math|PDFDocEncod|\\mark' |egrep 'Warning|label'



# http://stackoverflow.com/questions/10934456/imagemagick-pdf-to-jpgs-sometimes-results-in-black-background
cover: germanic.pdf
	convert $<\[0\] -resize 486x -background white -alpha remove -bordercolor black -border 2  cover.png


# fuer Sprachenindex
#	makeindex -gs index.format -o $*.lnd $*.ldx


lsp-styles:
	rsync -a $(LSP-STYLES) LSP/




public: germanic.pdf
	cp $? /Users/stefan/public_html/Pub/


/Users/stefan/public_html/Pub/germanic.pdf: germanic.pdf
	cp -p $?                      /Users/stefan/public_html/Pub/


commit:
	svn commit -m "published version to the web"

forest-commit:
	git add germanic.for.dir/*.pdf
	git commit -m "forest trees" germanic.for.dir/*.pdf germanic.for
	git push -u origin


o-public: o-public-lehrbuch 
#commit 
#o-public-bib

o-public-lehrbuch: /Users/stefan/public_html/Pub/germanic.pdf 
	scp -p $? hpsg.hu-berlin.de:/home/stefan/public_html/Pub/



PUB_FILE=stmue.bib

o-public-bib: $(PUB_FILE)
	scp -p $? home.hpsg.fu-berlin.de:/home/stefan/public_html/Pub/



#-f '(author){%n(author)}{%n(editor)}:{%2d(year)#%s(year)#no-year}'

#$(IN_FILE).dvi
$(PUB_FILE): ../hpsg/make_bib_header ../hpsg/make_bib_html_number  ../hpsg/.bibtool77-no-comments grammatical-theory.aux ../hpsg/la.aux ../HPSG-Lehrbuch/hpsg-lehrbuch.aux ../complex/complex-csli.aux 
	sort -u grammatical-theory.aux ../hpsg/la.aux ../HPSG-Lehrbuch/hpsg-lehrbuch.aux ../complex/complex-csli.aux  >tmp.aux
	bibtool -r ../hpsg/.bibtool77-no-comments  -x tmp.aux -o $(PUB_FILE).tmp
	sed -e 's/-u//g'  $(PUB_FILE).tmp  >$(PUB_FILE).tmp.neu
	../hpsg/make_bib_header
	cat bib_header.txt $(PUB_FILE).tmp.neu > $(PUB_FILE)
	rm $(PUB_FILE).tmp $(PUB_FILE).tmp.neu



# xelatex has to be run two times + biber to get "also printed as ..." right.
germanic.bib: ../../Bibliographien/biblio.bib $(SOURCE) langsci.dbx bib-creation.tex
	xelatex -no-pdf -interaction=nonstopmode -shell-escape bib-creation 
	biber bib-creation
	xelatex -no-pdf -interaction=nonstopmode -shell-escape bib-creation
	biber --output_format=bibtex --output-resolve-xdata --output-legacy-date bib-creation.bcf -O germanic_tmp.bib
	biber --tool --configfile=biber-tool.conf --output-field-replace=location:address,journaltitle:journal --output-legacy-date germanic_tmp.bib -O germanic.bib

memos:
	xelatex -shell-escape germanic
	python3 styles/memoize/memomanager.py split germanic.mmz

memo-install:
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/memoize* .
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/nomemoize* .
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/xparse-arglist.sty .
	cp -pr ~/Documents/Dienstlich/Projekte/memoize/memomanager.py .


avm-install:
	cp -fp ~/Documents/Dienstlich/Projekte/LangSci/Git-HUB/langsci-avm/langsci-avm.sty .


install:
	cp -p ${STYLE-PATH}makros.2020.sty styles/
	cp -p ${STYLE-PATH}abbrev.sty    styles/
	cp -p ${STYLE-PATH}mycommands.sty    styles/
	cp -p ${STYLE-PATH}fixcitep.sty  styles/
	cp -p ${STYLE-PATH}eng-date.sty   styles/
	cp -p ${STYLE-PATH}oneline.sty   styles/
	cp -p ${STYLE-PATH}Ling/article-ex.sty           styles/
	cp -p ${STYLE-PATH}Ling/merkmalstruktur.sty      styles/
	cp -p ${STYLE-PATH}Ling/my-xspace.sty            styles/
	cp -p ${STYLE-PATH}Ling/my-ccg-ohne-colortbl.sty styles/
	cp -p ${STYLE-PATH}Ling/forest.sty               styles/
	cp -p ${STYLE-PATH}Ling/my-gb4e-slides.sty       styles/
	cp -p ${STYLE-PATH}Ling/cgloss.sty               styles/
	cp -p ${STYLE-PATH}Ling/jambox.sty               styles/
	cp -p ${LANGSCI-PATH}langsci-forest-setup.sty    .


#bib-stuff


source: 
	tar chzvf ~/Downloads/germanic.tgz *.tex styles/*.sty LSP/


clean:
	rm -f *.bak *~ *.log *.blg *.bbl *.aux *.toc *.cut *.out *.tpm *.adx *.idx *.ilg *.ind *.and *.glg *.glo *.gls *.657pk *.adx.hyp *.bbl.old *.backup *.mw *.bcf *.lnd *.ldx *.rdx *.sdx *.wdx *.xdv *.run.xml *.aux.copy *.auxlock

check-clean:
	rm -f *.bak *~ *.log *.blg complex-draft.dvi


cleanmemo:
	rm -f *.mmz chapters/*.mmz germanic.memo.dir/*

realclean: clean
	rm -f *.dvi *.ps *.pdf chapters/*.pdf

brutal-clean: realclean cleanmemo


