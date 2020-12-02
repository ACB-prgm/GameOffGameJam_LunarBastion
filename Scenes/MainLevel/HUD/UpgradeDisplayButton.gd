extends TextureButton


signal upgrade_selected(upgrade, upgrade_cost, display_node)
signal upgrade_deselected(display_node)

export (
	String,
	'fortification',
	'better boring',
	'high explosives',
	'slow release',
	'medical',
	'reinforced'
) var upgrade 

onready var name_label = $ColorRect/Name
onready var description_label = $ColorRect/Description
onready var cost_label = $ColorRect/Cost

var turret_level = 1
var max_turret_level = 3
var turret_at_max_level = false
var upgrade_cost = 0


func _ready():
	_on_UpgradeDisplayButton_toggled(false)
	write_info()

func write_info():
	var upgrade_info = Items.upgrades.get(upgrade)
	
	if upgrade_info.get('type') == 'base': # BASE UPGRADE
		name_label.set_text(upgrade)
		description_label.set_text(upgrade_info.get('description'))
	elif turret_level < max_turret_level: # TURRET UPGRADE
		upgrade_info = upgrade_info.get(str(turret_level))
		name_label.set_text('%s lvl %s' % [upgrade, turret_level + 1])
		description_label.set_text(upgrade_info.get('description'))
	else:
		name_label.set_text('%s lvl %s' % [upgrade, turret_level + 1])
		description_label.set_text('Turret fully upgraded')
		turret_at_max_level = true

	upgrade_cost = upgrade_info.get('cost')
	cost_label.set_text('cost: %s' % [upgrade_cost])


func _on_UpgradeDisplayButton_toggled(button_pressed):
	if button_pressed and !turret_at_max_level:
		Music.UISelectSound.play()
		rect_position += Vector2(3, 3).rotated(rect_rotation)
		set_modulate(Color(1.1,1.1,1.1,1))
		emit_signal("upgrade_selected", upgrade, upgrade_cost, self)
	else:
		rect_position -= Vector2(3, 3).rotated(rect_rotation)
		set_modulate(Color(1,1,1,.8))
		emit_signal("upgrade_deselected", self)


func _on_UITabs_base_upgrade_selected():
	show()

func _on_UITabs_base_upgrade_deselected():
	hide()

