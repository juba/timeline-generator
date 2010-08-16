#!/bin/ruby
# -*- coding: utf-8 -*-



### CONFIGURATION STARTS HERE

## Main title
TITLE = "Histoire récente"

## Number of a4 sheets
NB_SHEETS = 3
## Paper orientation, either "portrait" or "landscape"
SHEET_ORIENTATION = "landscape"
## Horizontal margins in cm
H_MARGIN = 2
## Vertical margins in cm
V_MARGIN = 0.5

## First and last date in the timeline
TIMELINE_DATE_START = 0
TIMELINE_DATE_END = 2010
## Date interval for the timeline
TIMELINE_DATE_INTERVAL = 100
## Interval between each timeline date "tick"
TIMELINE_DATE_TICKS_INTERVAL = 10
## Interval between each dotted vertical lines
TIMELINE_DATE_VLINES_INTERVAL = 20
## Number of dashed horizontal lines to draw
TIMELINE_DATE_LINES = 5

## Area height (in cm) and font size for timeline dates
TIMELINE_DATE_HEIGHT = 1.1
TIMELINE_DATE_SIZE = '\huge'
## Area height (in cm) and font size for month names
MONTH_HEIGHT = 0.7
MONTH_SIZE = '\large'
## Area height (in cm) and font size for day numbers
DAY_HEIGHT = 0.5
DAY_SIZE = '\footnotesize'
## Area height (in cm) and font sizes for hours and minutes
TIME_HEIGHT = 0.7
HOUR_SIZE = '\normalsize'
MINUTE_SIZE = '\footnotesize'
## Minutes numbers to display
MINUTES = [10,20,30,40,50]
## Interval between each minutes "tick"
MINUTES_TICKS_INTERVAL = 1

## Pdflatex command
PDFLATEX = "pdflatex"
## Pdf viexer command
PDF_VIEWER = "evince"
## Pdfposter command
POSTER = "poster"

## Months names
MONTHS = %w{Janvier Février Mars Avril Mai Juin Juillet Août Septembre Octobre Novembre Décembre}
DAYS_PER_MONTH = [31,28,31,30,31,30,31,31,30,31,30,31]

### CONFIGURATION ENDS HERE




sum = 0
cumdays = DAYS_PER_MONTH.map{ |x| sum += x }

sheet_width =  SHEET_ORIENTATION == "portrait" ? 21 : 29.7
sheet_height =  SHEET_ORIENTATION == "portrait" ? 29.7 : 21

TOTAL_WIDTH = NB_SHEETS * sheet_width
TOTAL_HEIGHT = sheet_height
WIDTH = TOTAL_WIDTH - H_MARGIN * 2
HEIGHT = TOTAL_HEIGHT - V_MARGIN * 2 - 1

f = File.new("chrono.tex", "w")

def entete
  return <<'EOT'
\documentclass{article}
\usepackage{tikz}
\usepackage{geometry}
\usepackage[francais]{babel}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[autolanguage,np]{numprint}

\usetikzlibrary{calendar}

\pagestyle{empty}
\thispagestyle{empty}
EOT
end

def geometry
  "\\geometry{paperwidth=#{TOTAL_WIDTH}cm, paperheight=#{TOTAL_HEIGHT}cm, top=#{V_MARGIN}cm, bottom=#{V_MARGIN}cm, left=#{H_MARGIN}cm, right=#{H_MARGIN}cm}"
end


def titre
  '\begin{center}\Huge\textbf{' + TITLE + '}\end{center}'
end 

def pied
  return <<'EOF'
\end{document}
EOF
end

## x coordinate for a day (integer between 1 and 365)
def coord_day(i)
  i.to_f / 365 * WIDTH
end

## x coordinate for a time (float between 0 and 24)
def coord_time(i)
  i.to_f / 24 * WIDTH
end

## x coordinate for a timeline date (float between start and end)
def coord_date(i)
  (TIMELINE_DATE_START - i).abs.to_f / (TIMELINE_DATE_START.to_i - TIMELINE_DATE_END).abs.to_f * WIDTH
end


f.puts entete
f.puts geometry
f.puts '\begin{document}'
f.puts '\sffamily'


f.puts titre


### TIMELINE DATES

f.puts <<'EOF' 
\begin{tikzpicture}[scale=1]
EOF

## Compute dates to display
tmp = TIMELINE_DATE_START..TIMELINE_DATE_END
dates = []
tmp.step(TIMELINE_DATE_INTERVAL) { |i| dates << i}
n = dates.length
#if ((dates[n] - dates[n-1]).abs.to_f / (TIMELINE_DATE_START - TIMELINE_DATE_END).abs.to_f < 0.1 ) then
#  dates.delete_at(n-1)
#end

## Lines
top = HEIGHT - TIMELINE_DATE_HEIGHT
bottom = MONTH_HEIGHT + DAY_HEIGHT + TIME_HEIGHT
f.puts "\\draw(0cm, #{top}cm) -- (#{WIDTH}cm, #{top}cm) ;"
ecart = (top.to_f - bottom.to_f) / TIMELINE_DATE_LINES.to_f
nb = 1..(TIMELINE_DATE_LINES - 1)
nb.each do |i|
  h = top - i * ecart
  f.puts "\\draw [dashed] (0cm, #{h}cm) -- (#{WIDTH}cm, #{h}cm) ;"
end
if (dates[n] != TIMELINE_DATE_END) then
  l = coord_date(TIMELINE_DATE_END)
  f.puts "\\draw(#{l}cm, #{top}cm) -- (#{l}cm, #{bottom}cm) ;"
end

## Ticks
date = TIMELINE_DATE_START + TIMELINE_DATE_TICKS_INTERVAL
while (date < TIMELINE_DATE_END) do
  if !dates.include?(date) then
    l = coord_date(date)
    ltop = top + TIMELINE_DATE_HEIGHT * 0.1
    f.puts "\\draw(#{l}cm, #{ltop}cm) -- (#{l}cm, #{top}cm);"
  end
  date += TIMELINE_DATE_TICKS_INTERVAL
end

## Vertical lines
date = TIMELINE_DATE_START + TIMELINE_DATE_VLINES_INTERVAL
while (date < TIMELINE_DATE_END) do
  if !dates.include?(date) then
    l = coord_date(date)
    f.puts "\\draw [dotted] (#{l}cm, #{top}cm) -- (#{l}cm, #{bottom}cm);"
  end
  date += TIMELINE_DATE_VLINES_INTERVAL
end

## Display dates
f.puts TIMELINE_DATE_SIZE
dates.each_with_index do |d,i|
  l = coord_date(d)
  h_text = HEIGHT - TIMELINE_DATE_HEIGHT.to_f / 2
  ltop = top + TIMELINE_DATE_HEIGHT * 0.15
#  f.puts "\\draw(#{l}cm, #{h_line}cm) -- (#{l}cm, #{h_tick}cm);"
  f.puts "\\draw(#{l}cm, #{h_text}cm) node{\\textbf{\\np{#{d.to_s}}}};"
  f.puts "\\draw(#{l}cm, #{ltop}cm) -- (#{l}cm, #{bottom}cm) ;"
end


### TIME AND MONTHS

## LINES
f.puts "\\draw (0,0) -- (#{WIDTH}cm,0);"
## Months
h = MONTH_HEIGHT
f.puts "\\draw (0,#{h}cm) -- (#{WIDTH}cm,#{h}cm);"
## Days
h = MONTH_HEIGHT + DAY_HEIGHT
f.puts "\\draw (0,#{h}cm) -- (#{WIDTH}cm,#{h}cm);"
(0..365).each do |n| 
  h = coord_day(n)
  f.puts "\\draw (#{h}cm,#{MONTH_HEIGHT}cm) -- (#{h}cm,#{MONTH_HEIGHT + DAY_HEIGHT}cm);"
end
## Hours
h = MONTH_HEIGHT + DAY_HEIGHT + TIME_HEIGHT
f.puts "\\draw (0,#{h}cm) -- (#{WIDTH}cm,#{h}cm);"


## Months names
f.puts MONTH_SIZE
f.puts "\\draw (0, 0) -- (0, #{MONTH_HEIGHT}cm);"
MONTHS.each_with_index do |n, i|
  left =  i == 0 ? 0 : coord_day(cumdays[i-1])
  right = coord_day(cumdays[i])
  mid = (left.to_f + right.to_f) / 2
  f.puts "\\draw (#{right}cm, 0) -- (#{right}cm, #{MONTH_HEIGHT}cm);"
  h = MONTH_HEIGHT.to_f / 2
  f.puts "\\draw (#{mid}cm, #{h}cm) node{#{n}};"
end


## Days names
f.puts DAY_SIZE
MONTHS.each_with_index do |n, i|
  days = DAYS_PER_MONTH[i]
  cum = i == 0 ? 0 : cumdays[i-1]
  (1..days).each do |d|
    l = coord_day(cum.to_f + d.to_f - 0.5)
    h = MONTH_HEIGHT.to_f + DAY_HEIGHT.to_f / 2
    f.puts "\\draw(#{l}cm, #{h}cm) node{#{d.to_s}};"
  end
end

## Hours and minutes
(0..24).each do |t|
  l = coord_time(t)
  h_line = MONTH_HEIGHT.to_f + DAY_HEIGHT.to_f + TIME_HEIGHT.to_f
  h_text = MONTH_HEIGHT.to_f + DAY_HEIGHT.to_f + TIME_HEIGHT.to_f / 2 * 0.8
  h_tick = h_line.to_f * 0.9;
  f.puts HOUR_SIZE
  f.puts "\\draw(#{l}cm, #{h_line}cm) -- (#{l}cm, #{h_tick}cm);"
  f.puts "\\draw(#{l}cm, #{h_text}cm) node{\\textbf{#{t.to_s}h}};"
  next if t == 24
  ## Minutes names
  f.puts MINUTE_SIZE
  MINUTES.each_with_index do |m|
    l = coord_time(t.to_f + (m.to_f / 60))
    h_line = MONTH_HEIGHT.to_f + DAY_HEIGHT.to_f + TIME_HEIGHT.to_f
    h_text = MONTH_HEIGHT.to_f + DAY_HEIGHT.to_f + TIME_HEIGHT.to_f / 2 * 0.9
    h_tick = h_line.to_f * 0.95;
    f.puts "\\draw(#{l}cm, #{h_line}cm) -- (#{l}cm, #{h_tick}cm);"
#    f.puts "\\draw(#{l}cm, #{h_text}cm) node{#{t.to_s}h#{m.to_s}};"
    f.puts "\\draw(#{l}cm, #{h_text}cm) node{#{m.to_s}};"
  end
  ## Minutes ticks
  minutes = MINUTES_TICKS_INTERVAL
  while (minutes < 60) do
    if !(MINUTES.include?(minutes)) then
      l = coord_time(t.to_f + (minutes.to_f / 60))
      h_line = MONTH_HEIGHT.to_f + DAY_HEIGHT.to_f + TIME_HEIGHT.to_f
      h_tick = h_line.to_f * 0.975;
      f.puts "\\draw(#{l}cm, #{h_line}cm) -- (#{l}cm, #{h_tick}cm);"
    end
    minutes += MINUTES_TICKS_INTERVAL
   end
end


f.puts '\end{tikzpicture}'

f.puts pied
 
f.close

system(PDFLATEX + ' chrono.tex')
#exec(PDF_VIEWER + ' chrono.pdf') unless $? != 0

system("pdf2ps chrono.pdf")
box = SHEET_ORIENTATION == "portrait" ? "#{NB_SHEETS}x1A4" : "1x#{NB_SHEETS}A4"
cut = SHEET_ORIENTATION == "portrait" ? "10x0.1mm" : "0.1x10mm"
system(POSTER + " -m200x287mm -p#{box} -c#{cut} chrono.ps > chrono_pages.ps")
system("ps2pdf chrono_pages.ps")

exec(PDF_VIEWER + ' chrono_pages.pdf') unless $? != 0
