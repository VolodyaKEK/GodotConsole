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

var cmdname_help = "Text printed when using help command (help cmdname)";
func cmdname_cmd(args):#args is an Array of string arguments provided with command
  Console.print("Command output");
```
