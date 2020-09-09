extends WindowDialog

class ConsoleCommand:
	var node;
	var method;
	func _init(node, method):
		self.node = node;
		self.method = method;
	func call(args):
		node.call(method, args);

var command_postfix = "_cmd";
var input_name = "console";
var label = RichTextLabel.new();
var line = LineEdit.new();

var history = [];
var commands = {};

func _ready():#get_parent().move_child(self, get_parent().get_child_count()-1);
	connect_node(self);
	window_title = "Console";
	popup_exclusive = true;
	resizable = true;
	rect_min_size = Vector2(200, 100);
	rect_size = Vector2(500, 300);
	
	var c = VBoxContainer.new();
	add_child(c);
	c.margin_bottom = 0;
	c.margin_left = 0;
	c.margin_top = 0;
	c.margin_right = 0;
	c.anchor_bottom = 1;
	c.anchor_left = 0;
	c.anchor_top = 0;
	c.anchor_right = 1;
	
	label.size_flags_vertical = SIZE_EXPAND_FILL;
	label.scroll_following = true;
	c.add_child(label);
	
	line.connect("text_entered", self, "command");
	line.clear_button_enabled = true;
	c.add_child(line);

func _process(delta):
	if Input.is_action_just_pressed(input_name):
		hide() if visible else popup();
		if visible:
			line.grab_focus();

func connect_node(node):
	for method in node.get_method_list():
		var n = method.name;
		if n.ends_with(command_postfix):
			commands[n.substr(0, n.length()-command_postfix.length())] = node;
func disconnect_node(node):
	for key in commands.keys():
		if commands[key] == node:
			commands.erase(key);

func command(cmd):
	if cmd == "":
		return;
	line.clear();
	self.print("> " + cmd);
	var split = Array(cmd.split(" "));
	var method = split.pop_front();
	var command = commands.get(method);
	command.call(method + command_postfix, split) if command else self.print("[Error] Command not found");
	history.append(cmd);

func print(s):
	label.append_bbcode(str(s, "\n"));

var help_help = "help (func_name) [arg0, arg1, ..., argn]";
func help_cmd(args):
	var helps = {};
	for cmd in commands.keys():
		var node = commands[cmd];
		helps[cmd] = node.get(cmd + "_help");
	for key in helps.keys() if args.size() == 0 else args:
		var h = helps.get(key);
		self.print(str(key, " > ", "[Error] Command not found" if h == null else h));

var test_help = "Prints provided arguments";
func test_cmd(args):
	self.print(args);

var history_help = "Prints all entered commands";
func history_cmd(args):
	self.print(PoolStringArray(history).join("\n"));

var clear_help = "Clears console";
func clear_cmd(args):
	label.clear();
