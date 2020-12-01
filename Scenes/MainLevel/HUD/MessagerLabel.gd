extends Label


onready var tween = $Tween


func _ready():
	hide()

func display_message(message):
	set_text(message)
	show()
	tween.interpolate_property(self, 'modulate', Color(1,1,1,1.1), Color(1,1,1,0), 
	0.75, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	tween.start()

func _on_Tween_tween_all_completed():
	hide()
