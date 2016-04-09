# Emacs Theme Generator

A Haskell program that generates Emacs 24 colour themes

![](https://raw.githubusercontent.com/owainlewis/emacs-theme-generator/master/resources/preview.png)

## Use

To compile all themes

```
stack build && stack exec emacs-theme-generator-exe
```

Themes are written as simple JSON and compiled into valid emacs themes.

```json
{
    "name": "dorsey",
    "palette": {
        "fg": "#FFFFFF",
        "bg": "#222",
        "builtin": "#C7AF3F",
        "keyword": "#9FB3C2",
        "constant": "#999999",
        "comment": "#4F5A63",
        "function": "#C7AF3F",
        "string": "#FAFFDB",
        "types": "#FFE792",
        "variable": "#8AB8A2",
        "warning": "#8AB8A2"
    }
}
```
