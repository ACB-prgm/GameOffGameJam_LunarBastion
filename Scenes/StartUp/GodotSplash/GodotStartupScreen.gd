extends Node2D


onready var godotSprite = $GodotAnimatedSprite
onready var tween = $Tween
onready var godotTXT = $Control/Godot
onready var lightFlikceringSound = $LightFlickeringSound


func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	
	tween.interpolate_property(godotTXT, 'modulate', Color(1,1,1,0), Color(1,1,1,1),
	 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()
	
	lightFlikceringSound.play()

func _on_AnimationPlayTimer_timeout():
	godotSprite.play()

func _on_GodotAnimatedSprite_animation_finished():
	Globals.camera.shake(100, .3)
	$ChangeSceneTimer.start()

func _on_ChangeSceneTimer_timeout():
	Transitioner.fade_out(self.get_tree(), "res://Scenes/TitleScreen/TitleScreen.tscn")
