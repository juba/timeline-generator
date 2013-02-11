## OVERVIEW

A PDF timeline generator.

This is a Ruby script generating a LaTeX/TikZ file and invoking
pdflatex appropriately to generate a timeline given a set of
parameters (start date, end date, date intervals, etc.). Almost every
aspect of the timeline can be modified with the settings : just check
one of the default config files.

The output is a PDF file which can be automatically split between a
given number of A4 pages in portrait or landscape orientation. The
split includes crop marks and a small overlapping to make cut and
pasting easier.

Optionaly, a calendar scale (days and months of year) and a time of
day scale (hours and minutes) can be added at the bottom of the
timeline. The idea is to allow some comparisons such as *«if the 0 to
2010 timeline was a day, the World War II would have take place
between 23h09 and 23h14. If it was a year, it would have happened
between December 18th and December 20th»*.

You can find two examples of generated files in the `examples`
directory. It is a 0 to 2010 timeline with the calendar and time of
day scales on 5 A4 landscape pages. Months names and title are in
french. The `output.pdf` file is just one big page, and
`output_pages.pdf` is the result of the split between the 5 pages.

## REQUIREMENTS

- Ruby
- PDFLaTeX with the *tikz*, *geometry*, *numprint* and *pdfpages* packages installed
- Optionally, the *lmodern* LaTeX package for non ASCII characters

Under Debian/Ubuntu, the following should be sufficient to meet the requirements :

    $ sudo apt-get install texlive texlive-pictures lmodern texlive-latex-base texlive-latex-extra ruby


## INSTALLATION AND USAGE

- Download `timeline.rb`
- Download one of the `config_francais.rb` or `config_english.rb` files
- Edit the previous config file to your needs

Then run the script with : 

    ./timeline.rb config_english.rb

or :

    ./timeline.rb config_francais.rb

If everything went well, check the two generated PDF files.

## KNOWN LIMITATIONS

- only works with A4 paper
- only french and english supported for the moment
- code lacks many improvements and verifications


