extends Control


onready var blockingColorRect = $BlockingColorRect
onready var startTween = $StartTween
onready var godotSprite = $Control/GodotAnimatedSprite
onready var tween = $Tween
onready var godotTXT = $Control/Godot
onready var lightFlikceringSound = $LightFlickeringSound

var count = 0


func _ready():
	blockingColorRect.show()
	godotTXT.set_modulate(Color(1,1,1,0))

func _physics_process(_delta):
	if count >= 3:
		set_physics_process(false)
		startTween.interpolate_property(blockingColorRect, 'modulate', Color(1,1,1,1), 
		Color(1,1,1,0), 0.3, Tween.TRANS_QUART, Tween.EASE_IN)
		startTween.start()

	if ParticlesCache.loaded:
		count += 1


func _on_StartTween_tween_all_completed():
	lightFlikceringSound.play()
	
	yield(get_tree().create_timer(0.15), "timeout")
	
	tween.interpolate_property(godotTXT, 'modulate', Color(1,1,1,0), Color(1,1,1,1),
	 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()
	godotSprite.play()
	

func _on_GodotAnimatedSprite_animation_finished():
	Globals.camera.shake(100, .3)
	$ChangeSceneTimer.start()

func _on_ChangeSceneTimer_timeout():
	Transitioner.fade_out(self.get_tree(), "res://Scenes/TitleScreen/TitleScreen.tscn")
