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

### Dependencies

- libresprite-thumbnailer | aseprite-thumbnailer | libresprite

- xdg-desktop-portal-termfilechooser

- sqlite3

### Instalation
``` sh
ya pkg add Ntzzn-Dev/yazi-plugins:ase-preview 

ya pkg add Ntzzn-Dev/yazi-plugins:file-downloader-helper

ya pkg add Ntzzn-Dev/yazi-plugins:sqlite-db-preview
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

[[mgr.prepend_keymap]]
on = "<Enter>"
run = "plugin file-downloader-helper"
desc = "Download/Upload and save as:"

[[mgr.prepend_keymap]]
on = "<S-Enter>"
run = "plugin file-downloader-helper notenterdir"
desc = "Download/Upload and save as here"
```
