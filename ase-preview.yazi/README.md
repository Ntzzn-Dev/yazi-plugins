Mostra um preview do arquivo .ase.

Show a preview of .ase file.

# Instalação

```sh
ya pkg add Ntzzn-Dev/yazi-plugins:ase-preview
```

# Dependencias
É necessário apenas um dos dois comandos funcionando. O plugin detecta automáticamente se um dos dois existe.

Only one of the two commands needs to be working. The plugin automatically detects if either one exists.

- libresprite  
ou
- aseprite-thumbnailer

# Uso

no arquivo `~/.config/yazi/yazi.toml`

```toml
[plugin]
prepend_preloaders = [
	{ url = "*.ase", run = "ase-preview" },
]
prepend_previewers = [
	{ url = "*.ase", run = "ase-preview" },
]
```
