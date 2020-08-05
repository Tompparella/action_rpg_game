extends Label

var current : int = 0
var maximum : int = 0

func set_current(new_cur):
	current = new_cur
	set_text("%s / %s" % [new_cur, maximum])
	
func set_maximum(new_max):
	maximum = new_max
	set_text("%s / %s" % [current, new_max])
	
func initialize(new_cur, new_max):
	current = new_cur
	maximum = new_max
	set_text("%s / %s" % [current, new_max])
	
	
