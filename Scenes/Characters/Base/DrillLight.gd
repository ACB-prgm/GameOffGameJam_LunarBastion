extends Sprite

onready var drillLightTween = $DrillLightTween
onready var bright = modulate
var dim = Color(1.5,1.1,1,1)
var flash_time = 0.5
var light = true

func _ready():
	_on_DrillLightTween_tween_all_completed()


func _on_DrillLightTween_tween_all_completed():
	match light:
		true:
			light = false
			drillLightTween.interpolate_property(self, 'modulate', bright, dim, 
			flash_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		false:
			light = true
			drillLightTween.interpolate_property(self, 'modulate', dim, bright, 
			flash_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	drillLightTween.start()
