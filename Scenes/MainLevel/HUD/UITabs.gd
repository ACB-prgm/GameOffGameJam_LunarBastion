extends TabContainer

signal item_selected(item, cost)
signal current_item_deselected()
signal upgrade_selected(upgrade, cost)

var current_item_selected = null


func _on_UITabs_tab_changed(tab):
	Music.UISelectSound.play()
	deselect_buttons(null, get_tab_control(get_previous_tab()))
	
	if tab == 0:
		Globals.upgrade_mode = true
	else:
		Globals.upgrade_mode = false


func _on_TurretDisplayButton_item_selected(item, cost, child):
	emit_signal("item_selected", item, cost)
	current_item_selected = child
	deselect_buttons(child) # move this one line up to make the selecticon disapear when switching

func _on_TurretDisplayButton_item_deselected(child):
	if child == current_item_selected:
		current_item_selected = null
		emit_signal("current_item_deselected")

func _on_item_launched(_cost, _selected_position, _mode, _item):
	deselect_buttons()


# SELF FUNCTIONS —————————————

func deselect_buttons(item_selected=null, tab=get_current_tab_control()):
	# unpresses all buttons in the given tab other than item_selected
	# if no item_selected is provided, unpresses all buttons
	var other_items = tab.get_children()
	
	for child in other_items:
		child.write_info()

	if item_selected:
		other_items.erase(item_selected)
	for child in other_items:
		if child.is_pressed():
			child.set_pressed(false)

func _on_TabsMouseDetector_custom_mouse_entered_exited(entered):
	if entered:
		set_mouse_filter(0)
	else:
		set_mouse_filter(2)



# UPGRADE MODE ————————————————————
signal base_upgrade_selected()
signal base_upgrade_deselected()

onready var upgradeTab = $Upgrade
var upgradeDisplayButton_TSCN = preload("res://Scenes/MainLevel/HUD/UpgradeDisplayButton.tscn")


func _on_HUD_base_selected():
	emit_signal("base_upgrade_selected")

func _on_HUD_base_deselected():
	emit_signal("base_upgrade_deselected")


func _on_UpgradeDisplayButton_upgrade_selected(upgrade, upgrade_cost, display_node):
	emit_signal("upgrade_selected", upgrade, upgrade_cost)
	current_item_selected = display_node
	deselect_buttons(display_node)

func _on_UpgradeDisplayButton_upgrade_deselected(display_node):
	if display_node == current_item_selected:
		current_item_selected = null
		emit_signal("current_item_deselected")


func _on_HUD_upgrade_launched(_upgrade, _cost, _mode, _turret_node):
	deselect_buttons()
