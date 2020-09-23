extends WindowDialog

class ConsoleBBCodeColor extends RichTextEffect:
	var bbcode = "bbcode";
	var colors;
	func _init(_colors):
		colors = _colors;
	func _process_custom_fx(fx):
		var c = colors.get(fx.env.get("c"));
		if c is Color:
			fx.color = c;
		return true;

export var command_postfix := "cmd";
export var input_action := "console";
export var history_up := "ui_up";
export var history_down := "ui_down";
export var convert_arguments := true;
var label := RichTextLabel.new();
var line := LineEdit.new();

var current := 0;
const history := [];
const commands := {};
const cmd_args_amount := {};

const bbcode_colors = {
	line = Color(0.8, 0.8, 0.8, 1),
	error = Color(1, 0.2, 0.2, 1),
	warning = Color(1, 1, 0.2, 1),
};

func _init():
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
	label.install_effect(ConsoleBBCodeColor.new(bbcode_colors));
	c.add_child(label);
	
# warning-ignore:return_value_discarded
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
			current = int(clamp(current-add, 0, history.size()-1));
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
# warning-ignore:return_value_discarded
			commands.erase(key);
# warning-ignore:return_value_discarded
			cmd_args_amount.erase(key);

func command(cmd):
	if cmd == "":
		return;
	line.clear();
	self.print(str("\n" if label.text.length() != 0 else "", "> ", cmd), "line");
	var args = Array(cmd.split(" "));
	var command = args.pop_front();
	if convert_arguments:
		for i in args.size():
			var arg = args[i].to_lower();
			var new_arg = arg;
			if arg == "false":
				new_arg = false;
			elif arg == "true":
				new_arg = true;
			elif arg.is_valid_float():
				new_arg = float(arg);
			elif arg.is_valid_integer():
				new_arg = int(arg);
			args[i] = new_arg;
	var node = commands.get(command);
	if node:
		args.resize(cmd_args_amount[command]);
		node.callv(command + "_" + command_postfix, args);
	else:
		cmd_not_found(command);
	history.append(cmd);
	current = history.size();

func print(s, bbcode=null):
	write(str("\n" if label.text.length() != 0 else "", s), bbcode);
func write(s, bbcode=null):
# warning-ignore:return_value_discarded
	label.append_bbcode(bbcode_wrap(s, bbcode));
func bbcode_wrap(s, bbcode):
	return str(s) if bbcode == null else str("[bbcode c=", bbcode, "]", s, "[/bbcode]");

func cmd_not_found(command):
	self.print(str("Command '", command, "' not found"), "error");

var help_desc = "Use 'help [command]' to get command description";
var help_help = "Prints all available commands";
func help_cmd(command):
	if command != null && !commands.has(command):
		cmd_not_found(command);
		return;
	var keys = commands.keys();
	keys.sort();
	
	var help_table = "[table=2]";
	for cmd in [command] if command != null else keys:
		var h = commands[cmd].get(cmd + "_help");
		help_table += str("[cell]", cmd, "\t[/cell][cell]", h if h else "", "[/cell]");
	self.print(str(help_table, "[/table]"));
	
	if command == null:
		self.print(help_desc);
	else:
		var desc = commands[command].get(command + "_desc");
		if desc != null:
			self.print(desc);

var history_help = "Prints all previously entered commands";
func history_cmd():
	self.print("History is empty" if history.size() == 0 else PoolStringArray(history).join("\n"));

var clear_help = "Clears console output";
func clear_cmd():
	label.clear();
