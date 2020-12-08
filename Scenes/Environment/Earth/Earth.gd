extends Node2D


onready var gun = $Gun
onready var gunFlash = $GunFlash
onready var flashTween = $FlashTween
onready var movementTween = $MovementTween
onready var start_pos = global_position


func _ready():
	gunFlash.set_modulate(Color(1,1,1,0))

func shoot():
	gun.set_frame(0)
	gun.play()
	gunFlash.set_frame(0)
	gunFlash.play()

func _on_Gun_frame_changed():
	if gun.frame == 1:
		$MuzzleFlash.restart()
		$MuzzleFlash.set_emitting(true)
		flash_Sprite()
		global_position += Vector2(2,2)
		movementTween.interpolate_property(self, 'global_position', global_position, start_pos, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		movementTween.start()
		if Globals.camera:
			Globals.camera.shake(25)

func flash_Sprite():
	flashTween.interpolate_property(gunFlash, 'modulate', 
	Color(1.2,1.1,1,1), Color(1,1,1,0), .37, Tween.TRANS_BOUNCE, Tween.EASE_IN
	)
	flashTween.start()
