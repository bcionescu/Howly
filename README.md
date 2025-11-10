# Howly

A lightweight Markdown to HTML converter written in Ruby. Howly is currently a work in progress, although it does work, and it's mostly designed to help me convert my own [blog posts](https://bcionescu.com).

## To-Do:

- [x] Replace bold text: `**bold**` or `__bold__`.
- [x] Replace italic text: `*italic*` or `_italic_`.
- [x] Replace hyperlinks.
- [x] Replace both bold and italic at the same time: `***boldanditalic***` `___boldanditalic___`.
- [x] Embed YouTube links if found by themselves on a line.
- [x] Ensure that the link turns into an embed only when it is not preceded or followed by anything else.
- [x] Handle both youtube.com and youtu.be type links when embedding.
- [x] Replace headings from H1 to H6.
- [x] Allow for image embedding.
- [x] Automatically add paragraphs.
- [x] Save the output to the same directory as the original .md file.
- [ ] Incorporate Howly within [Blogby](https://www.github.com/bcionescu/blogby)

## Usage

Howly is a terminal utility. The only requirement is having Ruby installed. In order to use it, clone this repo, and then run `ruby howly.rb <path>` where `<path>` is the path to your `.md` file. Once Howly has finished parsing your file, the `.html` output will be saved to the same directory as the `.md` file.

If you get an error, ensure that the path to your `.md` file contains no spaces, or wrap the path in `""` (double quotes). Here is an example:

```bash
ruby howly.rb "/Users/admin/Documents/blog post.md"
```
## Documentation

For the nerds out there who are curious how this program works, let's go through each function one by one, discuss what it does, and how it does it.

### Getting the path

```ruby
def get_path

  file_path = ARGV[0]

  if file_path.nil?
    puts "Usage: ruby howly.rb <path>"
    exit
  end

  return file_path
end
```

When the user runs something like `ruby howly.rb file.md`, we first take the path, which was given as an argument, and we assign it to the variable `file_path`.

Before we do anything else, we must first make sure that a path was actually given. If it was not, then `file_path` will be `nil`, and so we inform the user what the usage is, and then we `exit`.

If running the `if` statement did not result in the program terminating, then we return the `file_path`.

### Reading the file

```ruby
def parse_contents(file_path)
  file_contents = File.read(file_path)

  return file_contents
end
```

Once we have the file path, we open the file, read its contents, and then place the text in a variable called `file_contents`.

### Parsing headings

```ruby
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
```

I'm sure there is likely a more efficient way to do this, but for the first version, I've opted for this method, simply because it works.

Using regex, we check to see if a line starts with anywhere between one `#`, to `######`. If it does, we remove the hashtags, get the heading, and then wrap the heading in the appropriate tags.

### Parsing bold and italic

```ruby
def parse_bold_and_italic(file_contents)

  file_contents = file_contents.gsub(/\*\*\*(.+?)\*\*\*/) do
    "<b><i>#{$1}</i></b>"
  end

  file_contents = file_contents.gsub(/\_\_\_(.+?)\_\_\_/) do
    "<b><i>#{$1}</i></b>"
  end

  return file_contents
end
```

Next up, we check to see if we have any instances of `***something***` or `___something___` which makes text ***both bold and italic***.

If such an instance is found, the `something` is extracted, and wrapped in tags, so it looks like `<b><i>something</i></b>.`

### Parsing bold

```ruby
def parse_bold(file_contents)
  file_contents = file_contents.gsub(/\*\*(.+?)\*\*/) do
    "<b>#{$1}</b>"
  end

  file_contents = file_contents.gsub(/\_\_(.+?)\_\_/) do
    "<b>#{$1}</b>"
  end

  return file_contents
end
```

This time, we're looking exclusively for either `**something**`, or `__something__`, which makes text **bold**. If found, the `something` is extracted, and replaced with `<b>something</b>`.

### Parsing italic

```ruby
def parse_italic(file_contents)
  file_contents = file_contents.gsub(/\*(.+?)\*/) do
    "<i>#{$1}</i>"
  end

  file_contents = file_contents.gsub(/\_(.+?)\_/) do
    "<i>#{$1}</i>"
  end

  return file_contents
end
```

Much in the same way as the above, the program looks for `*something*` or `_something_`, which makes text *italic*. If found, the `something` is extracted, and substituted with `<i>something</i>`.

### Parsing images

```ruby
def parse_images(file_contents)
  file_contents = file_contents.gsub(/^\[(.+?)\]\(([^)]+)\)$/) do
    image_name = $1
    image_path = $2
    %Q(<img src="#{image_path}" alt="#{image_name}">\n\n)
  end

  return file_contents
end
```

The user might choose to include images in their Markdown file, with a path. This function looks for `[image name](image_path)` in the text, using `^` and `$` to ensure that it is the only thing on that line.

If found, it is changed into `<img src="image_path" alt="image name">`.

### Parsing hyperlinks

```ruby
def parse_hyperlinks(file_contents)
  file_contents = file_contents.gsub(/\[(.+?)\]\(([^)]+)\)/) do
    text = $1
    url = $2
    %Q(<a href="#{url}" class="body-link" target="_blank" rel="noopener noreferrer">#{text}</a>)
  end

  return file_contents
end
```

Something similar is done in the case of hyperlinks. In Markdown, the syntax for a hyperlink is `[text](URL)`. If this pattern is found in the text, the `text` and `URL` are extracted, and the appropriate HTML is generated.

The `body-link` class makes reference to how I structure hyperlinks on my [personal blog](https://bcionescu.com) and can be removed if needed.

### Parsing YouTube embeds

```ruby
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
```

If the user wishes to embed a YouTube video, they may paste it by itself on a line. The regex pattern searches for both `youtube.com` and `youtu.be` type links, as each has their own structure.

If any text is present before or after the URL, it will be left as it is, and it will not be embedded.

When found, they are converted into the appropriate HTML, embedding the video. Please note that in order for you to see the correct embedding, you must be running a local server. Simply opening the `.html` file in a browser will cause an error, and the embed will not display properly.

The `video-container` part also makes reference to how embeds are structured on my own blog, and can be removed.

### Parsing newlines

```ruby
def parse_newlines(file_contents)

  formatted_contents = ""

  file_contents.each_line do |line|
    if line != "\n"
      line.chomp!
    end

    if line[0] != "<" && line != "\n"
      line = %Q(<p>#{line}</p>\n)
    end
    
    formatted_contents += line
  end

  return formatted_contents
end
```

Once everything else is done, it's type to wrap the appropriate paragraphs in `<p></p>` tags.

We go line by line, and we check if it does not start with a `<`, and if the line is not empty. If any of those above conditions are true, it means that we can wrap the line in the paragraph tags.

### Writing to a file

```ruby
def write_file(file_path, file_contents)

  html_path = file_path.sub(/.md$/, ".html")

  File.open(html_path,"w") do |file|
    file.puts file_contents
  end

  puts "The output has been saved to #{html_path}."
end
```

Once we're done, we replace the `.md` extension in the original `file_path` with `.html`, and we save the processed contents to that file. As a result, the newly created `.html` will always be next to the original `.md` file.
