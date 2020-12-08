extends Node2D


onready var line = $Line2D
onready var particles = $Particles2D
onready var tween = $Tween

var animating = false


func _ready():
	set_modulate(Color(1,1,1,0))
	particles.set_emitting(false)


func animate():
	animating = true
	set_modulate(Color(1,1,1,1))
	particles.set_emitting(true)
	
	tween.interpolate_property(line, 'modulate', Color(1,1,1,.5), Color(1,1,1,1), 
	0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(line, 'scale', Vector2(0.5, 0.5), Vector2(1.25, 1.75),
	0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	
	tween.start()


func _on_Tween_tween_all_completed():
	if animating:
		animating = false
		tween.interpolate_property(self, 'modulate', modulate, Color(1,1,1,0), 
		1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT, 2)
		
		tween.start()
	else:
		particles.set_emitting(false)
