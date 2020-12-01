extends Node2D


onready var cast = $Raycast2D
onready var line2D = $Line2D
onready var tween = $Tween
onready var target = cast.get_cast_to()

var damage = 3
var check = false



func _physics_process(_delta):
	if !check:
		check = true
		if cast.is_colliding():
			target = cast.get_collider().get_parent()
			target._on_Hurtbox_area_entered(self)
			target = target.global_position
	
		line2D.points = PoolVector2Array([Vector2.ZERO, Vector2(global_position.distance_to(target), 0)])
		
		tween.interpolate_property(self, 'modulate', modulate, Color(1,1,1,0),
		 .2, Tween.TRANS_QUAD, Tween.EASE_OUT, .1)
		tween.start()
		
		set_physics_process(false)


func _on_Tween_tween_all_completed():
	queue_free()
