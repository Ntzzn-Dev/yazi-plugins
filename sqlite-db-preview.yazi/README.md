<img width="1361" height="727" alt="screenshot_2026-01-15_12-25-12" src="https://github.com/user-attachments/assets/28e97b03-8cc2-4d17-bace-fe74c3b67f38" />

Displays the database table and, if there is a foreign key, indicates which table and column it refers to.

# Install

```sh
ya pkg add Ntzzn-Dev/yazi-plugins:sqlite-db-preview
```

# Dependencies

- sqlite3

# Use

no arquivo `~/.config/yazi/yazi.toml`

```toml
plugin.prepend_previewers = [
  { url = '*.sqlite3', run = 'sqlite-db-preview' },
  { mime = 'application/sqlite3', run = 'sqlite-db-preview' },
]
```
