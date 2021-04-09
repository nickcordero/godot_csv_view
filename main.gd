extends Node2D

var data_array = []
var header_array = ["Location","Type","Number","MAC","Make","Model","Version","Serial","OS","User","Department","Date","Comments","Retired"]

var column_widths_array = []

var winx = 1024
var winy = 600

var column_widths_track = []

var csv_data = "WA,LA,1,87MACADDRESS01,Lenovo testing length to see how long,MODEL1,123123SDFA,12345SDFG,Windows 10,Dwayne Johnson,Acting,01/09/2019,test comment,F" + "\n" \
+ "WA,LA,15,45MACADDRESS01,Microsoft,MODEL43,123SDF,12354DFD,Ubuntu,Chris Rock,Comedy,03/01/2017,,F" + "\n" \
+ "WA,LA,2,45MACADDRESS01,Microsoft,MODEL43,123SDF,12354DFD,Ubuntu,Chris Rock,Comedy,03/01/2017,,F" + "\n" \
+ "TN,EQ,3,32MACADDRESS01,Lenovo,MODEL32,99K3H7FH3,123DSG,Windows 10,Jim Carrey,Comdedy,01/09/2019,,F" + "\n" \
+ "CA,LA,4,67MACADDRESS01,Lenovo,MODEL15,FJJ72HF27F,345GFDGD,Windows 10,Chris Walken,Acting,02/19/2019,,F" + "\n" \
+ "US,LA,5,43MACADDRESS01,Lenovo,MODEL76,09UFDH73F4,123SDFS,Ubuntu,Jack Black,Acting,09/01/2016,,F" + "\n" \
+ "EU,DE,6,44MACADDRESS01,HP,MODEL44,343DSFF,345DFDG,Windows 7,Harrison Ford,Acting,03/01/2017,,F" + "\n" \
+ "CA,LA,7,72MACADDRESS01,Lenovo,MODEL44,123SDFSD,123SDFSD,Windows 10,Tom Cruise,Acting,09/19/2018,,F" + "\n" \
+ "ID,LA,8,4MACADDRESS01,Acer,MODEL36,345SDFSDF,345SDDFG,Windows 10,Babe Ruth,Sports,,,F" + "\n" \
+ "MN,EQ,9,6MACADDRESS01,Lenovo,MOMDEL17,123SDFF,123SDFFD,Windows 10,Clinton,Government,07/15/2017,This is a really long comment to test how the sizing works,F" + "\n" \
+ "WA,LA,10,15MACADDRESS01,Lenovo,MODEL19,2398AFHIWFA,345SDFSDF,Windows 10,Lincoln,Government,09/19/2018,,F" + "\n" \
+ "ID,LA,11,36MACADDRESS01,Lenovo,MODEL35,GIUH43732,123SDFSD,Ubuntu,George Carlin,Comedy,11/15/2016,,F" + "\n" \
+ "ID,DE,12,34MACADDRESS01,Lenovo,MODEL44,JFHUSDF7823,234SDFFSD,Windows 7,Bush,Government,03/01/2017,lets try a test comment,F" + "\n" \
+ "WA,LA,13,62MACADDRESS01,Lenovo,MODEL45,ASDHUIF43,123SDFSD,Windows 10,Obama,Government,01/09/2019,another test comment,F" + "\n" \
+ "WA,LA,14,87MACADDRESS01,Lenovo testing length to see how long,MODEL1,123123SDFA,12345SDFG,Windows 10,Dwayne Johnson,Acting,01/09/2019,test comment,F" + "\n" \
+ "TN,EQ,16,32MACADDRESS01,Lenovo,MODEL32,99K3H7FH3,123DSG,Windows 10,Jim Carrey,Comdedy,,,T" + "\n" \
+ "ID,LA,24,36MACADDRESS01,Lenovo,MODEL35,GIUH43732,123SDFSD,Ubuntu,George Carlin,Comedy,11/15/2016,,F" + "\n" \
+ "CA,LA,17,67MACADDRESS01,Lenovo,MODEL15,FJJ72HF27F,345GFDGD,Windows 10,Chris Walken,Acting,02/19/2019,,F" + "\n" \
+ "US,LA,18,43MACADDRESS01,Lenovo,MODEL76,09UFDH73F4,123SDFS,Ubuntu,Jack Black,Acting,09/01/2016,,F" + "\n" \
+ "EU,DE,19,44MACADDRESS01,HP,MODEL44,343DSFF,345DFDG,Windows 7,Harrison Ford,Acting,03/01/2017,,F" + "\n" \
+ "CA,LA,20,72MACADDRESS01,Lenovo,MODEL44,123SDFSD,123SDFSD,Windows 10,Tom Cruise,Acting,09/19/2018,,T" + "\n" \
+ "ID,LA,21,4MACADDRESS01,Acer,MODEL36,345SDFSDF,345SDDFG,Windows 10,Babe Ruth,Sports,02/19/2019,,F" + "\n" \
+ "MN,EQ,22,6MACADDRESS01,Lenovo,MOMDEL17,123SDFF,123SDFFD,Windows 10,Clinton,Government,07/15/2017,This is a really long comment to test how the sizing works,F" + "\n" \
+ "WA,LA,23,15MACADDRESS01,Lenovo,MODEL19,2398AFHIWFA,345SDFSDF,Windows 10,Lincoln,Government,09/19/2018,,T" + "\n" \
+ "ID,DE,25,34MACADDRESS01,Lenovo,MODEL44,JFHUSDF7823,234SDFFSD,Windows 7,Bush,Government,03/01/2017,lets try a test comment,F" + "\n" \
+ "WA,LA,26,62MACADDRESS01,Lenovo,MODEL45,ASDHUIF43,123SDFSD,Windows 10,Obama,Government,01/09/2019,another test comment,F"

func _ready():
	#open via csv file or a csv string. Comment or uncomment lines 43 / 44 for desired example.

	#display_data("file")	
	display_data("string")
	
	validate_window_size()

func display_data(type):
	if (type == "file"):
		var file = File.new()
		file.open("res://inventory/long.imd", file.READ)
		while !file.eof_reached():
			var line = file.get_line()
			if line != "":
				var linearray = line.split(",")
				data_array.append(linearray)
		file.close()
		filter_data()
		
	elif (type == "string"):
		var csv_array = csv_data.split("\n")
		for i in range(csv_array.size()):
			var linearray = csv_array[i].split(",")
			data_array.append(linearray)
		filter_data()

func update_output():
	if (data_array.size() > 0):
		get_node("DataHeaders").text = update_header()
		get_node("DataOutput").text = get_output()
	else:
		get_node("DataOutput").text = ""

func find_column_widths():
	print("test")
	column_widths_track.clear()
	column_widths_track = get_widths()

func _process(delta):
	get_node("DataHeaders").set_h_scroll(get_node("DataOutput").get_h_scroll())
	if OS.is_window_focused():
		validate_window_size()

func validate_window_size():
	if winx != OS.window_size.x or winy != OS.window_size.y:
		
		winx = OS.window_size.x
		winy = OS.window_size.y
		validate_output_size()
			
func validate_output_size():
	get_node("DataHeaders").rect_size.x = winx
	get_node("DataOutput").rect_size.x = winx
	get_node("DataOutput").rect_size.y = winy - 25

func filter_data():
	if (data_array.size() > 0):
		find_column_widths()
	update_output()

func update_header():
	var output_column = ""
	var output_line = ""
	var output_text = ""
	var header_text = ""
	
	for y in range(header_array.size()):
		output_column = header_array[y]
		var ccount = 0
		for chars in output_column:
			ccount += 1
		if ccount < column_widths_track[y]:
			var spaces_needed = column_widths_track[y] - ccount
			for z in range(spaces_needed):
				output_column += " "
		output_line += output_column

	var starter_header_spaces = " "
	var linenums = str(data_array.size())
	for chars in linenums:
		starter_header_spaces += " "
	
	return starter_header_spaces + output_line + "\n"

func get_output():
	var output_column = ""
	var output_line = ""
	var output_text = ""
	var header_text = ""
	
	for x in range(data_array.size()):
		output_line = ""
		output_column = ""
		output_line = ""
		output_column = ""
		for y in range(data_array[0].size()):
			output_column = data_array[x][y]
			var ccount = 0
			for chars in output_column:
				ccount += 1
			if ccount < column_widths_track[y]:
				var spaces_needed = column_widths_track[y] - ccount
				for z in range(spaces_needed):
					output_column += " "
			output_line += output_column
		if x == data_array.size():
			output_text += output_line
		else:
			if x == data_array.size() - 1:
				output_text += (output_line)
			else:
				output_text += (output_line + "\n")
	return output_text

func get_widths():
	var return_column_widths_track = []
	for i in range(data_array[0].size()):
		return_column_widths_track.append(0)

	for x in range(data_array.size()):
		for y in range(data_array[0].size()):
			var ccount = 0
			for chars in data_array[x][y]:
				ccount += 1
			if ccount > return_column_widths_track[y]:
				return_column_widths_track[y] = ccount
	
	for y in range(header_array.size()):
		var ccount = 0
		for chars in header_array[y]:
			ccount += 1
		if ccount > return_column_widths_track[y]:
			return_column_widths_track[y] = ccount

	for i in range(data_array[0].size()):
		return_column_widths_track[i] += 2
	return return_column_widths_track
