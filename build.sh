#!/usr/bin/env sh

echo "Making the website..."
jupyter nbconvert --output-dir=html --to html *.ipynb
cd html/
sed -i .bak 's/ipynb/html/g' *.html
rm -f *.bak
cd ..
echo "done."

echo "Making the book..."
rm -f merged.ipynb
python nbmerge.py *.ipynb > merged.ipynb
jupyter nbconvert --to latex merged.ipynb
#sed -i.bak 's/\\title{merged}/\\title{A Whirlwind Tour of Python for STAT\/CS 287}/g' merged.tex

sed -i.bak 's/\\section{A Whirlwind Tour/\\section*{\\huge A Whirlwind Tour/g' merged.tex

# delete ipynb toc
sed -i.bak -e '301,341d' merged.tex
sed -i.bak 's/\\subsection{Contents}\\label{contents}/\\setcounter{tocdepth}{2}\\tableofcontents{}/g' merged.tex
sed -i.bak 's/\\maketitle//g' merged.tex
sed -i.bak 's/\\subsection{License and Citation}/\\subsection*{License and Citation}/g' merged.tex
sed -i.bak 's/This mini-text serves/\\bigskip{}This mini-text serves/g' merged.tex

latexmk merged.tex
mv merged.pdf WhirlwindTourPython-STATCS287.pdf

rm -f merged.ipynb merged.tex.bak
rm -rf merged_files
latexmk -CA merged.tex
rm -f merged.tex
echo "done"
