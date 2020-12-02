extends Area2D


onready var aOE = $AOECollisionShape
onready var impactSprite = $ImpactSprite
onready var charSprite = $CharSprite
onready var impactSpriteTween = $ImpactSpriteTween

var shake_amount = 50
var fade_complete = false
var ordnance = true
var shell_type = '100mm Shell'
var damage = 5
var radius = 20


func _ready():
	# Loads shell damage and radius
	if ordnance:
		var shellType_info = Items.items.get(shell_type)
		damage = shellType_info.get('damage')
		radius = shellType_info.get('radius')
	
	aOE.shape.set_radius(radius)
	
	# Shell effects
	randomize()
	if rand_range(0.0, 10.0) > 5.0:
		charSprite.set_flip_h(true)
	
	if Globals.camera:
		Globals.camera.shake(shake_amount)
	$ShockwaveAnimatedSprite.play()
	$DustParticles2D2.set_emitting(true)
	$DustParticles2D.set_emitting(true)
	
	impactSpriteTween.interpolate_property(impactSprite, 'modulate', Color(1.25,1.05,1,1), 
	Color(1,1,1,0), .18, Tween.TRANS_ELASTIC, Tween.EASE_IN)
	impactSpriteTween.interpolate_property(impactSprite, 'scale', Vector2(2,2), 
	Vector2(.5,.5), .18, Tween.TRANS_ELASTIC, Tween.EASE_IN)
	
	impactSpriteTween.start()
	
	Music.explodeSound.pitch_scale = 0.1 + rand_range(-0.02, 0.02)
	Music.explodeSound.play()

func _on_CollisionTimer_timeout():
	set_deferred('monitorable', false)


func _on_DeathTimer_timeout():
	impactSpriteTween.interpolate_property(charSprite, 'modulate', Color(1,1,1,0.8), 
	Color(1,1,1,0), 3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	impactSpriteTween.start()

func _on_ImpactSpriteTween_tween_all_completed():
	if !fade_complete:
		fade_complete = true
		pass
	else:
		queue_free()
