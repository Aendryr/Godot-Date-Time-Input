extends Panel
# Used when dragging the hand of the clock
var dragging = false
# Only change hand when mouse is in clock // drag can still change it after has left the clock but it has to start in clock
var mouse_in_clock=false;
# Default time when empty
var hour="12";
# Used to disable input
var disabled=true

# Used for selecting hour //either by click or drag
# If mouse clicks outside parent hide
func _input(event):
	if(!disabled):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if not dragging and event.pressed and (mouse_in_clock and !get_parent().mouse_in):
				dragging = true
				hour=get_parent().get_closest_label(get_tree().get_nodes_in_group("date-time-hours-popup"),get_global_mouse_position()).text
				$Hand.rotation_degrees=30*(int(hour))
			if dragging and not event.pressed: 
				dragging = false
				hide()
				get_parent().change_time(hour,"")
		if event is InputEventMouseMotion and dragging:
			hour=get_parent().get_closest_label(get_tree().get_nodes_in_group("date-time-hours-popup"),get_global_mouse_position()).text
			$Hand.rotation_degrees=30*(int(hour))

func _on_Hours_mouse_entered():
	mouse_in_clock=true
func _on_Hours_mouse_exited():
	mouse_in_clock=false

# disable input when hidden
# reset mouse
func _on_Hours_hide():
	disabled=true
	mouse_in_clock=false

# enable input when shown
# change hand to selected minute
func _on_Hours_draw():
	disabled=false
	$Hand.rotation_degrees=30*(int(hour))
