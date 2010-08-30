#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

## configuration and initialization
def init(config_file)
  
  if !config_file.nil?
    begin
      load(config_file)
    rescue Error => e
      warn("An error occurred while reading #{rcfile}: ", e)
      exit
    end
  end

  ## Default configuration values
  @title        ||= "Title"
  @language     ||= "english"
  @nb_sheets    ||= 5
  @sheet_orientation    ||= "landscape"
  @l_margin     ||= 0.5
  @r_margin     ||= 2
  @v_margin     ||= 0.5
  @cut_margins  ||= 0.5
  @overlapping  ||= 0.2
  @timeline_date_start  ||= 0
  @timeline_date_end    ||= 2010
  @timeline_date_interval        ||= 100
  @timeline_date_ticks_interval  ||= 10
  @timeline_date_vlines_interval ||= 20
  @timeline_date_lines  ||= 5
  @timeline_date_height ||= 1.1
  @timeline_date_size   ||= '\huge'
  @month_height  ||= 0.7
  @month_size    ||= '\large'
  @day_height    ||= 0.5
  @day_size      ||= '\scriptsize'

  @time_height   ||= 0.7
  @hour_size     ||= '\normalsize'
  @minute_size   ||= '\footnotesize'
  @minutes       ||= [10,20,30,40,50]
  @minutes_ticks_interval ||= 1
  @pdflatex      ||= "pdflatex"
  @pdf_viewer    ||= ""
  @extra_latex_packages ||= <<'EOT'
     \usepackage[utf8]{inputenc}
     \usepackage[T1]{fontenc}
     \usepackage{lmodern}
     \usepackage[autolanguage,np]{numprint}
EOT
  @output_filename ||= "timeline"
  @display_calendar = true  if @display_calendar.nil?
  @display_time     = true  if @display_time.nil?
  @keep_tex_files   = false if @keep_tex_files.nil?


  ## "Computed" configuration values
  if !@display_calendar
    @month_height = 0
    @day_height = 0
  end
  if !@display_time
    @time_height = 0
  end
  @months_names = case @language
               when "francais"
                 %w{Janvier Février Mars Avril Mai Juin Juillet Août Septembre Octobre Novembre Décembre}
                ## English by default
               else
                 %w{January February March April May June July August September October November December}
               end
  @days_per_month = [31,28,31,30,31,30,31,31,30,31,30,31]

  sheet_width  =  @sheet_orientation == "portrait" ? 21 : 29.7
  sheet_height =  @sheet_orientation == "portrait" ? 29.7 : 21

  @total_width = @nb_sheets * sheet_width - @cut_margins * 2 * @nb_sheets - @overlapping * 2 * (@nb_sheets - 1) 
  @total_height = sheet_height
  @width = @total_width - @l_margin - @r_margin
  @height = @total_height - @v_margin * 2 - 1

end


## x coordinate for a day (integer between 1 and 365)
def coord_day(i)
  i.to_f / 365 * @width
end

## x coordinate for a time (float between 0 and 24)
def coord_time(i)
  i.to_f / 24 * @width
end

## x coordinate for a timeline date (float between start and end)
def coord_date(i)
  (@timeline_date_start - i).abs.to_f / (@timeline_date_start.to_i - @timeline_date_end).abs.to_f * @width
end


def generate_timeline_area

  p = ""

  ## Compute dates to display
  tmp = @timeline_date_start..@timeline_date_end
  dates = []
  tmp.step(@timeline_date_interval) { |i| dates << i}
  n = dates.length

  ## Lines
  top = @height - @timeline_date_height
  bottom = @month_height + @day_height + @time_height
  p << "\\draw(0cm, #{top}cm) -- (#{@width}cm, #{top}cm) ;"
  p << "\\draw (0,0) -- (#{@width}cm,0);"
  ecart = (top.to_f - bottom.to_f) / @timeline_date_lines.to_f
  nb = 1..(@timeline_date_lines - 1)
  nb.each do |i|
    h = top - i * ecart
    p << "\\draw [dashed] (0cm, #{h}cm) -- (#{@width}cm, #{h}cm) ;"
  end
  if (dates[n] != @timeline_date_end) then
    l = coord_date(@timeline_date_end)
    p << "\\draw(#{l}cm, #{top}cm) -- (#{l}cm, #{bottom}cm) ;"
  end

  ## Ticks
  date = @timeline_date_start + @timeline_date_ticks_interval
  while (date < @timeline_date_end) do
    if !dates.include?(date) then
      l = coord_date(date)
      ltop = top + @timeline_date_height * 0.1
      p << "\\draw(#{l}cm, #{ltop}cm) -- (#{l}cm, #{top}cm);"
    end
    date += @timeline_date_ticks_interval
  end

  ## Vertical lines
  date = @timeline_date_start + @timeline_date_vlines_interval
  while (date < @timeline_date_end) do
    if !dates.include?(date) then
      l = coord_date(date)
      p << "\\draw [dotted] (#{l}cm, #{top}cm) -- (#{l}cm, #{bottom}cm);"
    end
    date += @timeline_date_vlines_interval
  end

  ## Display dates
  p << @timeline_date_size
  dates.each_with_index do |d,i|
    l = coord_date(d)
    h_text = @height - @timeline_date_height.to_f / 2
    ltop = top + @timeline_date_height * 0.15
    p << "\\draw(#{l}cm, #{h_text}cm) node{\\textbf{\\np{#{d.to_s}}}};"
    p << "\\draw(#{l}cm, #{ltop}cm) -- (#{l}cm, #{bottom}cm) ;"
  end

  return p

end


def generate_calendar_area

  p = ""

  sum = 0
  cumdays = @days_per_month.map{ |x| sum += x }

  ## Lines
  # Months
  h = @month_height
  p << "\\draw (0,#{h}cm) -- (#{@width}cm,#{h}cm);"
  # Days
  h = @month_height + @day_height
  p << "\\draw (0,#{h}cm) -- (#{@width}cm,#{h}cm);"
  (0..365).each do |n| 
    h = coord_day(n)
    p << "\\draw (#{h}cm,#{@month_height}cm) -- (#{h}cm,#{@month_height + @day_height}cm);"
  end


  ## Months names
  p << @month_size
  p << "\\draw (0, 0) -- (0, #{@month_height}cm);"
  @months_names.each_with_index do |n, i|
    left =  i == 0 ? 0 : coord_day(cumdays[i-1])
    right = coord_day(cumdays[i])
    mid = (left.to_f + right.to_f) / 2
    p << "\\draw (#{right}cm, 0) -- (#{right}cm, #{@month_height}cm);"
    h = @month_height.to_f / 2
    p << "\\draw (#{mid}cm, #{h}cm) node{#{n}};"
  end


  ## Days names
  p << @day_size
  @months_names.each_with_index do |n, i|
    days = @days_per_month[i]
    cum = i == 0 ? 0 : cumdays[i-1]
    (1..days).each do |d|
      l = coord_day(cum.to_f + d.to_f - 0.5)
      h = @month_height.to_f + @day_height.to_f / 2
      p << "\\draw(#{l}cm, #{h}cm) node{#{d.to_s}};"
    end
  end

  return p

end

def generate_time_area

  p = ""
  
  ## Lines
  h = @month_height + @day_height + @time_height
  p << "\\draw (0,#{h}cm) -- (#{@width}cm,#{h}cm);"

  ## Hours and minutes
  (0..24).each do |t|
    l = coord_time(t)
    h_line = @month_height.to_f + @day_height.to_f + @time_height.to_f
    h_text = @month_height.to_f + @day_height.to_f + @time_height.to_f / 2 * 0.8
    h_tick = h_line.to_f * 0.9;
    p << @hour_size
    p << "\\draw(#{l}cm, #{h_line}cm) -- (#{l}cm, #{h_tick}cm);"
    p << "\\draw(#{l}cm, #{h_text}cm) node{\\textbf{#{t.to_s}h}};"
    next if t == 24
    ## Minutes names
    p << @minute_size
    @minutes.each_with_index do |m|
      l = coord_time(t.to_f + (m.to_f / 60))
      h_line = @month_height.to_f + @day_height.to_f + @time_height.to_f
      h_text = @month_height.to_f + @day_height.to_f + @time_height.to_f / 2 * 0.9
      h_tick = h_line.to_f * 0.95;
      p << "\\draw(#{l}cm, #{h_line}cm) -- (#{l}cm, #{h_tick}cm);"
      p << "\\draw(#{l}cm, #{h_text}cm) node{#{m.to_s}};"
    end
    ## Minutes ticks
    minutes = @minutes_ticks_interval
    while (minutes < 60) do
      if !(@minutes.include?(minutes)) then
        l = coord_time(t.to_f + (minutes.to_f / 60))
        h_line = @month_height.to_f + @day_height.to_f + @time_height.to_f
        h_tick = h_line.to_f * 0.975;
        p << "\\draw(#{l}cm, #{h_line}cm) -- (#{l}cm, #{h_tick}cm);"
      end
      minutes += @minutes_ticks_interval
    end
  end

  return p

end


## Generate the timeline on one big page
def generate_timeline
  
  ## LaTeX headers
  p = '\documentclass[oneside,a4paper]{article}'
  p << "\\usepackage[#{@language}]{babel}"
  p << '\usepackage{tikz}'
  p << '\usepackage{geometry}'

  p << @extra_latex_packages
  p << "\\geometry{paperwidth=#{@total_width}cm, paperheight=#{@total_height}cm, top=#{@v_margin}cm, bottom=#{@v_margin}cm, left=#{@l_margin}cm, right=#{@r_margin}cm}"
  p << '\begin{document}'
  p << '\pagestyle{empty}'
  p << '\thispagestyle{empty}'
  p << '\sffamily'

  ## Title
  p << "\\begin{center}\\Huge\\textbf{#{@title}}\\end{center}"

  p << '\begin{tikzpicture}[scale=1]'
  p << generate_timeline_area()

  if @display_calendar
    p << generate_calendar_area()
  end

  if @display_time
    p << generate_time_area()
  end

  p << '\end{tikzpicture}'
  p << '\end{document}'

end

## Split the first file between several pages
def generate_splitted_timeline

  if @sheet_orientation == "portrait" then
    orientation = ""
    paperwidth = 21 - 2 * @cut_margins
    paperheight = 29.7
  else
    orientation = "landscape,"
    paperwidth = 29.7 - 2 * @cut_margins
    paperheight = 21
  end

  p =  "\\documentclass[#{orientation}oneside,a4paper]{article}"
  p << '\usepackage{pdfpages}'
  p << '\usepackage{tikz}'
  p << '\usepackage{geometry}'
  p << '\usepackage[center,cross,a4,pdflatex]{crop}'
  p << "\\geometry{paperwidth=#{paperwidth}cm,paperheight=#{paperheight}cm,left=0cm,top=0cm,bottom=0cm,right=0cm,nohead}"

  p << '\newcommand*\topline{'
  p << '\begin{picture}(0,0)'
  p << '  \thinlines\unitlength1cm'
  p << '  \put(0,-2){\line(0,1){4}}'
  p << '\end{picture}}'

  p << '\newcommand*\bottomline{'
  p << '\begin{picture}(0,0)'
  p << '  \thinlines\unitlength1cm'
  p << '  \put(0,-2){\line(0,1){4}}'
  p << '\end{picture}}'
  p << '\cropdef\relax\topline\relax\bottomline{first}'
  p << '\cropdef\topline\relax\bottomline\relax{last}'
  p << '\cropdef\topline\topline\bottomline\bottomline{lines}'

  p << '\begin{document}'
  p << '\pagestyle{empty}'
  p << '\thispagestyle{empty}'
  p << '\crop[first]'

  xoffset = 0
  (1..@nb_sheets).each do |n|
    p << "\\includepdf[viewport= #{xoffset}cm 0cm #{xoffset + paperwidth}cm #{paperheight}cm, offset=0 0, delta=0 0, noautoscale=true, clip=true]{#{@output_filename}.pdf}"
    p << (n == (@nb_sheets - 1) ? '\crop[last]' : '\crop[lines]')
    xoffset += paperwidth - 2 * @overlapping
  end

  p << '\end{document}'

  return p

end

def clean_files(filename)
  ext = %w{ .aux .log}
  ext << '.tex' if !@keep_tex_files
  ext.each do |ex|
    name = filename + ex
    File.delete name if File.exists? name
  end
end

config_file = ARGV.shift
init(config_file)

## All-in-one page LaTeX file generation and processing

File.open(@output_filename + ".tex", "w") do |f|
  timeline_tex_content = generate_timeline()
  f.puts timeline_tex_content
end

begin
  system(@pdflatex + ' ' + @output_filename + '.tex')
rescue Error => e
  warn("An error occurred while processing the timeline LaTeX file : ", e)
  exit
end

clean_files(@output_filename)

if @nb_sheets < 2 && @pdf_viewer != "" && $? == 0
  exec(@pdf_viewer + ' ' + @output_filename + '.pdf')
end

exit if @nb_sheets < 2

## Split the file between several pages if needed

puts "="*60

File.open(@output_filename + "_pages.tex", "w") do |f|
  splitted_timeline_tex_content = generate_splitted_timeline()
  f.puts splitted_timeline_tex_content
end

begin
  system(@pdflatex + ' ' + @output_filename + '_pages.tex')
rescue Error => e
  warn("An error occurred while processing the splitted timeline LaTeX file : ", e)
  exit
end

clean_files(@output_filename + '_pages')

if @pdf_viewer != "" && $? == 0
  exec(@pdf_viewer + ' ' + @output_filename + '_pages.pdf')
end


