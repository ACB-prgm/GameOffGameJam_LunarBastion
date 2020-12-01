extends "res://Scenes/Characters/Enemies/BaseEnemy.gd"


export var explosive = false

var explosion_TSCN = preload("res://Scenes/Characters/Enemies/ExplosiveMiniEnemy/ExplosiveMiniArea2D.tscn")


func _ready():
	randomize()
	if rand_range(0, 10) <= 1:
		explosive = true
	
	if explosive:
		$Sprite.set_modulate(Color(1, .55, .55, 1))

func attack():
	if target:
		if !explosive: #NORMAL
			target.health -= self.damage
		else: #EXPLOSIVE
			die()

func die():
	if explosive:
		var explosion = explosion_TSCN.instance()
		explosion.global_position = global_position
		get_parent().add_child(explosion)
	queue_free()
