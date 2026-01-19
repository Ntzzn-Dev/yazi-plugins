<img width="1364" height="731" alt="screenshot_2026-01-15_12-29-37" src="https://github.com/user-attachments/assets/af8a1590-697c-4bda-abe8-cd19f3f5fb9a" />

Show a preview of .ase file.

# Install

```sh
ya pkg add Ntzzn-Dev/yazi-plugins:ase-preview
```

# Dependencies
Only one of the two commands needs to be working. The plugin automatically detects if either one exists.

- aseprite-thumbnailer  
or  
- libresprite-thumbnailer  
or  
- libresprite  

# Use

in `~/.config/yazi/yazi.toml` file

```toml
[plugin]
prepend_preloaders = [
	{ url = "*.ase", run = "ase-preview" },
]
prepend_previewers = [
	{ url = "*.ase", run = "ase-preview" },
]
```
