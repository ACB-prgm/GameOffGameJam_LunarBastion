extends ParallaxBackground

onready var planets = $PlanetsLayer
onready var basicStars = $BasicStarsLayer
onready var flickeringStars = $FlickeringStarsLayer

var offsetloc = 0


func _physics_process(delta):
	offsetloc += 8 * delta
	planets.set_motion_offset(Vector2(offsetloc, 0))
	basicStars.set_motion_offset(Vector2(offsetloc/2, 0))
	flickeringStars.set_motion_offset(Vector2(offsetloc/3, 0))
