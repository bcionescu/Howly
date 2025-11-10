def read_file

  file_path = ARGV[0]

  if file_path.nil?
    puts "Usage: ruby howly.rb <path>"
    exit
  end

  return file_path
end

def parse_contents(file_path)
  file_contents = File.read(file_path)

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

def parse_hyperlinks(file_contents)
    file_contents = file_contents.gsub(/\[(.+?)\]\(([^)]+)\)/) do
    text = $1
    url = $2
    %Q(<a href="#{url}" class="body-link" target="_blank" rel="noopener noreferrer">#{text}</a>)
  end

  return file_contents
end

begin
  file_path = read_file

  file_contents = parse_contents(file_path)

  file_contents = parse_bold_and_italic(file_contents)

  file_contents = parse_bold(file_contents)

  file_contents = parse_italic(file_contents)

  file_contents = parse_hyperlinks(file_contents)

  puts file_contents

rescue Errno::ENOENT
  puts "File not found: #{file_path}"
rescue => e
  puts "An error ocured: #{e.message}"
end
  
