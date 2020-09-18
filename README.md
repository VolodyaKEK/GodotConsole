# GodotConsole
![Alt text](/screenshot.png?raw=true "GodotConsole")

# Features
- Everything contained in single file `Console.gd`
- Easy integration in existing project
- Easy command creation
- History navigation (`ui_up` and `ui_down` by default)

# How to use
- Add script `Console.gd` in your project
- Add `Console.gd` as autoload
- Add `Console.connect_node(self)` in `_ready` on nodes which have acceptable commands (or just connect them with `Console.connect_node(node)` from anywhere)
- To popup console you need to setup input action `console` (can be changed setting `Console.input_action` property)

# Acceptable command example
Acceptable command is any function with "_cmd" at the end. Postfix can be changed setting `Console.command_postfix` property to any string.

```gdscript
func _ready():
  Console.connect_node(self);

var cmdname_desc = "Text printed when using help for this command (help cmdname)"; #Optional
var cmdname_help = "Text printed when using 'help' command"; #Optional
func cmdname_cmd(arg0, arg1):
  #arg0 and arg1 is an arguments provided after command,
  #there can be any number of arguments
  Console.print("Command output");
```
