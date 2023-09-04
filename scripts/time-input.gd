@tool
extends LineEdit
# Singal for changing time (texts or other nodes or events)
signal time_changed;

# If active will display curent time at the start of the scene
@export var Current_Time:bool = false 
#: set = _set_current_time, get = _get_current_time
# Which popup should be displayed by default
@export_enum("Clock","ManualClock") var popup:String = "Clock"
# The color of the hand from Time.tscn
@export var Hand_Color:Color = Color(72,148,60)

# Placeholder text
var format:String="hh:mm (a/p)m";

# Force placeholder to be "hh:mm (a/p)m" // WIP
func _init() -> void:
	self.placeholder_text=format

# Add nodes from tools/scenes for selecting time
# Change hand color for Time.tscn
# Connect signal time_changed to self and children
func _ready() -> void:
	var time_clock=preload("res://addons/date-time-elements/tools/scenes/Clock.tscn").instantiate()
	time_clock.get_node("Hours/Hand/Center").modulate=Hand_Color;
	time_clock.get_node("Hours/Hand/Circle").modulate=Hand_Color;
	time_clock.get_node("Hours/Hand/Line").default_color=Hand_Color;
	time_clock.get_node("Minutes/Hand/Center").modulate=Hand_Color;
	time_clock.get_node("Minutes/Hand/Circle").modulate=Hand_Color;
	time_clock.get_node("Minutes/Hand/Line").default_color=Hand_Color;
	var manual_time_clock=preload("res://addons/date-time-elements/tools/scenes/ManualClock.tscn").instantiate()
	self.add_child(time_clock)
	self.add_child(manual_time_clock)
	self.time_changed.connect(_on_time_changed);
	self.get_node("ManualClock").time_changed.connect(_on_time_changed);
	self.get_node("Clock").time_changed.connect(_on_time_changed);
	
	if(Current_Time):
		emit_signal("time_changed",get_current_time()[0],get_current_time()[1])

func _enter_tree() -> void :
	self.focus_entered.connect(_on_click)

# On click release focus and release mouse button
func _on_click() -> void:
	var a = InputEventMouseButton.new()
	a.set_button_index(1)
	a.set_pressed(false)
	Input.parse_input_event(a)
	self.release_focus()
	get_node(popup).popup()

# Signal time_changed
func _on_time_changed(time,ampm):
	self.text=time+" "+ampm

# Min length = 8
func _set(property: StringName, value) -> bool:
	if property == "max_length":
		if(value<8):
			max_length=8
			return true
		max_length=value
		return true
	return false

#Change text when Current_Time property is changed
func _set_current_time(active:bool) -> void:
	Current_Time=active
	if(active):
		text=get_current_time()[0]+" "+get_current_time()[1]
	else:
		text=""

# return [ 0 => "hour:min":String, 1 => "am/pm":string ]:Array
func get_current_time()->Array:
	var time = Time.get_datetime_dict_from_system();
	var hour = time["hour"]
	var minute= time["minute"] 
	if(minute<10):
		minute="0"+str(minute)
	var ampm=""
	if hour - 12 < 0:
		ampm = "am"
	else:
		ampm = "pm" 
	hour=abs(hour-12);
	if(hour<10):
		hour="0"+str(hour)
	return [str(hour)+":"+str(minute),ampm]
