# OVERVIEW

A PDF timeline generator.

This is a Ruby script generating a LaTeX/TikZ file and invoking pdflatex appropriately to generate a timeline given a set of parameters (start date, end date, date intervals, etc.).

The output is a PDF file which can be split between a given number of A4 pages in portrait or landscape orientation. The split includes crop marks and a small overlapping to make cut and pasting easier.

Optionaly, a calendar scale (days and months of year) and a time of day scale (hours and minutes) can be added at the bottom of the timeline. The idea is to allow some comparisons such as «if the 0 to 2010 timeline was a day, the World War II would have occur between 23h09 and 23h14. if it was a year, it would have occur between December 18th and December 20th». 
# REQUIREMENTS

- Ruby
- PDFLaTeX with the tikz, geometry and pdfpages packages installed

# INSTALLATION

- Just edit the timeline.rb file after editing it to your needs

# KNOWN LIMITATIONS

- only works with A4 paper
- no easy way (graphical or command line) to pass parameters
- very badly documented
