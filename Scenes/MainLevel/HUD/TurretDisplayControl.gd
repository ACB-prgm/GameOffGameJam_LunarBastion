extends TextureButton


export(
	String, 
	'machine gun', 
	'sniper', 
	'shotgun', 
	'rocket launcher',
	'100mm Shell',
	'mortars',
	'tear gas',
	'health kit'
) var item

var item_name = ''
var item_cost = 20
var item_info = ''
var started = false

onready var info = $Info/InfoLabel
onready var displayTexture = $TurretDisplayControl/DisplayTexture

signal item_selected(item, cost, child)
signal item_deselected(child)


func _ready():
	_on_TurretDisplayButton_toggled(false)
	write_info()

func write_info():
	item_name = ''
	item_cost = 20
	item_info = ''
	
	var raw_item_info = Items.items.get(item) # dictionary of info on the item
	var item_type = raw_item_info.get('type')
	var info_to_include = []
	item_name = item
	item_cost = raw_item_info.get('cost')
	
	if item_type == 'turret':
		info_to_include = ['damage', 'range', 'health']
		item_info += 'fire_rate: %s \n' % [str(stepify(1/raw_item_info.get('fire rate'), 0.1))]
#		raw_item_info['fire rate'] = stepify(1/raw_item_info.get('fire rate'), 0.1)
	else: # ORDNANCE
		info_to_include = raw_item_info.get('info')
	
	for stat in info_to_include:
		var stat_text = '%s: %s \n' % [stat, str(raw_item_info.get(stat))]
		item_info += stat_text

	$TurretDisplayControl/Name.set_text(item_name)
	$TurretDisplayControl/Cost.set_text('cost:' + str(item_cost))
	displayTexture.set_texture(load(raw_item_info.get('sprite_headshot')))
	info.set_text(item_info)

func _on_TurretDisplayButton_toggled(button_pressed):
	if button_pressed:
		Music.UISelectSound.play()
		rect_position += Vector2(3, 3).rotated(rect_rotation)
		set_modulate(Color(1.1,1.1,1.1,1))
		info.show()
		emit_signal("item_selected", item, item_cost, self)
	else:
		if started:
			Music.UIHoverSound.play()
		started = true
		rect_position -= Vector2(3, 3).rotated(rect_rotation)
		set_modulate(Color(1,1,1,.8))
		info.hide()
		emit_signal("item_deselected", self)

