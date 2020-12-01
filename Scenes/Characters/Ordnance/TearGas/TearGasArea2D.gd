extends Area2D


onready var tween = $Tween
onready var sprite = $Sprite
onready var slowing = Items.items.get(shell_type).get('slowing')
onready var duration = Items.items.get(shell_type).get('duration')
onready var radius = Items.items.get(shell_type).get('radius')

var level_1_radius = Items.items.get('tear gas').get('radius')
var shell_type = 'tear gas'
var ready_to_die = false


func _ready():
	$CollisionShape2D.shape.set_radius(level_1_radius)
	self.scale *= radius/float(level_1_radius)
	$Timer.set_wait_time(duration)
	$Timer.start()
	tween.interpolate_property(sprite, 'scale', Vector2.ZERO, sprite.scale, .3,
	 Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()


func _on_TearGasArea2D_area_entered(area):
	area.get_parent().speed *= slowing
	area.get_parent().tear_gassed = true
	area.get_parent().set_modulate(Color(0.75, 1, .6, 1))

func _on_Timer_timeout():
	tween.interpolate_property(self, 'modulate', self.modulate, Color(1,1,1,0), 1,
	 Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', self.scale, self.scale/2.0, 1,
	 Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()


func _on_Tween_tween_all_completed():
	if ready_to_die:
		queue_free()
	ready_to_die = true
