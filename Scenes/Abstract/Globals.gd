extends Node


const viewport_y = 270.0
const viewport_x = 480.0

var upgrade_mode = false
var camera = null
var Base = null
var moontoniumCounter = null

var highsore = 0

var enemy_health_multiplyer = 1


# SAVING
const SAVE_DIR = 'user://saves/'
var save_path = SAVE_DIR + 'save.dat'


func _ready():
	# center the game window on the screen
	OS.set_window_position(OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)
	load_data()

func save_data():
	var data = {
		'highscore' : self.highsore
	}
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, 'abigail')
	if error == OK:
		file.store_var(data)
		file.close()

func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, 'abigail')
		if error == OK:
			var data = file.get_var()
			
			self.highsore = data.get('highscore')

			file.close()
	else:
		print('No Load Data')
