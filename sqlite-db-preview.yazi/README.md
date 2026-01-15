Mostra a tabela do banco de dados e, se houver chave estrangeira, indica a qual tabela e coluna ela se refere.  

Displays the database table and, if there is a foreign key, indicates which table and column it refers to.

# Instalação

```sh
ya pkg add Ntzzn-Dev/yazi-plugins:sqlite-db-preview
```

# Dependencias

- sqlite3

# Uso

no arquivo `~/.config/yazi/yazi.toml`

```toml
plugin.prepend_previewers = [
  { url = '*.sqlite3', run = 'sqlite-db-preview' },
  { mime = 'application/sqlite3', run = 'sqlite-db-preview' },
]
```
