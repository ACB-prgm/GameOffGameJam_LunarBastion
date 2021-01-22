extends Sprite

var speed = 100
var steer_force = 200.0
var damage = 1

var velocity = Vector2(0,-350)
var acceleration = Vector2.ZERO
var target = null
var splash_radius = null
var explosionTSCN = preload("res://Scenes/Characters/Ordnance/100mmShell/100mmShellAOE.tscn")
var alive = true

onready var trail = $Particles2D


func seek():
	var steer = Vector2.ZERO
	if is_instance_valid(target):
		var desired = (target.global_position - global_position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
#	if target and global_position.distance_to(target.global_position) < 2:
#		alive = false
	if !alive:
		die()
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	global_position += velocity * delta

func die():
	trail.set_emitting(false)
	self.remove_child(trail)
	get_parent().add_child(trail)
	trail.global_position = global_position
	
	var ins_explosion = explosionTSCN.instance()
	ins_explosion.radius = splash_radius
	ins_explosion.scale = Vector2(.25, .25)
	ins_explosion.shake_amount = 5
	ins_explosion.damage = damage
	ins_explosion.ordnance = false
	get_parent().add_child(ins_explosion)
	ins_explosion.global_position = self.global_position
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	alive = false


func _on_KillArea2D_area_entered(_area):
	alive = false
