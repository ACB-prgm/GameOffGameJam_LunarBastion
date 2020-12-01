extends Area2D


var damage = 3


func _ready():
	$Particles2D.set_emitting(true)
	

func _on_CollisionTimer_timeout():
	set_deferred('monitorable', false)


func _on_DeathTimer_timeout():
	queue_free()
