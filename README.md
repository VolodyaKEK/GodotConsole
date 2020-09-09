# GodotConsole
Single File Godot Runtime Console

# How to use
- Add script Console.gd in your project
- Add Console.gd as autoload
- Add Console.connect_node(self) in _ready on nodes which have acceptable commands

# Acceptable command
Acceptable command is any function with "_cmd" at the end

# Command example
```gdscript
func _ready():
  Console.connect_node(self);

const cmdname_desc = "Text printed when using help for this command (help cmdname)"; #Optional
const cmdname_help = "Text printed when using 'help' command"; #Optional
func cmdname_cmd(arg0, arg1): #arg0 and arg1 is a string arguments provided with command, there can be any number of arguments
  Console.print("Command output");
```
