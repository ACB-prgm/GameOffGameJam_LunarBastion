extends Node2D


var explosion = preload("res://Scenes/Characters/Ordnance/100mmShell/100mmShellAOE.tscn")
var target_position = Vector2(0,150)
var downward_velocity = Vector2(0, 850)
var shell_type = '100mm Shell'


func _ready():
	if Items.items.get(shell_type).get('texture'):
		$Sprite.set_texture(load(Items.items.get(shell_type).get('texture')))
		explosion = load(Items.items.get(shell_type).get('explosion_scene'))

func _physics_process(delta):
	if global_position.y - target_position.y < 0:
		global_position += downward_velocity.rotated(rotation) * delta
	else:
		die()

func die():
	var explosion_ins = explosion.instance()
	explosion_ins.set_scale(scale)
	explosion_ins.shell_type = shell_type
	get_parent().add_child(explosion_ins)
	explosion_ins.global_position = target_position
	queue_free()
