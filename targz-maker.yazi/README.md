<img width="1366" height="768" alt="screenshot_2026-01-26_12-39-32" src="https://github.com/user-attachments/assets/abe37a07-6807-4770-a5ad-673778f6352f" />

Create a targz with the selected items.
The targz file is created in the folder where you press `shift + A`, giving you the option to create the file with the name you define at that moment, or using the default date and time.

# Install

```sh
ya pkg add Ntzzn-Dev/yazi-plugins:targz-maker
```

# Dependencies

- tar

# Use

in `~/.config/yazi/keymap.toml` file

```toml
[[mgr.prepend_keymap]]
on = "A"
run = "plugin targz-maker"
desc = "Make a tar.gz with selected itens"
```
