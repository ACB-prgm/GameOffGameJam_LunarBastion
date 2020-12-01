extends Node2D


onready var ysort = $YSort
onready var spawn_timer = $SpawnTimer

var viewport_y = Globals.viewport_y
var viewport_x = Globals.viewport_x
var new_item = null
var dropPod = preload("res://Scenes/Characters/Turrets/DropPod/DropPod.tscn")
var base_enemy = preload("res://Scenes/Characters/Enemies/BaseEnemy.tscn")
var mini_enemy = preload("res://Scenes/Characters/Enemies/MiniEnemy.tscn")
var tank_enemy = preload("res://Scenes/Characters/Enemies/TankEnemy/TankEnemy.tscn")
var current_mode = null
var target_position = null
var item_to_spawn = null

var start_easing = true
var inc_spawnrate_threshold = 20
var wait_time_subtraction = 0.2
var inc_enemyhealth_threshold = 3
var count = 0
var major_count = 0

var enimies = {
	'base' : base_enemy,
	'mini' : mini_enemy,
	'tank' : tank_enemy
	}


func _ready():
	randomize()
	Transitioner.fade_in()

func _on_Base_base_died():
	Transitioner.fade_out(self.get_tree(), "res://Scenes/TitleScreen/TitleScreen.tscn")

func spawn_enemies(num_enemies=1, type='mini', location=null):
	for _enemy in range(num_enemies):
		var enemy = enimies[type].instance()
		ysort.add_child(enemy)
		if location:
			enemy.global_position = location
		else:
			enemy.global_position = random_spawn_loc()

func random_spawn_loc(): # randomly generates a Vector2 outside the viewport
	var X = 0
	var Y = 0
	var flip = rand_range(0.0,7.0)

	if flip <= 4.0: #VERITCAL
		Y = rand_range(0 + 100, viewport_y + 8) 
		if flip < 2.0: #RIGHT
			X = rand_range(viewport_x + 8, viewport_x + 24)
		else: #LEFT
			X = rand_range(-24.0, -8.0)
	else: #HORIZONTAL
		X = rand_range(0 - 8, viewport_x + 8) 
		Y = rand_range(viewport_y + 8, viewport_y + 24)
	return Vector2(X,Y)

func _on_SpawnTimer_timeout():
	count += 1
	spawn_enemies(2)
	
	if start_easing and count == 10:
		count = 1
		start_easing = false
	
	if !start_easing:
		if count % 3 == 0:
			spawn_enemies(1, 'base')
		
		if count % 10 == 0:
			spawn_enemies(1, 'tank')
		
		if count % inc_spawnrate_threshold == 0 and spawn_timer.wait_time > 0.6:
			inc_spawnrate_threshold += 20
			count = 1
			major_count += 1
			
			spawn_timer.set_wait_time(spawn_timer.wait_time - wait_time_subtraction)
			if spawn_timer.wait_time < 0.6:
				spawn_timer.set_wait_time(0.6)
			
			if major_count % inc_enemyhealth_threshold == 0 and Globals.enemy_health_multiplyer < 2:
				if inc_enemyhealth_threshold > 1:
					inc_enemyhealth_threshold -= 1
				Globals.enemy_health_multiplyer += 0.25


func _on_HUD_item_launched(_cost, selected_position, mode, item):
	$BackgroundCanvasLayer/Earth.shoot()
	$ShootAnimTimer.start()
	current_mode = mode
	target_position = selected_position
	item_to_spawn = item

func _on_ShootAnimTimer_timeout():
	match current_mode:
		1: # ORDNANCE MODE
			var ordnance = load(Items.items.get(item_to_spawn).get('scene'))
			new_item = ordnance.instance()
			new_item.shell_type = item_to_spawn
		2: # TURRETS MODE
			new_item = dropPod.instance()
			new_item.HUD_scene_node = $HUDCanvasLayer/HUD
			new_item.item = item_to_spawn
	
	new_item.target_position = target_position
	ysort.add_child(new_item)
	new_item.global_position = Vector2(target_position.x, -20)


func _on_HUD_upgrade_launched(upgrade, _cost, mode, turret_node):
	current_mode = mode
	target_position = null
	
	var upgrade_info = Items.upgrades.get(upgrade)
	
	if upgrade_info.get('type') == 'base': # BASE UPGRADE
		if upgrade_info.has('items'):
			for item in upgrade_info.get('items'):
				var item_info = Items.items.get(item)
				item_info[upgrade_info.get('stat')] = stepify(item_info.get(upgrade_info.get('stat')) * upgrade_info.get('increment'), 0.5)
				if item_info.has('total damage'):
					item_info['total damage'] = stepify(item_info.get('total damage') * upgrade_info.get('increment'), 0.5)
		elif upgrade == 'fortification':
			Globals.Base.upgrade_health(upgrade_info.get('increment'))
		elif upgrade == 'reinforced':
			$HUDCanvasLayer/HUD.upgrade_turret_limit(upgrade_info.get('increment'))
		else: # 'better boring'
			Globals.moontoniumCounter.change_moontonium_rate(upgrade_info.get('increment'))
		
		# increase upgrade cost
		upgrade_info['cost'] = floor(upgrade_info.get('cost') * 1.5)
	
	else: # TURRET UPGRADE
		upgrade_info = upgrade_info.get(str(turret_node.level))
		for stat in upgrade_info.get('stats'):
			turret_node.set(stat, upgrade_info.get('stats').get(stat))
		turret_node.set_variables()
		
		turret_node.level += 1



