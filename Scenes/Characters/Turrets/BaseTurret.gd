extends StaticBody2D


signal turret_died()

export var health = 10
export var damage = 1.0
export var fire_rate = 0.6
export var weapon_range = 100.0
export var swivel_speed = 6
var level = 1
var splash_radius = null
var turret_type = null

var DEFAULT_look_direction = Vector2.ZERO
var target = null
var target_killed_check = true
var can_shoot = true
var current_look_direction
var pivot_return_flag = true
var pivot_flag = true
var flip_shell_effect = false
var alive = true
var bullet = preload("res://Scenes/Characters/Turrets/Bullets/BaseBullet.tscn")
var bulletShellEffect = preload("res://Scenes/Effects/BulletShellEffect/BulletShellEffect.tscn")
var head_sprite = preload("res://Sprites/Turrets/BaseTurret/BaseTurretHEAD.png")
var head_flash = preload("res://Sprites/Turrets/BaseTurret/BaseTurretFLASH_MAIN.png")

onready var head = $Head
onready var shootTimer = $ShootTimer
onready var barrelPosition = $Head/BarrelPosition
onready var muzzleFlash = $Head/BarrelPosition/MuzzleFlash
onready var shellEjectionPosition = $Head/ShellEjectionPosition
onready var range_ = $Range
onready var range_collisionShape = $Range/CollisionShape2D
onready var healthBar = $HealthBarProgress
onready var base = Globals.Base
onready var max_health = health


func _ready():
	if Globals.Base:
		DEFAULT_look_direction = (base.global_position.direction_to(self.global_position))
	set_variables()
	Music.groundHitSOund.pitch_scale = 0.8 + rand_range(-0.05, 0.05)
	Music.groundHitSOund.play()
	$LandingDustEffect.play_Anim()

func set_variables():
	shootTimer.set_wait_time(fire_rate)
	var range_shape = CircleShape2D.new()
	range_shape.set_radius(weapon_range)
	range_collisionShape.set_shape(range_shape)
	head.set_texture(head_sprite)
	$Head/SpriteFlash.set_texture(head_flash)
	max_health = float(health)

func _physics_process(delta):
	health_bar()
	aim(delta)
	if health <= 0 and alive:
		alive = false
		die()


func aim(delta):
	current_look_direction = Vector2.RIGHT.rotated(head.rotation).normalized()
	head.current_look_direction = self.current_look_direction
	
	if target:
		head.rotation = lerp_angle(head.rotation,
		 (target.global_position - head.global_position).normalized().angle(), swivel_speed * delta)
#		head.look_at(get_global_mouse_position()) # FOR TESTING
		target_killed_check = true
		
		if abs(current_look_direction.angle_to(self.global_position.direction_to(target.global_position))) < 0.16 or self.global_position.distance_to(target.global_position) < 20:
			head.look_at(target.global_position)
			shoot()
		
	else: #SURVEYING
		#RIGHT
		if abs(current_look_direction.angle_to(DEFAULT_look_direction.rotated(PI/2.0))) > 0.01 and pivot_flag:
			head.rotate(delta/2)
			pivot_flag = true
			pivot_return_flag = true
		#LEFT
		elif abs(current_look_direction.angle_to(DEFAULT_look_direction.rotated(-PI/2.0))) > 0.01 and !pivot_flag:
			head.rotate(-delta/2)
			pivot_flag = false
			pivot_return_flag = true
		#RETURNING
		else:
			if pivot_return_flag:
				pivot_return_flag = false
				if pivot_flag:
					pivot_flag = false
				else:
					 pivot_flag = true
			head.rotate(delta/2)
	
		if target_killed_check: # checks for targets in range after target == null
			target_killed_check = false
			if range_.get_overlapping_bodies():
				target = range_.get_overlapping_bodies()[0]


func shoot():
	if target and can_shoot:
#		shootsound.pitch_scale = 1 + rand_range(-0.05, 0.05)
#		shootsound.play()
		can_shoot = false
		shootTimer.start()
		
		head.flash_sprite()
		$Legs/Shadow.flash_shadow()
		muzzleFlash.play_muzzle_flash()
		
		var shellEjection = bulletShellEffect.instance()
		var bullet_instance = bullet.instance()
		if splash_radius:
			bullet_instance.splash_radius = splash_radius
			bullet_instance.target = target
		else:
			bullet_instance.rotation = head.rotation
		get_parent().add_child(bullet_instance)
		get_parent().add_child(shellEjection)
		if flip_shell_effect:
			shellEjection.scale.x = abs(shellEjection.scale.x) * -1
		bullet_instance.damage = self.damage
		shellEjection.global_position = shellEjectionPosition.global_position
		bullet_instance.global_position = barrelPosition.global_position

func health_bar():
	if health < max_health:
		healthBar.show()
	else:
		healthBar.hide()
	healthBar.value = health/float(max_health) * 100

func _on_Range_body_entered(body):
	if !target:
		target = body

func _on_Range_body_exited(body):
	if target:
		if body == target:
			target = null

func _on_ShootTimer_timeout():
	can_shoot = true

func die():
	emit_signal("turret_died")
	queue_free()


# UPGRADE MODE ——————————————————————————
const glow_color = Color(1.3,1.3,1.3,1)
var upgrade_pressed = false
signal turret_upgrade_selected(turret_node)
signal turret_upgrade_deselected()

func _on_Button_mouse_entered():
	if Globals.upgrade_mode:
		set_modulate(glow_color)

func _on_Button_mouse_exited():
	if Globals.upgrade_mode:
		if !upgrade_pressed:
			set_modulate(Color(1,1,1,1))

func _on_Button_toggled(button_pressed):
	if Globals.upgrade_mode:
		if button_pressed:
			emit_signal("turret_upgrade_selected", self)
			upgrade_pressed = true
			set_modulate(glow_color)
		else:
			emit_signal("turret_upgrade_deselected")
			upgrade_deselect()

func upgrade_deselect():
	$UpgradeButton.set_pressed(false)
	upgrade_pressed = false
	set_modulate(Color(1,1,1,1))
