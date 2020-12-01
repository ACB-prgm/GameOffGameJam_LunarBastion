extends Node2D


func play_Anim():
	$Particles2D.set_emitting(true)
	$ShockwaveAnimatedSprite.play()
	$DeathTimer.start()

func _on_DeathTimer_timeout():
	queue_free()
