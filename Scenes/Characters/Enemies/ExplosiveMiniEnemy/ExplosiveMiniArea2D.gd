extends Area2D


onready var explosionAnimation = $ExplosionAnimatedSprite
onready var particles = $Particles2D

var count = 0
var damage = 1.5


func _ready():
	explosionAnimation.play()
	particles.set_emitting(true)

func _physics_process(_delta):
	if count >= 1:
		damage_()
		$CollisionShape2D.set_deferred('disabled', true)
		set_physics_process(false)
	count += 1

func damage_():
	var targets = get_overlapping_bodies()
	for target in targets:
		if target:
			target.health -= damage

func _on_DeathTimer_timeout():
	queue_free()
