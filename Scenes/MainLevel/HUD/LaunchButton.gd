extends Button


var change_amount = 1
var inc = 0.05


func _physics_process(_delta):
	change_amount += inc
	
	set_modulate(Color(1,1,1,change_amount))
	
	if change_amount > 1.05 or change_amount < .5:
		inc *= -1
