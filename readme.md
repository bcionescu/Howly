# Howly

A lightweight Markdown to HTML converter written in Ruby. Howly is currently a work in progress, although it does work, and it's mostly designed to help me convert my own [blow posts](https://bcionescu.com).

## To-Do:

- [x] Replace bold text: `**bold**` or `__bold__`.
- [x] Replace italic text: `*italic*` or `_italic_`.
- [x] Replace hyperlinks.
- [x] Replace both bold and italic at the same time: `***boldanditalic***` `___boldanditalic___`.
- [x] Embed YouTube links if found by themselves on a line.
- [x] Ensure that the link turns into an embed only when it is not preceded or followed by anything else.
- [x] Handle both youtube.com and youtu.be type links.
- [ ] Automatically add paragraphs.
- [ ] Replace headings.
- [ ] Replace Markdown ordered lists with HTML. Check for usage of 1), 2), etc. as well.
- [ ] Take unordered lists into account as well. The user might use `-`, `*`, `+` or `-` to indicate an element in such a list. Bear in mind that indented items are also a possibility. Additionally, unordered lists can start with numbers.
- [ ] Allow for images
