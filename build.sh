#!/usr/bin/env sh

echo "Making the website..."
rm -f html/*
jupyter nbconvert --output-dir=html --to html *.ipynb
mkdir html/fig
cp fig/example_traceback.png html/fig/
cp fig/list-indexing.png html/fig/
cp LICENSE html/
cd html/
sed -i .bak 's/ipynb/html/g' *.html
rm -f *.bak
cd ..
echo "done."

echo "Making the book..."
rm -f merged.ipynb
python nbmerge.py *.ipynb > merged.ipynb
jupyter nbconvert --to latex merged.ipynb

sed -i.bak 's/\\section{A Whirlwind Tour/\\section*{\\huge A Whirlwind Tour/g' merged.tex
sed -i.bak 's/\\begin{figure}/\\begin{figure}\[h!\]/g' merged.tex

# delete ipynb toc
#sed -i.bak -e '302,342d' merged.tex
sed -i.bak -e '325,368d' merged.tex
sed -i.bak 's/\\subsection{Contents}\\label{contents}/\\setcounter{tocdepth}{2}\\tableofcontents{}/g' merged.tex
sed -i.bak 's/\\maketitle//g' merged.tex
sed -i.bak 's/\\subsection{License and Citation}/\\subsection*{License and Citation}/g' merged.tex
sed -i.bak 's/This mini-text serves/\\bigskip{}This mini-text serves/g' merged.tex


# fix internal links
sed -i.bak 's/\\href{07-Built-in-Data-Structures.ipynb\\#Lists}/\\hyperref\[lists\]/g' merged.tex
sed -i.bak 's/\\href{13-Iterators-and-List-Comprehensions.ipynb}/\\hyperref\[iterators-and-list-comprehensions\]/g' merged.tex
sed -i.bak 's/\\href{18-Further-Resources.ipynb}/\\hyperref\[resources-for-further-learning\]/g' merged.tex
sed -i.bak 's/\\href{05-Semantics-Operators.ipynb}/\\hyperref\[basic-python-semantics-operators\]/g' merged.tex
sed -i.bak 's/\\href{08-Strings.ipynb}/\\hyperref\[string-manipulation\]/g' merged.tex


# run the latex:
latexmk -pdf merged.tex
mv merged.pdf WhirlwindTourPython-STATCS287.pdf

# clean it all up:
rm -f merged.ipynb merged.tex.bak
rm -rf merged_files
latexmk -CA merged.tex
rm -f merged.tex
echo "done"
