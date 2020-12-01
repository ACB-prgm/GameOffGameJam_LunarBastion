extends YSort


onready var timer = $Timer
onready var earth = get_parent().get_node("BackgroundCanvasLayer/Earth")
onready var enemies = [base_enemy, mini_enemy]

var base_enemy = preload("res://Scenes/Characters/Enemies/BaseEnemy.tscn")
var mini_enemy = preload("res://Scenes/Characters/Enemies/MiniEnemy.tscn")
var dropPod = preload("res://Scenes/Characters/Turrets/DropPod/DropPod.tscn")
var ordnance = load(Items.items.get('100mm Shell').get('scene'))
var turrets_spawned = false
var turret_choices = ['machine gun', 'sniper', 'shotgun', 'rocket launcher',]
var play_pressed = false

signal timer_yielding(boolean)


func _ready():
	randomize()

func _on_Timer_timeout():
	
	if turrets_spawned:
		timer.start()
		spawn_enemy()
		spawn_ordinance()
	else:
		turrets_spawned = true
		
		earth.shoot()
		if !play_pressed:
			emit_signal("timer_yielding", true)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("timer_yielding", false)
			spawn_random_turret(Vector2(100, 175)) #LEFT
		
		earth.shoot()
		if !play_pressed:
			emit_signal("timer_yielding", true)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("timer_yielding", false)
			spawn_random_turret(Vector2(380, 175)) #RIGHT
		
		timer.set_wait_time(4)
		timer.start()

func spawn_random_turret(selected_position):
	var item = turret_choices[randi() % turret_choices.size()]
	var turret = dropPod.instance()
	turret.item = item
	turret.target_position = selected_position
	turret.set_scale(Vector2(1.5,1.5))
	turret.scaler = Vector2(1.5,1.5)
	add_child(turret)
	turret.global_position = Vector2(selected_position.x, -20)

func spawn_enemy():
	var enemy = enemies[randi() % enemies.size()].instance()
	enemy.set_scale(Vector2(1.5,1.5))
	add_child(enemy)
	enemy.global_position = Vector2(rand_range(0,Globals.viewport_x), Globals.viewport_y + 20)

func spawn_ordinance():
	earth.shoot()
	emit_signal("timer_yielding", true)
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("timer_yielding", false)
	
	var target_position = Vector2(Globals.viewport_x/2.0, 160)
	var new_shell = ordnance.instance()
	if rand_range(0,10) > 4:
		target_position = Vector2(rand_range(70, 400), rand_range(215, 250))
	new_shell.target_position = target_position
	new_shell.set_scale(Vector2(1.5,1.5))
	add_child(new_shell)
	new_shell.global_position = Vector2(target_position.x, -20)


func _on_PlayButton_pressed():
	play_pressed = true
