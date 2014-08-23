# Cooking Infrastructure by Chef

Book about [Chef (DevOps tool)](http://www.getchef.com/chef/).

## Generate HTML

    pandoc -s -S --toc --latexmathml --highlight-style pygments -t html5 -s chef.tex -o index.html

## Generate Epub

    pandoc --smart -t epub3 -s chef.tex -o chef.epub --epub-cover-image=cover/cover.jpg --epub-chapter-level=3

If you want to see in the output were normal quotes (`U+00ab` &laquo;, `U+00bb` &raquo;), you need to put them first hand because pandoc until it is able to (https://github.com/jgm/pandoc/issues/84). For example, by using vim:

    vim -e - $(find . -name "*.tex") << EOF
    :bufdo %s/<</\\=nr2char("0x00ab")/ge | %s/>>/\\=nr2char("0x00bb")/ge | update
    EOF


## Mobi

http://www.epub2mobi.com/