extends Panel
##Script that handles Clock functionality

## Mouse Entered
var mouse_in:bool=false;

func _ready():
	get_parent().time_changed.connect(_on_time_changed);

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
			if(event.pressed):
				hide()

func _on_mouse_entered()->void:
	mouse_in=true
func _on_mouse_exited()->void:
	mouse_in=false

# If clock scene resets. Reset children visibility.
func _on_visibility_changed():
	if(self.visible):
		$Minutes.hide()
		$Hours.show()
# Hide when pressing the close button
func _on_cancel_pressed():
	self.hide();
	mouse_in=false;

# Change meridian
func _on_AMPM_pressed(a_p:String):
	get_parent().time_changed.emit($LayoutTop/Value.text,a_p)

# Switch popup to manual clock popup
func _on_SwitchToManual_pressed()->void:
	hide()
	get_parent().get_node("ManualClock").show()
	get_parent().popup="ManualClock"

# Change time
func _on_time_changed(time,ampm)->void:
	$LayoutTop/Value.text=time;
	time=time.split(":")
	$Hours.hour=time[0]
	$Minutes.minute=time[1]

## Returns the closest label to a Vector2 position
func get_closest_label(group:Array,mouse:Vector2)->Label:
	var min_distance=INF;
	var label=null;
	for l in group:
		var distance= (l.global_position+Vector2(17,17)).distance_to(mouse)
		if (distance < min_distance):
			min_distance=distance
			label=l
	return label;

## Used by children to emit time_changed signal.
func change_time(hour,minute)->void:
	if(hour!="" and minute==""):
		$Minutes.show()
		get_parent().time_changed.emit(hour+":"+$Minutes.minute, $LayoutTop/AMPMContainer/AM.button_group.get_pressed_button().name.to_lower())
	if(hour=="" and minute!=""):
		get_parent().time_changed.emit($Hours.hour+":"+minute, $LayoutTop/AMPMContainer/AM.button_group.get_pressed_button().name.to_lower())
		self.hide()
