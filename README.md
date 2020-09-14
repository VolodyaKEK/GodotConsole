# GodotConsole
![Alt text](/screenshot.png?raw=true "GodotConsole")

# Features
- Easy integration in existing project
- Easy command creation
- 

# How to use
- Add script `Console.gd` in your project
- Add `Console.gd` as autoload
- Add `Console.connect_node(self)` in `_ready` on nodes which have acceptable commands (or just connect them with `Console.connect_node(node)` from anywhere)

# Acceptable command example
Acceptable command is any function with "_cmd" at the end

```gdscript
func _ready():
  Console.connect_node(self);

const cmdname_desc = "Text printed when using help for this command (help cmdname)"; #Optional
const cmdname_help = "Text printed when using 'help' command"; #Optional
func cmdname_cmd(arg0, arg1):
  #arg0 and arg1 is a string arguments provided after command,
  #there can be any number of arguments
  Console.print("Command output");
```
