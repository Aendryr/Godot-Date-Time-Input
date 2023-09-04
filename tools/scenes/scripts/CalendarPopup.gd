extends Popup

@onready var selecteddatetime = DTCalendar.new()
@onready var displaydatetime = DTCalendar.new()

func _ready():
	$ScrollContainer.hide()
	$Title/Month.text = selecteddatetime.format("MMMM YYYY")
	
	for a in selecteddatetime.Week_Days:
		var week_day=Label.new()
		week_day.text=selecteddatetime.Week_Days[a]['name'].left(1)
		$WeekDays.add_child(week_day)
	
	var startint = false;
	var inc = 0;
	var firstday = selecteddatetime.get_first_day_month_as_week()
	var daysinmonth = selecteddatetime.get_days_in_current_month()
	var group = ButtonGroup.new()
	for w in 6:
		for d in 7: 
			if(w==0 and firstday == d):
				startint=true;
			var but=Button.new()
			but.button_group=group;
			but.toggle_mode=true
			but.toggled.connect(_on_day_toggled)
			if(startint and inc < daysinmonth):
				inc=inc+1
				but.text=str(inc)
			$Days.add_child(but);
			if(inc == selecteddatetime.DateTime["day"]):
				but.name="curent"
				but.button_pressed=true
	
	group = ButtonGroup.new()
	for i in range(selecteddatetime.MIN_YEAR,selecteddatetime.MAX_YEAR):
		var but=Button.new()
		but.text=str(i)
		but.button_group=group;
		but.toggle_mode=true
		but.toggled.connect(_on_year_toggled)
		$ScrollContainer/Years.add_child(but);
		if(selecteddatetime.DateTime["year"]==i):
			but.name="curent"
			but.button_pressed=true
		

func _on_day_toggled(button_pressed):
	if(button_pressed==true):
		selecteddatetime.edit(selecteddatetime.DAY_OF_MONTH,int($Days.get_node("curent").button_group.get_pressed_button().text))
		displaydatetime.edit(displaydatetime.DAY_OF_MONTH,int($Days.get_node("curent").button_group.get_pressed_button().text))
		selecteddatetime.edit(selecteddatetime.MONTH,displaydatetime.DateTime['month'])
		selecteddatetime.edit(selecteddatetime.YEAR,displaydatetime.DateTime['year'])

func _on_year_toggled(button_pressed):
	if(button_pressed==true):
		selecteddatetime.edit(selecteddatetime.YEAR,int($ScrollContainer/Years.get_node("curent").button_group.get_pressed_button().text))
		displaydatetime.edit(displaydatetime.YEAR,int($ScrollContainer/Years.get_node("curent").button_group.get_pressed_button().text))
#		selecteddatetime.edit(selecteddatetime.MONTH,displaydatetime.DateTime['month'])
#		selecteddatetime.edit(selecteddatetime.YEAR,displaydatetime.DateTime['year'])

func _on_Prev_pressed():
	displaydatetime.add(displaydatetime.MONTH,-1)
	var inc = 0
	var startint = false;
	var firstday = displaydatetime.get_first_day_month_as_week()
	var daysinmonth = displaydatetime.get_days_in_current_month()
	for i in $Days.get_children():
		i.text=""
		i.button_pressed=false
		if(inc==firstday and !startint):
			startint=true
			inc=1
		if(startint and inc <= daysinmonth):
			i.text=str(inc)
			if(displaydatetime.format("M/YY")==selecteddatetime.format("M/YY") && selecteddatetime.DateTime['day']==int(i.text)):
				i.button_pressed=true
		inc+=1;
	$Title/Month.text = displaydatetime.format("MMMM YYYY")

func _on_Next_pressed():
	displaydatetime.add(displaydatetime.MONTH,1)
	var inc = 0
	var startint = false;
	var firstday = displaydatetime.get_first_day_month_as_week()
	var daysinmonth = displaydatetime.get_days_in_current_month()
	for i in $Days.get_children():
		i.text=""
		i.button_pressed=false
		if(inc==firstday and !startint):
			startint=true
			inc=1
		if(startint and inc <= daysinmonth):
			i.text=str(inc)
			if(displaydatetime.format("M/YY")==selecteddatetime.format("M/YY") && selecteddatetime.DateTime['day']==int(i.text)):
				i.button_pressed=true
		inc+=1;
	$Title/Month.text = displaydatetime.format("MMMM YYYY")

func _on_SelectYears_toggled(button_pressed):
	if(button_pressed):
		$Title/SelectYears.text="^"
		$Days.hide();
		$ScrollContainer.show();
		await get_tree().idle_frame;
		var year=$ScrollContainer/Years.get_node("curent").group.get_pressed_button()
		$ScrollContainer.scroll_vertical = (ceil((int(year.text)-(selecteddatetime.MIN_YEAR))/$ScrollContainer/Years.columns)-1)*22
	else:
		$Title/SelectYears.text="v"
		$ScrollContainer.hide();
		$Days.show();
