@tool
extends LineEdit
## An InputField for Time

## Singal for changing time
signal time_changed;

## If active will get current time as implicit value.
## The value is set on the _ready function.
@export var current_time:bool = false

## Which popup should be displayed by default when first click happens
@export_enum("Clock","ManualClock") var popup:String = "Clock"

## The color of the clock hand 
@export_color_no_alpha var hand_color = Color8(72,148,60)

## Implicit placeholder text
var format:String="hh:mm (a/p)m";

# Force placeholder to be "hh:mm (a/p)m" // WIP
func _init() -> void:
	self.placeholder_text=format

# Add nodes from tools/scenes for selecting time
# Change hand color for Time.tscn
# Connect signal time_changed to self and children
func _ready() -> void:
	var time_clock        = preload("res://addons/date-time-elements/tools/scenes/clock.tscn").instantiate()
	var manual_time_clock = preload("res://addons/date-time-elements/tools/scenes/manual_clock.tscn").instantiate()
	
	time_clock.global_position=Vector2(get_viewport_rect().size.x/2 - time_clock.size.x / 2,0)
	time_clock.get_node("Hours/Hand/Center").modulate      = hand_color;
	time_clock.get_node("Hours/Hand/Circle").modulate      = hand_color;
	time_clock.get_node("Hours/Hand/Panel").modulate       = hand_color;
	time_clock.get_node("Minutes/Hand/Center").modulate    = hand_color;
	time_clock.get_node("Minutes/Hand/Circle").modulate    = hand_color;
	time_clock.get_node("Minutes/Hand/Panel").modulate     = hand_color;
	manual_time_clock.global_position=Vector2(get_viewport_rect().size.x/2 - manual_time_clock.size.x / 2,0)
	
	self.add_child(time_clock)
	self.add_child(manual_time_clock)
	
	self.time_changed.connect(_on_time_changed);
	
	if(current_time):
		self.time_changed.emit(get_current_time()[0],get_current_time()[1])
	self.focus_entered.connect(_on_click)

##  Releases focus and mouse button from LineEdit
func _on_click() -> void:
	var a = InputEventMouseButton.new()
	a.set_button_index(1)
	a.set_pressed(false)
	Input.parse_input_event(a)
	self.release_focus()
	get_node(popup).show()

## Changes the text of the LineEdit
func _on_time_changed(time,ampm)->void:
	self.text=time+" "+ampm

## return [ 0 => "hour:min":String, 1 => "am/pm":string ]:Array
func get_current_time()->Array:
	var time:Dictionary = Time.get_datetime_dict_from_system()
	var hour = time["hour"]
	var minute = time["minute"] 
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
