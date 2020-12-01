extends Camera2D


export var boot_up = false

onready var shakeTimer = $ShakeTimer
onready var transitioner = Transitioner

var returning_center = false
var shaking = false
var shake_amount = 0
var relative_offset = offset
var relative_zoom = zoom


func _ready():
	Globals.camera = self
	if !boot_up:
		transitioner.fade_in()

func _process(delta):
	offset = lerp(offset, relative_offset, .05)
	zoom = lerp(zoom, relative_zoom, .05)
	if shaking:
		offset = Vector2(rand_range(-shake_amount,shake_amount), rand_range(-shake_amount,shake_amount)) * delta + relative_offset

func _on_enemy_died(points):
	shaking = true
	shake_amount += points
	if shake_amount > 300:
		shake_amount = 300
		# sets the maximum shake_amount
	if shake_amount > 50:
		shakeTimer.wait_time = 0.4 + shake_amount/1000.0
	shakeTimer.start()


func shake(shake_amplitude, shake_time=0.4, shake_limit=100):
	shaking = true
	shake_amount += shake_amplitude
	if shake_amount > shake_limit:
		shake_amount = shake_limit
	shakeTimer.wait_time = shake_time
	shakeTimer.start()

func _on_ShakeTimer_timeout():
	shaking = false
	shake_amount = 0
	shakeTimer.wait_time = 0.4

func stop_shake():
	if shaking:
		shaking = false
		shake_amount = 0
		shakeTimer.stop()
		shakeTimer.wait_time = 0.4
