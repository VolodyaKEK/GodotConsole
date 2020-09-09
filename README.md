# GodotConsole
Single File Godot Runtime Console

# How to use
- Add script Console.gd in your project
- Add Console.gd as autoload
- Add Console.connect_node(self) in _ready on nodes which have acceptable commands

# Acceptable command
Acceptable command is any function if there is variable named as that function with "_help" at the end

# Usage example
```gdscript
func _ready():
  Console.connect_node(self);

var cmd_name_help = "Text printed when using help command (help cmd_name)";
func cmd_name(args):#args is Array of string arguments provided after command name
  pass
```
