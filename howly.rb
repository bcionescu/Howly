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

begin
  file_path = read_file

  file_contents = parse_contents(file_path)

  file_contents = file_contents.gsub(/\*\*(.+?)\*\*/) do
    "<b>#{$1}</b>"
  end

  file_contents = file_contents.gsub(/\*(.+?)\*/) do
    "<i>#{$1}</i>"
  end

  file_contents = file_contents.gsub(/\[(.+?)\]\(([^)]+)\)/) do
    text = $1
    url = $2
    %Q(<a href="#{url}" class="body-link" target="_blank" rel="noopener noreferrer">#{text}</a>)
  end

  puts file_contents

rescue Errno::ENOENT
  puts "File not found: #{file_path}"
rescue => e
  puts "An error ocured: #{e.message}"
end
  
