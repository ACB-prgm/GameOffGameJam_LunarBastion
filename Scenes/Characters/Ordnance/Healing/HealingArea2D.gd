extends Area2D


onready var sprite = $Sprite
onready var tween = $Tween
onready var duration = Items.items.get(shell_type).get('duration')
onready var radius = Items.items.get(shell_type).get('radius')
onready var heal_amount = Items.items.get(shell_type).get('health/second')

var level_1_radius = Items.items.get('health kit').get('radius')
var shell_type = 'health kit'
var turrets_to_heal = []
var ready_to_die = false


func _ready():
	$CollisionShape2D.shape.set_radius(level_1_radius)
	self.scale *= radius/float(level_1_radius)
	$Timer.set_wait_time(duration)
	$Timer.start()
	tween.interpolate_property(sprite, 'scale', Vector2.ZERO, sprite.scale, .3,
	 Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()

func _on_Timer_timeout():
	tween.interpolate_property(self, 'modulate', self.modulate, Color(1,1,1,0), 1,
	 Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', self.scale, self.scale/2.0, 1,
	 Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	if ready_to_die:
		queue_free()
	else:
		turrets_to_heal = get_overlapping_areas()
	ready_to_die = true


func _on_HealTimer_timeout():
	for area in turrets_to_heal:
		if area != null:
			var turret = area.get_parent()
			if turret.health < turret.max_health:
				turret.health += heal_amount
