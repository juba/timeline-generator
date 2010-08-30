### MAIN OPTIONS

## Main title
@title = "Main title"

## Language ("francais" or "english")
@language = "english"

## Number of a4 sheets
@nb_sheets = 5

## Paper orientation, either "portrait" or "landscape"
@sheet_orientation = "landscape"

## First and last date in the timeline
@timeline_date_start = 0
@timeline_date_end = 2010
## Date interval for the timeline (in years)
@timeline_date_interval = 100
## Interval between each timeline date "tick" (in years)
@timeline_date_ticks_interval = 10
## Interval between each dotted vertical lines (in years)
@timeline_date_vlines_interval = 20

## Display the "calendar" area
@display_calendar = true
## Display the "time of day" area
@display_time = true

## Base output filename
@output_filename = "mytimeline"



### SYSTEM COMMANDS

## Pdflatex command
@pdflatex = "pdflatex"
## Pdf viewer command. Set to "" to only generate the file without viewing it.
@pdf_viewer = ""



### GLOBAL LAYOUT OPTIONS

## Left margin in cm
@l_margin = 0.5
## Right margin in cm
@r_margin = 2
## Vertical margins in cm
@v_margin = 0.5
## Cut margins in cm
@cut_margins = 0.5
## Overlapping between pages in cm
@overlapping = 0.2



### TIMELINE LAYOUT OPTIONS

## Area height (in cm) and font size for timeline dates
@timeline_date_height = 1.1
@timeline_date_size = '\huge'
## Number of dashed horizontal lines to draw
@timeline_date_lines = 5



### CALENDAR LAYOUT OPTIONS

## Area height (in cm) for months names
@month_height = 0.7
## font size for month names
@month_size = '\large'
## Area height (in cm) and font size for day numbers.
@day_height = 0.5
@day_size = '\scriptsize'



### TIME OF DAY LAYOUT OPTIONS

## Area height (in cm) for hours and minutes - 0 to disable
@time_height = 0.7
## font sizes for hours and minutes
@hour_size = '\normalsize'
@minute_size = '\footnotesize'
## Minutes numbers to display
@minutes = [10,20,30,40,50]
## Interval between each minutes "tick"
@minutes_ticks_interval = 1



### LATEX OPTIONS

## Extra LaTeX packages
@extra_latex_packages = <<'EOT'
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[autolanguage,np]{numprint}
EOT

## Should we keep the generated TeX files or delete them ?
@keep_tex_files = false


