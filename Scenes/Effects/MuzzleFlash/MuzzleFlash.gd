extends Node2D


onready var rightFlash = $RightMuzzleFlash
onready var leftFlash = $LeftMuzzleFlash
onready var frontFlash = $FrontMuzzleFlash
onready var animatedFlash = $AnimatedFlash

signal muzzle_Flash_Finished

func play_muzzle_flash():
	animatedFlash.set_frame(0)
	animatedFlash.play()
	
	rightFlash.restart()
	leftFlash.restart()
	frontFlash.restart()
	
	rightFlash.set_emitting(true)
	leftFlash.set_emitting(true)
	frontFlash.set_emitting(true)


func _on_AnimatedFlash_animation_finished():
	emit_signal("muzzle_Flash_Finished")
