@tool
extends LineEdit

@export var format:String="DD/MM/YYYY";

func _enter_tree() -> void :
	self.focus_entered.connect(_on_click)

func _ready() -> void :
	var pop_calendar=preload("res://addons/date-time-elements/tools/scenes/Calendar.tscn").instantiate()
	self.add_child(pop_calendar)

func _on_click():
	var a = InputEventMouseButton.new()
	a.set_button_index(1)
	a.set_pressed(false)
	Input.parse_input_event(a)
	self.release_focus()
#	get_node(popup).popup()
