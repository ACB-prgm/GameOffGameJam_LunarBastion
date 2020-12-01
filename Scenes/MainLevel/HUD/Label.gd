extends Label


var minute_survived = 0
var sec_survived = 0
var ms_survived = 0
var print_ms_survived = 0
var total_time_survived = 0


func _on_Timer_timeout():
	ms_survived += 1
	if ms_survived % 60 == 0:
		ms_survived = 0
		sec_survived += 1
		if sec_survived % 60 == 0:
			sec_survived = 0
			minute_survived += 1
	
	if ms_survived < 10:
		print_ms_survived = '0%s' % [ms_survived]
	else:
		print_ms_survived = ms_survived
	
	set_text('%s.%s.%s' % [minute_survived, sec_survived, print_ms_survived])
	
	total_time_survived = minute_survived + sec_survived/100.0 + 0.01
