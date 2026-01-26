# Yazi Plugins Collection

A collection of plugins for Yazi, focused on improving previews, download/upload workflows, and file inspection directly inside the file manager.

## 📦 Plugins Included
### 🎨 ase-preview

Preview .ase files directly inside Yazi.

### ⬇️⬆️ file-downloader-helper

Makes downloading and uploading files easier, allowing you to rename before saving and avoiding manual handling of temporary files created by xdg-desktop-portal-termfilechooser.

Rename files before saving

Multiple file support (selection with space)

Enter-Smart already included

### 🗄️ sqlite-db-preview

Displays SQLite table structures, including foreign keys and their references.

### 📦 targz-maker

Create a .tar.gz with the selected items. The tar.gz file is created in the folder where you press Shift + A, giving you the option to define the filename at that moment, or use the default date and time.

### Dependencies

- libresprite-thumbnailer | aseprite-thumbnailer | libresprite

- xdg-desktop-portal-termfilechooser

- sqlite3

- tar

### Instalation
``` sh
ya pkg add Ntzzn-Dev/yazi-plugins:ase-preview 

ya pkg add Ntzzn-Dev/yazi-plugins:file-downloader-helper

ya pkg add Ntzzn-Dev/yazi-plugins:sqlite-db-preview

ya pkg add Ntzzn-Dev/yazi-plugins:targz-maker
```

### Configs

``` toml
# ~/.config/yazi/yazi.toml
[plugin]
prepend_preloaders = [
  { url = "*.ase", run = "ase-preview" },
]
prepend_previewers = [
  { url = "*.ase", run = "ase-preview" },
  { url = '*.sqlite3', run = 'sqlite-db-preview' },
  { mime = 'application/sqlite3', run = 'sqlite-db-preview' },
]

# ~/.config/yazi/keymap.toml
## The default deletions can be overridden to better suit your workflow.

[[mgr.prepend_keymap]]
on = "<Enter>"
run = "plugin file-downloader-helper"
desc = "Download/Upload and save as:"

[[mgr.prepend_keymap]]
on = "<S-Enter>"
run = "plugin file-downloader-helper notenterdir"
desc = "Download/Upload and save as here"

[[mgr.prepend_keymap]]
on = "A"
run = "plugin targz-maker"
desc = "Make a tar.gz with selected items"
```
