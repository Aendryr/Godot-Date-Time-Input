extends Popup

# Hide when pressing the close button
func _on_Close_pressed():
	self.hide()

# Check if format is valid using regex
func _on_TimeInput_text_changed(new_text):
	var regex=RegEx.new()
	regex.compile("((1[0-2]|0?[1-9]):([0-5]?[0-9]) ?([AaPp]))")
	var result=regex.search(new_text)
	if(result):
		result = result.get_string().split(" ");
		var ampm=result[1];
		result = result[0].split(":");
		var hour=result[0];
		var minute=result[1];
		if(len(hour)==1):
			hour="0"+hour
		if(len(minute)==1):
			minute="0"+minute;
		if(ampm.to_lower() == "a"):
			ampm="am";
		if(ampm.to_lower() == "p"):
			ampm="pm"
		if(hour+":"+minute+" "+ampm != $Time/HoursMinutes.text+" "+$VBoxContainer/AM.group.get_pressed_button().name.to_lower()):
			get_parent().emit_signal("time_changed",hour+":"+minute,ampm);

# Set cursor at the end of the line //blinking is enabled
func _on_TimeInput_focus_entered():
	$TimeInput.set_cursor_position(len($TimeInput.text))

# Change meridian
func _on_AMPM_pressed(a_p): 
	get_parent().emit_signal("time_changed",$Time/HoursMinutes.text,a_p)
	$TimeInput.text = $Time/HoursMinutes.text+" "+$VBoxContainer/AM.group.get_pressed_button().name.to_lower()

# Change time
func _on_time_changed(time,ampm):
	$Time/HoursMinutes.text = time
	get_node("VBoxContainer/"+ampm.to_upper()).pressed=true

# Switch popup to clock popup
func _on_ChangeToClock_pressed():
	hide()
	get_parent().get_node("Clock").popup()
	get_parent().popup="Clock"

# When shown change text
func _on_ManualClock_draw():
	$TimeInput.text = $Time/HoursMinutes.text+" "+$VBoxContainer/AM.group.get_pressed_button().name.to_lower()


