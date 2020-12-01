extends KinematicBody2D


export var speed = 30
export var health = 3.0
export var damage = 1.0
export var attack_rate = 2.0

onready var base = Globals.Base
onready var animationTree = $AnimationTree
onready var attackRateTimer = $AttackRateTimer
onready var damagedTween = $DamagedTween

var alienBloodSpurtTSCN = preload("res://Scenes/Effects/AlienBlooodSpurt/AlienBloodSpurt.tscn")
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var damaged_color = Color(2,2,2,.5)
var tear_gassed = false
var target = null
var target_detected = false


func _ready():
	health *= Globals.enemy_health_multiplyer
	randomize()
	
	attackRateTimer.set_wait_time(attack_rate)
	
	if base:
		target = base

func _physics_process(delta):
	movement(delta)
	if health <= 0:
		die()

func movement(delta):
	if target:
		direction = self.global_position.direction_to(target.global_position)
		if !target_detected:
			velocity += direction * speed * delta
		else: # target detected
			velocity = velocity.move_toward(Vector2.ZERO, speed * delta)
		velocity = velocity.clamped(speed)
	else:
		if base:
			target = base
			target_detected = false
		velocity = Vector2.ZERO
	
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	animationTree.set('parameters/Walking/blend_position', direction)

func _on_Hurtbox_area_entered(area):
	if area.get_parent() != base:
		var INS_alienBloodSpurt = alienBloodSpurtTSCN.instance()
		get_parent().add_child(INS_alienBloodSpurt)
		INS_alienBloodSpurt.rotation = area.rotation + PI
		INS_alienBloodSpurt.global_position = global_position
		
		var return_color = Color(1,1,1,1)
		if tear_gassed:
			return_color = Color(0.75, 1, .6, 1)
		damagedTween.interpolate_property(self, 'modulate', damaged_color, return_color, 
		.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
		damagedTween.start()
		
		health -= area.damage

func die():
	queue_free()

func _on_DetectionArea_area_entered(area):
	if area.get_parent() == base:
		target_detected = true
		attackRateTimer.start()
	elif rand_range(0,10) > 5:
		target = area.get_parent()
		target_detected = true
		attackRateTimer.start()

func _on_AttackRateTimer_timeout():
	# deal damage
	attack()

func attack():
	if target:
		target.health -= self.damage
