extends Area2D


onready var trail = $TrailParticles2D

var explosion = preload("res://Scenes/Characters/Enemies/TankEnemy/EnemyProjectileExplosion.tscn")
var damage = 1
var velocity = Vector2(150,0)
var alive = true


func _physics_process(delta):
	global_position += velocity.rotated(rotation) * delta
	if !alive:
		die()


func _on_EnemyProjectile_area_entered(area):
	area.get_parent().health -= damage
	alive = false


func die():
	var explosion_ins = explosion.instance()
	explosion_ins.global_position = global_position
	explosion_ins.rotation = rotation
	get_parent().add_child(explosion_ins)
	
	trail.set_emitting(false)
	self.remove_child(trail)
	get_parent().add_child(trail)
	trail.global_position = global_position
	
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	alive = false
