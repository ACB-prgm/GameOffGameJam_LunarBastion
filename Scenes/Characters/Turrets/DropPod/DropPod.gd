extends Node2D

var target_position = Vector2(0,150)
var downward_velocity = 600
var baseTurretTSCN = preload("res://Scenes/Characters/Turrets/BaseTurret.tscn")
var item = 'machine gun'
var info = Items.items
var scaler = Vector2(1,1)
var HUD_scene_node = null

onready var baseTurret_ins = baseTurretTSCN.instance()
onready var trail = $SmokeTrailParticles2D
onready var dropSound = Music.dropWhistleSound


func _ready():
	info = info.get(item)
	
	baseTurret_ins.set_scale(scaler)
	baseTurret_ins.health = info.get('health')
	baseTurret_ins.damage = info.get('damage')
	baseTurret_ins.fire_rate = info.get('fire rate')
	baseTurret_ins.weapon_range = info.get('range')
	baseTurret_ins.swivel_speed = info.get('swivel speed')
	if info.get('splash radius'):
		baseTurret_ins.splash_radius = info.get('splash radius')
	
	baseTurret_ins.bullet = load(info.get('bullet'))
	baseTurret_ins.head_sprite = load(info.get('sprite_head'))
	baseTurret_ins.head_flash = load(info.get('sprite_flash'))
	
	baseTurret_ins.turret_type = item
	if HUD_scene_node:
		baseTurret_ins.connect('turret_upgrade_selected', HUD_scene_node, 'on_turret_upgrade_selected')
		baseTurret_ins.connect('turret_upgrade_deselected', HUD_scene_node, '_on_turret_upgrade_deselected')
		baseTurret_ins.connect('turret_died', HUD_scene_node, '_on_turret_died')

func _physics_process(delta):
	if global_position.y - target_position.y < 0:
		global_position.y += downward_velocity * delta
	else:
		die()

func die():
	trail.set_emitting(false)
	self.remove_child(trail)
	get_parent().add_child(trail)
	trail.global_position = global_position
	
	get_parent().add_child(baseTurret_ins)
	baseTurret_ins.global_position = target_position
	queue_free()
