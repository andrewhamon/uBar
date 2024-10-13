# µBar - write menubar apps in any language

uBar is a CLI program which does the following:

- Reads JSON lines from stdin which represent a menu tree
- Renders that tree as a macOS menubar application
- Writes JSON events to stdout when menu items are clicked

uBar is aimed at developers, rather than end-users, who might be interested in
writing lightweight menubar applications in any language.

## Getting started

uBar is available via `nix` or as a prebuilt binary.

<details>
<summary>Using nix</summary>

```bash
menu='{"title":"uBar", "children": [{"title": "Click me!", "id": "1"}]}'
echo "$menu" | nix run github:andrewhamon/uBar
```

</details>

<details>
<summary>Using a pre-built binary</summary>

A universal binary is built with each GitHub release.

```bash
curl -L "https://github.com/andrewhamon/uBar/releases/latest/download/uBar" -o uBar
chmod +x uBar

# optional: verify the binary provenance with the gh cli
gh attestation verify uBar --repo andrewhamon/uBar

menu='{"title":"uBar", "children": [{"title": "Click me!", "id": "1"}]}'
echo "$menu" | ./uBar
```

</details>


### Demo
There is a small demo script which allows for rapid iteration of a uBar UI. A
swift toolchain and `jq` are required.

<details>
<summary>Live-editable demo</summary>

If you have a swift toolchain and `jq` installed, you can clone the repo and run
`./demo.sh`. Any changes to `demo.json` should be reflected instantly.

```bash
git clone https://github.com/andrewhamon/uBar.git
cd uBar
./demo.sh

# make edits to demo.json
vim demo.json
```

</details>

## Protocol

uBar expects to read a series of JSON-encoded messages, one per line. Each
message represents a root `MenuTree`. To change what uBar renders, just send it
a new JSON-encoded `MenuTree`.

When the user clicks on an item in the `MenuTree`, uBar will write a
`MenuAction` to stdout.

### `MenuTree` schema

A MenuTree node has the following schema. All fields are **optional**. Most
fields directly correspond to a field on [`NSMenuItem`](https://developer.apple.com/documentation/appkit/nsmenuitem) in
AppKit.

Some fields are inapplicable and ignored on the root-level node. That is because
the root node is used to configure the always-visible menubar button (an
instance of an
[`NSStatusBarButton`](https://developer.apple.com/documentation/appkit/nsstatusbarbutton)),
whereas all child nodes are used to configure instances of
[`NSMenuItem`](https://developer.apple.com/documentation/appkit/nsmenuitem).

- `id` - an arbitrary string supplied by you. This ID is included in
  `MenuAction`s written to stdout. Leaf-nodes will be greyed-out and unclickable
  if no `id` is specified.
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
  - `width`, `height` - One or both of the values may be specified, and will be
    used to scale the image. If both are specified, the image will be scaled so
    that it does not exceed either dimension. Aspect ratio is always preserved.
    Negative values will be ignored.
- `children` - A list of child `MenuTree`s.

### `MenuAction` schema

When a menu item is clicked, a `MenuAction` is written to stdout with the
following fields:

- `type` - always a value of `click`. More types may be added in the future.
- `id` - The ID of the `MenuTree` node that was clicked.
