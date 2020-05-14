# Germanic
A book on Germanic syntax

Tested with texlive 2020.

You have to add the searchpath "./langci//" to your TEXINPUT:

setenv TEXINPUTS ${TEXINPUTS}:./langsci//:


The project uses memoize, a new package for externalizing figures. If you run into problems with memoize, please uncomment the line \usepackage{./styles/memoize} in
localpackages.tex

