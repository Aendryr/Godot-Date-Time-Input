extends PopupDialog

# Check if mouse is in clock (signals)
var mouse_in=false;
func _on_Clock_mouse_exited():
	mouse_in=false
func _on_Clock_mouse_entered():
	mouse_in=true

# If clock scene resets. Reset children visibility.
func _on_Clock_about_to_show():
	$Minutes.hide()
	$Hours.show()

func get_closest_label(group:Array,mouse:Vector2)->Label:
	var min_distance=INF;
	var label=null;
	for l in group:
		var distance= (l.rect_global_position+Vector2(17,17)).distance_to(mouse)
		if (distance < min_distance):
			min_distance=distance
			label=l
	return label;

# Hide when pressing the close button
func _on_Close_pressed():
	self.hide()

# Change meridian
func _on_AMPM_pressed(a_p:String):
	get_parent().emit_signal("time_changed",$Time/HoursMinutes.text,a_p)

# Change time
func _on_time_changed(time,ampm)->void:
	$Time/HoursMinutes.text=time;
	time=time.split(":")
	$Hours.hour=time[0]
	$Minutes.minute=time[1]

#Emit time changed signal and toggle(hide/show) hours/minutes panels
func change_time(hour,minute)->void:
	if(hour!="" and minute==""):
		$Minutes.show()
		get_parent().emit_signal("time_changed", hour+":"+$Minutes.minute, $VBoxContainer/AM.group.get_pressed_button().name.to_lower())
	if(hour=="" and minute!=""):
		get_parent().emit_signal("time_changed", $Hours.hour+":"+minute, $VBoxContainer/AM.group.get_pressed_button().name.to_lower())
		self.hide()
	
# Switch popup to manual clock popup
func _on_SwitchToManual_pressed()->void:
	hide()
	get_parent().get_node("ManualClock").popup()
	get_parent().popup="ManualClock"
