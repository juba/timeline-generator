## OVERVIEW

A PDF timeline generator.

This is a Ruby script generating a LaTeX/TikZ file and invoking pdflatex appropriately to generate a timeline given a set of parameters (start date, end date, date intervals, etc.). Almost every aspect of the timeline can be modified with the settings : just check the beginning of `timeline.rb`.

The output is a PDF file which can be split between a given number of A4 pages in portrait or landscape orientation. The split includes crop marks and a small overlapping to make cut and pasting easier.

Optionaly, a calendar scale (days and months of year) and a time of day scale (hours and minutes) can be added at the bottom of the timeline. The idea is to allow some comparisons such as *«if the 0 to 2010 timeline was a day, the World War II would have take place between 23h09 and 23h14. if it was a year, it would have happened between December 18th and December 20th»*. 

You can find two examples of output files in the `examples` directory. It is a 0 to 2010 timeline with the calendar and time of day scales on 5 A4 landscape pages. Months names and title are in french. The `output.pdf` file is just one big page, and `output_pages.pdf` is the result of the split between the 5 pages.

## REQUIREMENTS

- Ruby
- PDFLaTeX with the tikz, geometry and pdfpages packages installed

## INSTALLATION

- Just edit the timeline.rb file after editing it to your needs

## KNOWN LIMITATIONS

- only works with A4 paper
- no easy way (graphical or command line) to pass parameters
- very badly documented
- first and last pages also have crop marks on both sides
