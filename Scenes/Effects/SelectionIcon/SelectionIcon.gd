extends AnimatedSprite

var center_y = (90 + Globals.viewport_y)/2 # 90 is the distance from top screen to moon
var center_x = Globals.viewport_x/2
var sprite_circle_size = Vector2(30, 20) * scale
var x_axis_tolerance = Globals.viewport_x/2 - sprite_circle_size.x/2
var y_axis_tolerance = 90 - sprite_circle_size.y/2

var seeking = true

signal selection_icon_return_position(location)


func _physics_process(_delta):
	if seeking:
		if abs(get_global_mouse_position().x - center_x) < x_axis_tolerance and abs(get_global_mouse_position().y - center_y) < y_axis_tolerance:
			self.global_position = get_global_mouse_position()

func _on_position_selected(selected):
	if selected:
		seeking = false
		emit_signal("selection_icon_return_position", self.global_position)
	else:
		seeking = true

func _on_destroy_selection_icon():
	queue_free()
