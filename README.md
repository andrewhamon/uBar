# µBar - write menubar apps in any language

uBar is a CLI program which does the following:

- Reads JSON lines from stdin which represent a menu tree
- Renders that tree as a macOS menubar application
- Writes JSON events to stdout when menu items are clicked

uBar is aimed at developers, rather than end-users, who might be interested in
writing lightweight menubar applications in any language.

## Getting started

For the time being, uBar is only packaged in nix. I hope to add precompiled
github releases soon.

If you have nix installed, you can run `./playground.sh` which will launch an
example. You can edit [playground.json](./playground.json) and see your updates
applied instantly.

## Protocol

uBar expects to read a series of JSON-encoded messages, one per line. When a new
line is received, it is decoded and rendered. To change what uBar renders, just
send it a new JSON line.

uBar does not support partial updates. Each message must contain a full menu
tree.

### MenuTree schema

A MenuTree node has the following fields. All fields are optional. For the most
part, uBar tracks 1-1 with the [stock NSMenuItem
features](https://developer.apple.com/documentation/appkit/nsmenuitem) available
in AppKit.

- `id` - an arbitrary string supplied by you. This ID is included in
  MenuAction's written to stdout.
- `title` - The title of the menu item, or the title rendered in the menubar if
  if specified on the root.
- `separator` - If true, the node is treated as a separator and all other fields
  are ignored. Ignored if root node.
- `indentionLevel` - Indents the title of the menu item. Ignored if root node.
- `toolTip` - Text displayed on an extended hover.
- `image` - An image which will be rendered to the left of `title`.
  - `systemSymbolName` - If specified, will load a system icon. You can find
    symbols using the [SF Symbols app](https://developer.apple.com/sf-symbols/)
    from Apple.
  - `path` - Path on disk to an image to render.
  - `url` - HTTP URL of a remote image to download an render.
  - `accessibilityDescription` - Accessibility description passed to the NSImage
  - `width` - If specified, the image will be scaled down proportionally to this
    width, maintaining its aspect ratio. Only one of width or height can be specified.
  - `height` - If specified, the image will be scaled down proportionally to
    this height, maintaining its aspect ratio. Only one of width or height can be specified.
- `children` - An array of child nodes with this same schema.

### MenuAction schema

When a menu item is clicked, a MenuAction is written to stdout with the
following fields:

- `type` - always a value of `click`. More types may be added in the future.
- `id` - The ID of the node that was clicked.
