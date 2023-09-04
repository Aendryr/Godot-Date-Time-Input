@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("TimeEdit", "LineEdit", preload("scripts/time-input.gd"), preload("tools/assets/time-icon.png"))
	add_custom_type("DateEdit", "LineEdit", preload("scripts/date-input.gd"), preload("tools/assets/time-icon.png"))

func _exit_tree():
	remove_custom_type("TimeEdit")
	remove_custom_type("DateEdit")
