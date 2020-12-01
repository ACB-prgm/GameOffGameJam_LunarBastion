extends CanvasLayer

onready var fadeInTween = $FadeInTween
onready var fadeOutTween = $FadeOutTween
onready var fadeInRect = $FadeInRect
onready var fadeOutRect = $FadeOutRect
var new_level = null
var tree = null


func fade_in():
	fadeInRect.set_visible(true)
	fadeInTween.interpolate_property(fadeInRect, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.5, 
	Tween.TRANS_CUBIC, Tween.EASE_IN)
	fadeInTween.start()

func fade_out(scene_tree=null, level=null):
	new_level = level
	tree = scene_tree
	fadeOutRect.set_visible(true)
	fadeOutTween.interpolate_property(fadeOutRect, 'modulate', Color(1,1,1,0), Color(1,1,1,1), 0.5, 
	Tween.TRANS_CUBIC, Tween.EASE_OUT)
	fadeOutTween.start()
	if Globals.camera:
		Globals.camera.shake(50, .6)


func _on_FadeInTween_tween_all_completed():
	fadeInRect.set_modulate(Color(1,1,1,1))
	fadeInRect.set_visible(false)


func _on_FadeOutTween_tween_all_completed():
		if new_level:
			tree.change_scene(new_level)
			new_level = null
			tree = null
		fadeOutRect.set_modulate(Color(1,1,1,0))
		fadeOutRect.set_visible(false)
