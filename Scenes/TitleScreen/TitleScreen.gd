extends Control


onready var animTween = $AnimTween
onready var titleLabel = $TitleLabel
onready var timeToBeat = $TimeToBeatLabel
onready var playButton = $PlayButton

var displayed_timetobeat = false
var timer_yielding = false
var queued = null


func _ready():
	Globals.save_data()
	Items.load_backup()
	Globals.enemy_health_multiplyer = 1
	
	animTween.interpolate_property(titleLabel, 'modulate', Color(1,1,1,0),
	Color(1,1,1,1), 1.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	animTween.interpolate_property(titleLabel, 'rect_position', 
	titleLabel.rect_position - Vector2(0, 20), titleLabel.rect_position, 1.2, 
	Tween.TRANS_SINE, Tween.EASE_OUT)
	
	animTween.start()

func _on_AnimTween_tween_all_completed():
	if !displayed_timetobeat and Globals.highsore > 0:
		displayed_timetobeat = true
		timeToBeat.set_text('time to beat:\n%s' % [Globals.highsore])
		
		animTween.interpolate_property(timeToBeat, 'modulate', Color(1,1,1,0), 
		Color(1,1,1,1), 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0.5)
		animTween.start()


func _on_PlayButton_pressed():
	if !timer_yielding:
		Transitioner.fade_out(self.get_tree(), "res://Scenes/MainLevel/Main.tscn")
	else:
		queued = "res://Scenes/MainLevel/Main.tscn"

func _on_YSort_timer_yielding(boolean):
	timer_yielding = boolean
	
	if !timer_yielding and queued:
		Transitioner.fade_out(self.get_tree(), queued)

