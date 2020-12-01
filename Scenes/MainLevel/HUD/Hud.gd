extends Control


onready var moontoniumCounter = $MoontoniumCounter
onready var messagerLabel = $MessagerLabel
onready var UITabs = $UITabs
onready var hideTabsButton = $HideTabsButton
onready var launchButton = $LaunchButton
onready var turretLimitLabel = $TurretLimitLabel

var selectionIcon = preload("res://Scenes/Effects/SelectionIcon/SelectionIcon.tscn")
var item_selected = false
var selected_item = null
var selected_item_cost = null
var selected_position = Vector2.ZERO
var num_turrets = 0
var turret_limit = 6
var mode = 2

signal position_selection(selected)
signal item_launched(cost, selected_position, mode, item)
signal destroy_selection_icon()


func _ready():
	UITabs.set_current_tab(2)
	launchButton.hide()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		match mode:
			0: # UPGRADE MODE
				pass
			1: # ORDNANCE MODE
				if item_selected:
					emit_signal("position_selection", true)
			2: # TURRETS MODE
				if item_selected:
					emit_signal("position_selection", true)

# SIGNALS ———————————————————
func _on_UITabs_tab_changed(tab):
	mode = tab
	
	if tab == 2:
		turretLimitLabel.show()
	else:
		turretLimitLabel.hide()
	
	_on_turret_upgrade_deselected()
	_on_Base_upgrade_base_deselected()

func _on_UITabs_item_selected(item, cost):
	'item is a string referring to the turret/ordnance in the JSON'
	
	if !item_selected: # SPAWNS SELECTION ICON
		var select_icon = selectionIcon.instance()
		add_child(select_icon)
		select_icon.global_position = Vector2(Globals.viewport_x/2, Globals.viewport_y/2)
# warning-ignore:return_value_discarded
		self.connect("position_selection", select_icon, "_on_position_selected")
# warning-ignore:return_value_discarded
		self.connect("destroy_selection_icon", select_icon, "_on_destroy_selection_icon")
		select_icon.connect("selection_icon_return_position", self, "_on_selection_icon_return_position")
	
	item_selected = true
	selected_item_cost = cost
	selected_item = item

func _on_UITabs_current_item_deselected():
	item_selected = false
	selected_item_cost = null
	selected_item = null
	
	upgrade_selected = false
	selected_upgrade_cost = false
	selected_upgrade = null
	
	launchButton.hide()
	emit_signal("destroy_selection_icon")

func _on_selection_icon_return_position(location):
	selected_position = location
	launchButton.show()

# BUTTONS ————————————————————

func _on_HideTabsButton_toggled(button_pressed):
	if button_pressed:
		UITabs.hide()
		hideTabsButton.set_text('unhide tabs [h]')
		if current_upgrade_display:
			current_upgrade_display.hide()
	else:
		UITabs.show()
		hideTabsButton.set_text('hide tabs [h]')
		if current_upgrade_display:
			current_upgrade_display.show()

func _on_LaunchButton_pressed():
	if mode != 2 or mode == 2 and num_turrets < turret_limit:
		if moontoniumCounter.moontonium >= selected_item_cost:
			if mode == 2: # if turret build mode
				num_turrets += 1
				set_turret_limit_label()
			
			launchButton.hide()
			if item_selected:
				item_selected = false
				emit_signal("item_launched", selected_item_cost, selected_position, mode, selected_item)
				emit_signal("destroy_selection_icon")
			else:
				upgrade_selected = false
				emit_signal('upgrade_launched', selected_upgrade, selected_item_cost, mode, last_turret_node)
				_on_turret_upgrade_deselected()
		else:
			messagerLabel.display_message('Not enough Moontonium!')
	else:
		messagerLabel.display_message('turret build limit reached!')

func _on_AbortButton_pressed():
	messagerLabel.display_message('Launch aborted')
	launchButton.hide()
	emit_signal("position_selection", false)

func _on_Base_base_died():
	Globals.highsore = $TimerLabel.total_time_survived

func _on_turret_died():
	if num_turrets > 0:
		num_turrets -= 1
	set_turret_limit_label()

func set_turret_limit_label():
	turretLimitLabel.set_text('%s/%s turrets' % [num_turrets, turret_limit])

func upgrade_turret_limit(increment):
	turret_limit += increment
	set_turret_limit_label()

# UPGRADE MODE ————————————————————
signal base_selected()
signal base_deselected()
signal upgrade_launched(upgrade, cost, mode, turret_node)

var upgrade_selected = false
var selected_upgrade_cost = null
var selected_upgrade = null
var current_upgrade_display = null
var last_turret_node = null
var upgradeDisplayButton_TSCN = preload("res://Scenes/MainLevel/HUD/UpgradeDisplayButton.tscn")


func _on_Base_upgrade_base_selected():
	_on_turret_upgrade_deselected()
	emit_signal("base_selected")

func _on_Base_upgrade_base_deselected():
	emit_signal("base_deselected")
	if Globals.Base:
		Globals.Base.upgrade_deselect()


func _on_UITabs_upgrade_selected(upgrade, cost):
	upgrade_selected = true
	selected_item_cost = cost
	selected_upgrade = upgrade
	
	launchButton.show()

func on_turret_upgrade_selected(turret_node):
	_on_Base_upgrade_base_deselected()
	_on_turret_upgrade_deselected()
	last_turret_node = turret_node
	
	var displayUpgrade = upgradeDisplayButton_TSCN.instance()
	displayUpgrade.upgrade = turret_node.turret_type
	displayUpgrade.rect_position = Vector2(26, 43)
	displayUpgrade.rect_scale = Vector2(.75,.75)
	displayUpgrade.turret_level = turret_node.level
	displayUpgrade.connect('upgrade_selected', UITabs, '_on_UpgradeDisplayButton_upgrade_selected')
	displayUpgrade.connect('upgrade_deselected', UITabs, '_on_UpgradeDisplayButton_upgrade_deselected')
	current_upgrade_display = displayUpgrade
	add_child(displayUpgrade)

func _on_turret_upgrade_deselected():
	if current_upgrade_display:
		current_upgrade_display.queue_free()
		
	if last_turret_node:
		last_turret_node.upgrade_deselect()
		last_turret_node = null
	
	_on_UITabs_current_item_deselected()
	
	
