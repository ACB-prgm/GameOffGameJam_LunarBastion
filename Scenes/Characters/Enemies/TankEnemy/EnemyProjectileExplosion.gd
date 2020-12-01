extends Particles2D


func _ready():
	set_emitting(true)
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
