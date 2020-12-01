extends Sprite


onready var lights = $Lights

var glow_amount = 1.2
var inc = 0.0025


func _physics_process(_delta):
	glow_amount += inc
	lights.set_modulate(Color(glow_amount,glow_amount,glow_amount,1))
	
	if glow_amount > 1.6 or glow_amount < 1.2:
		inc *= -1
