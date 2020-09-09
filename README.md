# GodotConsole
Single File Godot Runtime Console

# How to use
- Add script Console.gd in your project
- Add Console.gd as autoload
- Add Console.connect_node(self) in _ready on nodes which have acceptable commands for console

# Acceptable command
Acceptable command can be any function if there is variable named as that function with "_help" at end

Example:
var cmd_name_help = "Help text";
func cmd_name(args):#args is Array of string arguments provided after command name
  pass
