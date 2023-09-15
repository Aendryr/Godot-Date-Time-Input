extends Panel

## Used when dragging the hand of the clock
var dragging = false

## Only change hand when mouse is in clock.
## drag can still change it after has left the clock but it has to start in clock.
## releasing the mouse outside parent will hide the selection.
var mouse_in_clock=false;
## Default time when empty
var hour="12";
## Used to disable input
var disabled=true

## Used for selecting minute (either by click or drag)
## If mouse clicks outside parent hide
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

func _on_mouse_entered():
	mouse_in_clock=true
func _on_mouse_exited():
	mouse_in_clock=false

# enable input when shown and disable input when hidden
func _on_visibility_changed():
	# change hand to selected hour
	if(self.visible):
		disabled=false
		$Hand.rotation_degrees=30*(int(hour))
	# reset mouse
	else:
		disabled=true
		mouse_in_clock=false
