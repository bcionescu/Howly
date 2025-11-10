def read_file

  file_path = ARGV[0]

  if file_path.nil?
    puts "Usage: ruby howly.rb <path>"
    exit
  end

  return file_path
end

def write_file(file_path, file_contents)

  html_path = file_path.sub(/.md$/, ".html")

  File.open(html_path,"w") do |file|
    file.puts file_contents
  end

  puts "The output has been saved to #{html_path}."
end

def parse_contents(file_path)
  file_contents = File.read(file_path)

  return file_contents
end

def parse_newlines(file_contents)

  formatted_contents = ""

  file_contents.each_line do |line|
    if line != "\n"
      line.chomp!
    end

    if line[0] != "#" && line[0] != "<" && line != "\n"
      line = %Q(<p>#{line}</p>\n)
    end
    
    formatted_contents += line
  end

  return formatted_contents
end

def parse_headings(file_contents)

  file_contents = file_contents.gsub(/^###### (.+?)$/) do
    "<h6>#{$1}</h6>"
  end

  file_contents = file_contents.gsub(/^##### (.+?)$/) do
    "<h5>#{$1}</h5>"
  end

  file_contents = file_contents.gsub(/^#### (.+?)$/) do
    "<h4>#{$1}</h4>"
  end

  file_contents = file_contents.gsub(/^### (.+?)$/) do
    "<h3>#{$1}</h3>"
  end

  file_contents = file_contents.gsub(/^## (.+?)$/) do
    "<h2>#{$1}</h2>"
  end

  file_contents = file_contents.gsub(/^# (.+?)$/) do
    "<h1>#{$1}</h1>"
  end

  return file_contents
end


def parse_bold_and_italic(file_contents)

  file_contents = file_contents.gsub(/\*\*\*(.+?)\*\*\*/) do
    "<b><i>#{$1}</i></b>"
  end

  file_contents = file_contents.gsub(/\_\_\_(.+?)\_\_\_/) do
    "<b><i>#{$1}</i></b>"
  end

  return file_contents
end

def parse_bold(file_contents)
  file_contents = file_contents.gsub(/\*\*(.+?)\*\*/) do
    "<b>#{$1}</b>"
  end

  file_contents = file_contents.gsub(/\_\_(.+?)\_\_/) do
    "<b>#{$1}</b>"
  end

  return file_contents
end

def parse_italic(file_contents)
  file_contents = file_contents.gsub(/\*(.+?)\*/) do
    "<i>#{$1}</i>"
  end

  file_contents = file_contents.gsub(/\_(.+?)\_/) do
    "<i>#{$1}</i>"
  end

  return file_contents
end

def parse_images(file_contents)
  file_contents = file_contents.gsub(/^\[(.+?)\]\(([^)]+)\)$/) do
    image_name = $1
    image_path = $2
    %Q(<img src="#{image_path}" alt="#{image_name}">\n\n)
  end

  return file_contents
end

def parse_hyperlinks(file_contents)
  file_contents = file_contents.gsub(/\[(.+?)\]\(([^)]+)\)/) do
    text = $1
    url = $2
    %Q(<a href="#{url}" class="body-link" target="_blank" rel="noopener noreferrer">#{text}</a>)
  end

  return file_contents
end

def parse_embeds(file_contents)
  file_contents = file_contents.gsub(/^https:\/\/(www\.)?youtube\.com\/watch\?v=([A-Za-z0-9_-]+)\s*$/) do
    video_id = $2

    %Q(<div class="video-container"><iframe src="https://www.youtube.com/embed/#{video_id}" frameborder="0" allowfullscreen></iframe></div>\n\n)
  end

  file_contents = file_contents.gsub(/^https:\/\/(www\.)?youtu\.be\/([A-Za-z0-9_-]+)\s*$/) do
    video_id = $2

    %Q(<div class="video-container"><iframe src="https://www.youtube.com/embed/#{video_id}" frameborder="0" allowfullscreen></iframe></div>\n\n)
  end


  return file_contents
end

begin
  file_path = read_file

  file_contents = parse_contents(file_path)

  file_contents = parse_headings(file_contents)

  file_contents = parse_bold_and_italic(file_contents)

  file_contents = parse_bold(file_contents)

  file_contents = parse_italic(file_contents)

  file_contents = parse_images(file_contents)

  file_contents = parse_hyperlinks(file_contents)

  file_contents = parse_embeds(file_contents)

  file_contents = parse_newlines(file_contents)

  write_file(file_path, file_contents)

rescue Errno::ENOENT
  puts "File not found: #{file_path}"
rescue => e
  puts "An error ocured: #{e.message}"
end
  
