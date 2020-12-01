extends Control


var boundaries = rect_size
var enabled = false
var mouse_pos = Vector2.ZERO

signal custom_mouse_entered_exited(entered)


func _physics_process(_delta):
	mouse_pos = get_global_mouse_position()
	if mouse_pos.x < boundaries.x and mouse_pos.y < boundaries.y: # INSIDE
		if !enabled:
			enabled = true
			emit_signal("custom_mouse_entered_exited", enabled)
	else:
		if enabled:
			enabled = false
			emit_signal("custom_mouse_entered_exited", enabled)
