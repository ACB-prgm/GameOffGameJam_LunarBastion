extends RayCast2D


var view_range = 120

signal target_in_range(area)


func _ready():
	cast_to.x = view_range

func _physics_process(_delta):
	if is_colliding():
		emit_signal("target_in_range", get_collider())
		set_physics_process(false)

func _process(_delta):
	if Globals.Base:
		look_at(Globals.Base.global_position)
		set_process(false)
