extends Panel
# Used when dragging the hand of the clock
var dragging = false
# Only change hand when mouse is in clock // drag can still change it after has left the clock but it has to start in clock
var mouse_in_clock=false;
# Default time when empty
var minute="00";
# Used to disable input
var disabled=true;

# Used for selecting minute //either by click or drag
# If mouse clicks outside parent hide
func _input(event):
	if(!disabled):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if not dragging and event.pressed and (mouse_in_clock and !get_parent().mouse_in):
				dragging = true
				minute=get_parent().get_closest_label(get_tree().get_nodes_in_group("date-time-minutes-popup"),get_global_mouse_position()).text
				$Hand.rotation_degrees=6*(int(minute))
			if dragging and not event.pressed:
				dragging = false
				hide()
				get_parent().change_time("",minute)
		if event is InputEventMouseMotion and dragging:
			minute=get_parent().get_closest_label(get_tree().get_nodes_in_group("date-time-minutes-popup"),get_global_mouse_position()).text
			$Hand.rotation_degrees=6*(int(minute))

func _on_Minutes_mouse_entered():
	mouse_in_clock=true
func _on_Minutes_mouse_exited():
	mouse_in_clock=false

# disable input when hidden
# reset mouse
func _on_Minutes_hide():
	disabled=true
	mouse_in_clock=false

# enable input when shown
# change hand to selected minute
func _on_Minutes_draw():
	disabled=false
	$Hand.rotation_degrees=6*(int(minute))

