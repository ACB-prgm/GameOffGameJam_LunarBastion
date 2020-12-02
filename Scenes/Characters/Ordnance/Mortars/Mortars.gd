extends Node2D


onready var timer = $Timer

var shell = preload("res://Scenes/Characters/Ordnance/100mmShell/100mmShell.tscn")
var target_position = Vector2(100,150)
var Y = target_position.y + 20 #total height
var mortar_count = 0
var radius = Items.items.get('mortars').get('radius')
var spawn_zone = Vector2(radius, radius * 0.75)
var mortars_spawned = false
var read_to_die = false
var num_mortars = 7
var shell_type # only exists to avoid error from sloppy code


func _ready():
	randomize()
	$DamageArea2D.damage = Items.items.get('mortars').get('total damage')
	$DamageArea2D/CollisionShape2D.shape.radius = radius

func _on_Timer_timeout():
	if mortar_count <= num_mortars:
		spawn_Shell()
		mortar_count += 1
	elif mortars_spawned:
		$DamageArea2D.global_position = target_position
		read_to_die = true
		mortars_spawned = false
	elif read_to_die:
		queue_free()
	else:
		mortars_spawned = true

func spawn_Shell():
	Music.dropWhistleSound.play()
	var individual_target_position = target_position + Vector2(rand_range(-spawn_zone.x, spawn_zone.x),rand_range(-spawn_zone.y, spawn_zone.y))
	var new_shell = shell.instance()
	new_shell.rotation += deg2rad(45)
	new_shell.target_position = individual_target_position
	new_shell.shell_type = 'mortars'
	new_shell.set_scale(Vector2(.5, .5))
	get_parent().add_child(new_shell)
	new_shell.global_position = Vector2(individual_target_position.x + Y, 0)




