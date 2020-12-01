extends Sprite

onready var turret_parent = get_parent()
onready var spriteFlash = $SpriteFlash
onready var spriteFlashTween = $SpriteFlashTween

var current_look_direction = Vector2.RIGHT


func _ready():
	spriteFlash.set_modulate(Color(1,1,1,0))


func _physics_process(_delta):
	look_animation_handling()


func look_animation_handling():
	#DOWN
	if current_look_direction.angle() > 0.785398 and current_look_direction.angle() < 2.35619:
		set_frame(2)
		spriteFlash.set_frame(2)
		scale.y = -1
		turret_parent.flip_shell_effect = false
	#RIGHT
	elif current_look_direction.angle() > 0 and current_look_direction.angle() < PI/4 or current_look_direction.angle() < 0 and current_look_direction.angle() > -PI/4:
		set_frame(0)
		spriteFlash.set_frame(0)
		scale.y = 1
		turret_parent.flip_shell_effect = true
	#UP
	elif current_look_direction.angle() < -0.785398 and current_look_direction.angle() > -2.35619:
		set_frame(1)
		spriteFlash.set_frame(1)
		scale.y = 1
		turret_parent.flip_shell_effect = true
	#LEFT
	else:
		set_frame(3)
		spriteFlash.set_frame(3)
		scale.y = -1
		turret_parent.flip_shell_effect = false

func flash_sprite():
	spriteFlashTween.interpolate_property(spriteFlash, 'modulate', 
	Color(1.6,1.4,1.2,1), Color(1,1,1,0), .18, Tween.TRANS_BOUNCE, Tween.EASE_IN
	)
	spriteFlashTween.start()
