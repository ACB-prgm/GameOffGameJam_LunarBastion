extends Label


var moontonium_gen_amount = 5
var moontonium = 25


func _ready():
	Globals.moontoniumCounter = self

func _on_MoontoniumTimer_timeout():
	moontonium += moontonium_gen_amount
	set_text(str(moontonium))
	
	self.rect_size.x = get_total_character_count() * 16

func change_moontonium_rate(increment):
	$MoontoniumTimer.wait_time *= increment

func _on_HUD_item_launched(cost, _selected_position, _mode, _item):
	moontonium -= cost
	set_text(str(moontonium))

func _on_HUD_upgrade_launched(_upgrade, cost, _mode, _turret_node):
	moontonium -= cost
	set_text(str(moontonium))
