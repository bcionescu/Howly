file_path = ARGV[0]

# output_path = "/Users/admin/Desktop/output.txt"

if file_path.nil?
  puts "Usage: ruby howly.rb <path>"
  exit
end

begin
  file_contents = File.read(file_path)

  formatted_file = file_contents

  formatted_file = file_contents.gsub(/\*\*(.+?)\*\*/) do
    "<b>#{$1}</b>"
  end

  formatted_file = formatted_file.gsub(/\*(.+?)\*/) do
    "<i>#{$1}</i>"
  end

  puts formatted_file

rescue Errno::ENOENT
  puts "File not found: #{file_path}"
rescue => e
  puts "An error ocured: #{e.message}"
end
  
