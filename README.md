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

## Usage

Howly is a terminal utility. The only requirement is having Ruby installed. In order to use it, clone this repo, and then run `ruby howly.rb <path>` where `<path>` is the path to your `.md` file. Once Howly has finished parsing your file, the `.html` output will be saved to the same directory as the `.md` file.

If you get an error, ensure that the path to your `.md` file contains no spaces, or wrap the path in `""` (double quotes). Here is an example:

```bash
ruby howly.rb "/Users/admin/Documents/blog post.md"
```
