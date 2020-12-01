extends Area2D


export var damage = 1

var alienBloodSpurt_Effect = preload("res://Scenes/Effects/AlienBlooodSpurt/AlienBloodSpurt.tscn")
var velocity = Vector2(600, 0)
var alive = true


func _physics_process(delta):
	if !alive:
		die()
	global_position += velocity.rotated(rotation) * delta

func _on_VisibilityNotifier2D_screen_exited():
	alive = false

func _on_Bullet_area_entered(_area):
	alive = false

func _on_Bullet_body_entered(_body):
	alive = false

func die():
	queue_free()
