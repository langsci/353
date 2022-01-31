# Germanic
A book on Germanic syntax

Tested with texlive 2020.


The project uses memoize, a new package for externalizing figures by Sašo Živanović.

https://github.com/sasozivanovic/memoize

If you run into problems with memoize, please comment out the line \usepackage{./styles/memoize} in
localpackages.tex by adding the % sign at the beginning of the line.



## Externalization

Externalization works by compiling germanic.tex with the -shell-escape directive. A much fast way is to use a python script. To do this, you need to install python3 and a python module for manipulating PDFs:

brew cask install python

and you have to install the pdfrw module:

python3 -m pip install pdfrw

After having done this, you can call the script like this (assuming that you xelatexed germanic.tex once):

python3 memomanager.py split main.mmz
