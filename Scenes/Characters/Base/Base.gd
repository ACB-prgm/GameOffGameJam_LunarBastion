extends StaticBody2D


export var health = 100

onready var max_health = health
onready var healthBar = $HealthBarTextureProgress
onready var antennaLight = $AntennaLight
onready var antennaTween = $AntennaTween
onready var drillTween = $DrillTween
onready var drill = $Drill

var drill_loc = true
var drill_down = Vector2(29, -8)
var drill_up = Vector2(29, -25)
var glow = false
var max_glow = Color(4,1.5,1,1)
var min_glow = Color(3,1.2,1,1)
var alive = true

signal base_died()


func _ready():
	Globals.Base = self
	_on_AntennaTween_tween_all_completed()
	_on_DrillTween_tween_all_completed()

func _physics_process(_delta):
	health_bar()
	if health <= 0 and alive:
		alive = false
		die()

func upgrade_health(increment):
	max_health *= increment
	health *= increment

func die():
	emit_signal("base_died")
	queue_free()


func _on_AntennaTween_tween_all_completed():
	match glow:
		true:
			glow = false
			antennaTween.interpolate_property(antennaLight, 'modulate', max_glow, 
			min_glow, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		false:
			glow = true
			antennaTween.interpolate_property(antennaLight, 'modulate', min_glow, 
			max_glow, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, .5)
	
	antennaTween.start()


func _on_DrillTween_tween_all_completed():
	match drill_loc:
		true:
			drill_loc = false
			drillTween.interpolate_property(drill, 'position', drill_up, 
			drill_down, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 3)
		false:
			$Drill/DrillParticles2D.start()
			Globals.camera.shake(15)
			drill_loc = true
			drillTween.interpolate_property(drill, 'position', drill.position, 
			drill_up, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 3)
	
	drillTween.start()

func health_bar():
	if health < max_health:
		healthBar.show()
	else:
		healthBar.hide()

	healthBar.value = health/max_health * 100


# UPGRADE ———————————————————————————————————————————
signal upgrade_base_selected()
signal upgrade_base_deselected()

const glow_color = Color(1.3,1.3,1.3,1)
var base_pressed = false


func _on_BaseButton_mouse_entered():
	if Globals.upgrade_mode:
		$BaseBack.set_modulate(glow_color)
		$BaseSprite.set_modulate(glow_color)
		$Drill/Drill.set_modulate(Color(1.5,1.5,1.5,1))

func _on_BaseButton_mouse_exited():
	if Globals.upgrade_mode:
		if !base_pressed:
			$BaseBack.set_modulate(Color(1,1,1,1))
			$BaseSprite.set_modulate(Color(1,1,1,1))
			$Drill/Drill.set_modulate(Color(1,1,1,1))

func _on_BaseButton_toggled(button_pressed):
	if Globals.upgrade_mode:
		if button_pressed:
			base_pressed = true
			$BaseBack.set_modulate(glow_color)
			$BaseSprite.set_modulate(glow_color)
			$Drill/Drill.set_modulate(Color(1.5,1.5,1.5,1))
			emit_signal("upgrade_base_selected")
		else:
			upgrade_deselect()
			emit_signal("upgrade_base_deselected")

func upgrade_deselect():
	$Control/BaseButton.set_pressed(false)
	
	base_pressed = false
	$BaseBack.set_modulate(Color(1,1,1,1))
	$BaseSprite.set_modulate(Color(1,1,1,1))
	$Drill/Drill.set_modulate(Color(1,1,1,1))
