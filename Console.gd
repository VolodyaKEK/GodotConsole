extends WindowDialog

class ConsoleCommand:
	var node;
	var method;
	func _init(node, method):
		self.node = node;
		self.method = method;
	func call(args):
		node.call(method, args);

var input_name = "console";
var label = RichTextLabel.new();
var line = LineEdit.new();

var history = [];
var connected = [];

func _ready():#get_parent().move_child(self, get_parent().get_child_count()-1);
	connect_node(self);
	window_title = "Console";
	popup_exclusive = true;
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

func connect_node(node):
	connected.append(node);
func disconnect_node(node):
	connected.remove(connected.find(node));

func command(cmd):
	line.clear();
	if cmd == "":
		return;
	self.print("> " + cmd);
	var split = Array(cmd.split(" "));
	var method = split.pop_front();
	var command = get_command(method);
	command.call(split) if command else self.print("ERR_COMMAND_NOT_FOUND");
	history.append(cmd);

func get_all_commands():
	var commands = [];
	for node in connected:
		for p in node.get_property_list():
			var n = p.name;
			if n.ends_with("_help"):
				commands.append(ConsoleCommand.new(node, n.substr(0, n.length()-5)));
	return commands;

func get_command(cmd):
	for command in get_all_commands():
		if command.method == cmd:
			return command;
	return null;

func print(s):
	label.append_bbcode(str(s, "\n"));

var help_help = "help (func_name) [arg0, arg1, ..., argn]";
func help(args):
	var helps = {};
	var commands = get_all_commands();
	for command in commands:
		helps[command.method] = command.node.get(command.method + "_help");
	for key in helps.keys() if args.size() == 0 else args:
		var h = helps.get(key);
		self.print(str("\t", key, " > ", "ERR_COMMAND_NOT_FOUND" if h == null else h));

var test_help = "Prints provided arguments";
func test(args):
	self.print(args);

var history_help = "Prints all entered commands";
func history(args):
	self.print(PoolStringArray(history).join("\n"));

var clear_help = "";
func clear(args):
	label.bbcode_text = "";
