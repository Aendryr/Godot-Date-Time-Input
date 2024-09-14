extends Panel
##Script that handles Manual Clouk functionality
var previous_text = ""

func _ready():
	get_parent().time_changed.connect(_on_time_changed);

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
			if(event.pressed):
				hide()

# Check if format is valid using regex
func _on_time_edit_text_changed(new_text):
	var regex = RegEx.new()
	regex.compile("^(0?[0-9]|1[0-2])?(:([0-5]?[0-9])?)? ?([AaPp]?[Mm]?)?$");
	var result=regex.search(new_text)
	if(result):
		var temp_carret = $TimeEdit.caret_column
		$TimeEdit.text=result.get_string();
		$TimeEdit.caret_column=temp_carret
		
		regex.compile('^(\\d{2})$');
		var result2=regex.search(new_text)
		if(result2):
			if(!previous_text.contains(':')):
				$TimeEdit.text=result2.get_string()+":";
				$TimeEdit.set_caret_column($TimeEdit.text.length())
		else:
			regex.compile("((1[0-2]|0?[1-9]):([0-5]?[0-9]) ?([AaPp]))")
			var result3=regex.search(new_text)
			
			if(result3):
				result = result3.get_string().split(" ");
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
				if(hour+":"+minute+" "+ampm != $LayoutTop/Value.text+" "+$LayoutTop/AMPMContainer/AM.button_group.get_pressed_button().name.to_lower()):
					get_parent().time_changed.emit(hour+":"+minute,ampm);
	else:
		$TimeEdit.delete_char_at_caret()
		if($TimeEdit.text.length()==0):
			$TimeEdit.clear()
	previous_text = new_text;


# Set cursor at the end of the line //blinking is enabled
func _on_time_edit_focus_entered():
	$TimeEdit.set_caret_column(len($TimeEdit.text))

# Change meridian
func _on_AMPM_pressed(a_p): 
	get_parent().time_changed.emit($LayoutTop/Value.text,a_p)
	$TimeEdit.text = $LayoutTop/Value.text+" "+$LayoutTop/AMPMContainer/AM.button_group.get_pressed_button().name.to_lower()

# Switch popup to clock popup
func _on_ChangeToClock_pressed():
	self.hide()
	get_parent().get_node("Clock").show()
	get_parent().popup="Clock"

# Hide when pressing the close button
func _on_close_pressed():
	self.hide()

# When visible update TimeEdit
func _on_draw():
	$TimeEdit.text = $LayoutTop/Value.text+" "+$LayoutTop/AMPMContainer/AM.button_group.get_pressed_button().name.to_lower()

# Change time
func _on_time_changed(time,ampm):
	$LayoutTop/Value.text = time
	get_node("LayoutTop/AMPMContainer/"+ampm.to_upper()).button_pressed=true
