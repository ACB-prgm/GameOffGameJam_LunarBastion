extends Particles2D


func start():
	set_emitting(true)
	$Timer.start()


func _on_Timer_timeout():
	set_emitting(false)
