extends WindowDialog

var command_postfix = "cmd";
var input_action = "console";
var history_up = "ui_up";
var history_down = "ui_down";
var label = RichTextLabel.new();
var line = LineEdit.new();

var current = 0;
var history = [];
var commands = {};
var cmd_args_amount = {};

func _ready():
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
	
	label.bbcode_enabled = true;
	label.size_flags_vertical = SIZE_EXPAND_FILL;
	label.scroll_following = true;
	label.selection_enabled = true;
	c.add_child(label);
	
	line.connect("text_entered", self, "command");
	line.clear_button_enabled = true;
	c.add_child(line);

func _process(_delta):
	if Input.is_action_just_pressed(input_action):
		if visible:
			hide();
		else:
			popup();
			line.clear();
			line.grab_focus();
	if history.size() > 0 && get_focus_owner() == line:
		var add = 0;
		if Input.is_action_just_pressed(history_up):
			add += 1;
		if Input.is_action_just_pressed(history_down):
			add -= 1;
		if add != 0:
			current = clamp(current-add, 0, history.size()-1);
			line.text = history[current];
			line.caret_position = line.text.length();

func connect_node(node):
	for method in node.get_method_list():
		var n = method.name;
		if n.ends_with("_" + command_postfix):
			n = n.trim_suffix("_" + command_postfix);
			commands[n] = node;
			cmd_args_amount[n] = method.args.size();
func disconnect_node(node):
	for key in commands.keys():
		if commands[key] == node:
			commands.erase(key);
			cmd_args_amount.erase(key);

func command(cmd):
	if cmd == "":
		return;
	line.clear();
	self.print(str("> ", cmd));
	var args = Array(cmd.split(" "));
	var command = args.pop_front();
	var node = commands.get(command);
	if node:
		args.resize(cmd_args_amount[command]);
		node.callv(command + "_" + command_postfix, args);
	else:
		cmd_not_found(command);
	history.append(cmd);
	current = history.size();

func print(s):
	label.append_bbcode(str(s, "\n"));

func cmd_not_found(command):
	self.print(str("Command '", command, "' not found"));

const help_desc = "Use 'help [command]' to get command description";
const help_help = "Prints all available commands";
func help_cmd(command):
	if command != null && !commands.has(command):
		cmd_not_found(command);
		return;
	var keys = commands.keys();
	keys.sort();
	for cmd in [command] if command != null else keys:
		var h = commands[cmd].get(cmd + "_help");
		self.print(str("\t", cmd, "\t", h if h else ""));
	if command == null:
		self.print(help_desc);
	elif commands.has(command):
		var desc = commands[command].get(command + "_desc");
		if desc != null:
			self.print(desc);

const history_help = "Prints all previously entered commands";
func history_cmd():
	self.print("History is empty" if history.size() == 0 else PoolStringArray(history).join("\n"));

const clear_help = "Clears console output";
func clear_cmd():
	label.clear();
