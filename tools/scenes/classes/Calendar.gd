class_name DTCalendar

var Week_Days={
	1:{"name":"Sunday","shortname":"Sun"},
	2:{"name":"Monday","shortname":"Mon"},
	3:{"name":"Tuesday","shortname":"Tus"},
	4:{"name":"Wednesday","shortname":"Wed"},
	5:{"name":"Thursday","shortname":"Thu"},
	6:{"name":"Friday","shortname":"Fri"},
	7:{"name":"Saturday","shortname":"Sat"}
}

var Months={
	1:{"name":"January","shortname":"Jan"},
	2:{"name":"February","shortname":"Feb"},
	3:{"name":"March","shortname":"Mar"},
	4:{"name":"April","shortname":"Apr"},
	5:{"name":"May","shortname":"May"},
	6:{"name":"June","shortname":"Jun"},
	7:{"name":"July","shortname":"Jul"},
	8:{"name":"August","shortname":"Aug"},
	9:{"name":"September","shortname":"Sep"},
	10:{"name":"October","shortname":"Oct"},
	11:{"name":"November","shortname":"Nov"},
	12:{"name":"December","shortname":"Dec"}
}

const YEAR = 1
const MONTH = 2
const DAY_OF_MONTH = 3

const JANUARY   = 1 
const FEBRUARY  = 2
const MARCH     = 3
const APRIL     = 4
const MAY       = 5
const JUNE      = 6
const JULY      = 7
const AUGUST    = 8
const SEPTEMBER = 9
const OCTOBER   = 10
const NOVEMBER  = 11
const DECEMBER  = 12

const MIN_YEAR = 1900
const MAX_YEAR = 2100

var DateTime;

func _init():
	DateTime=Time.get_datetime_dict_from_system();

func add(type:int,value:int)->void:
	if(type == YEAR):
		var tempyear = DateTime["year"] + value
		if(tempyear >= MIN_YEAR and tempyear < MAX_YEAR):
			DateTime["year"] = tempyear
	if(type == MONTH):
		DateTime["month"] =  DateTime["month"] + value
		if( DateTime["month"] < JANUARY ):
			var years:float   = (DateTime["month"] / 12.0) * -1.0
			var tempyear = int(DateTime["year"] - floor(years) - 1)
			if(tempyear >= MIN_YEAR and tempyear < MAX_YEAR):
				DateTime["month"] = int(DECEMBER - floor((years - floor(years)) * 12))
				DateTime["year"]  = tempyear
		if(DateTime["month"] > DECEMBER):
			var years:float   = (DateTime["month"] / 12.0)
			var tempyear=int(DateTime["year"] + floor(years))
			if(tempyear >= MIN_YEAR and tempyear < MAX_YEAR):
				DateTime["month"] = int(JANUARY + floor((years - floor(years)) * 12))
				DateTime["year"]  = tempyear
	if(type == DAY_OF_MONTH):
		pass #Work in progress

func edit(type:int,value:int)->bool:
	if(type == DAY_OF_MONTH):
		if(value>0 && value<get_days_in_current_month()):
			DateTime["day"]=value;
			return true
		return false
	if(type == MONTH):
		if(value>=JANUARY && value <= DECEMBER):
			DateTime["month"] = value
			return true
		return false
	if(type == YEAR):
		if(value >= MIN_YEAR && value < MAX_YEAR):
			DateTime["year"]=value;
			return true
		return false
	return false

# calculate number of days in a month
func get_days_in_current_month() -> int:
	var month = DateTime["month"]
	var year  = DateTime["year"]
#	$month == 2 ? ($year % 4 ? 28 : ($year % 100 ? 29 : ($year % 400 ? 28 : 29))) : (($month - 1) % 7 % 2 ? 30 : 31);
	if(month==2):
		if(year%4):
			return 28;
		else:
			if(year%100):
				return 29
			else:
				if(year % 400):
					return 28
				else:
					return 29
	else:
		if((month - 1) % 7 % 2):
			return 30
		else:
			return 31

func get_first_day_month_as_week() -> int:
	var month = DateTime["month"]-2
	if(month==0):
		month=12
	if(month==-1):
		month=11
	var c = float(str(DateTime["year"]).substr(0,2))
	var d = float(str(DateTime["year"]).substr(2,4))
	
	#Zeller’s Rule
	if(month==11 or month==12):
		d=d-1
	
	var z= (1.0 + floor(((13.0 * month) - 1.0) / 5.0) + d + floor(d / 4.0) + floor(c / 4.0) - (2.0 * c))

	if(z<0):
		z=z*-1.0
		if(z<7): #????
			z=7-z
	return int(z)%7


func take(type:int,value:int)->Dictionary:
	var tempdate=DateTime;
	if(type == YEAR):
		var tempyear = tempdate["year"] + value
		if(tempyear >= MIN_YEAR and tempyear < MAX_YEAR):
			tempdate["year"] = tempyear
			return tempdate
	if(type == MONTH):
		tempdate["month"] =  tempdate["month"] + value
		if( tempdate["month"] < JANUARY ):
			var years:float   = (tempdate["month"] / 12.0) * -1.0
			var tempyear = int(tempdate["year"] - floor(years) - 1)
			if(tempyear >= MIN_YEAR and tempyear < MAX_YEAR):
				tempdate["month"] = int(DECEMBER - floor((years - floor(years)) * 12))
				tempdate["year"]  = tempyear
				return tempdate
		if(tempdate["month"] > DECEMBER):
			var years:float   = (tempdate["month"] / 12.0)
			var tempyear=int(tempdate["year"] + floor(years))
			if(tempyear >= MIN_YEAR and tempyear < MAX_YEAR):
				tempdate["month"] = int(JANUARY + floor((years - floor(years)) * 12))
				tempdate["year"]  = tempyear
				return tempdate
	return {}




#to delete
func get_prev_month_of_date(date:Dictionary)->Dictionary:
	date["month"] =  date["month"] - 1
	if( date["month"] < JANUARY ):
		var years:float   = (date["month"] / 12.0) * -1.0
		var tempyear = int(date["year"] - floor(years) - 1)
		if(tempyear >= MIN_YEAR and tempyear < MAX_YEAR):
			date["month"] = int(DECEMBER - floor((years - floor(years)) * 12))
			date["year"]  = tempyear
	return date;

func get_next_month_of_date(date:Dictionary)->Dictionary:
	date["month"] =  date["month"] + 1
	if( date["month"] < JANUARY ):
		var years:float   = (date["month"] / 12.0) * -1.0
		var tempyear = int(date["year"] - floor(years) - 1)
		if(tempyear >= MIN_YEAR and tempyear < MAX_YEAR):
			date["month"] = int(DECEMBER - floor((years - floor(years)) * 12))
			date["year"]  = tempyear
	return date;


func format(format:String)->String:
	if(DateTime["day"]<10):
		format=format.replace("D","0"+str(DateTime["day"]));
	else:
		format=format.replace("D",str(DateTime["day"]));
	
	format=format.replace("YYYY",str(DateTime["year"]));
	format=format.replace("YY",str(DateTime["year"]).substr(2,4));
	format=format.replace("MMMM",Months[DateTime["month"]]['name']);
	format=format.replace("MM",Months[DateTime["month"]]['shortname']);
	
	if(DateTime["month"]<10):
		format=format.replace("M","0"+str(DateTime["month"]));
	else:
		format=format.replace("M",str(DateTime["month"]));
	
	return format;
