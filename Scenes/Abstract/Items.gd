extends Node


var items = {
	'machine gun': {
		'type': 'turret',
		'health': 10,'damage': 1,'fire rate': 0.6,'range': 100,
		'swivel speed': 6, 'cost': 25,
		'sprite_headshot': "res://Sprites/Turrets/He3adshots/BaseTurretHeadshot.png",
		'bullet': "res://Scenes/Characters/Turrets/Bullets/BaseBullet.tscn",
		'sprite_legs': "res://Sprites/Turrets/BaseTurret/BaseTurretLegs.png",
		'sprite_head': "res://Sprites/Turrets/BaseTurret/BaseTurretHEAD.png",
		'sprite_flash': "res://Sprites/Turrets/BaseTurret/BaseTurretFLASH_MAIN.png"
		},
	'sniper': {
		'type': 'turret',
		'health': 5,'damage': 3,'fire rate': 2.4,'range': 200,
		'swivel speed': 3, 'cost': 25,
		'sprite_headshot': "res://Sprites/Turrets/He3adshots/SniperHeadshot.png",
		'bullet': "res://Scenes/Characters/Turrets/Bullets/SniperBullet.tscn",
		'sprite_legs': "res://Sprites/Turrets/BaseTurret/BaseTurretLegs.png",
		'sprite_head': "res://Sprites/Turrets/SniperTurret/ST1/SniperTurretHead.png",
		'sprite_flash': "res://Sprites/Turrets/SniperTurret/ST1/SniperTurretHead_Flash.png"
		}, 
	'shotgun': {
		'type': 'turret',
		'health': 12,'damage': 1,'fire rate': 1.2,'range': 50,
		'swivel speed': 12, 'cost': 35,
		'sprite_headshot': "res://Sprites/Turrets/He3adshots/ShotgunHeadshot.png",
		'bullet': "res://Scenes/Characters/Turrets/Bullets/ShotgunBullet.tscn",
		'sprite_legs': "res://Sprites/Turrets/BaseTurret/BaseTurretLegs.png",
		'sprite_head': "res://Sprites/Turrets/Bullets/ShotgunTurret/ShotgunTurret.png",
		'sprite_flash': "res://Sprites/Turrets/Bullets/ShotgunTurret/ShotgunTurret_Flash.png"
		}, 
	'rocket launcher': {
		'type': 'turret',
		'health': 8,'damage': 1.5,'fire rate': 1.2,'range': 100,
		'swivel speed': 6, 'cost': 35, 'splash radius': 50,
		'sprite_headshot': "res://Sprites/Turrets/He3adshots/RocketLauncher1_Headshot.png",
		'bullet': "res://Scenes/Characters/Turrets/Bullets/RocketLauncherBullet.tscn",
		'sprite_legs': "res://Sprites/Turrets/BaseTurret/BaseTurretLegs.png",
		'sprite_head': "res://Sprites/Turrets/RocketLauncher1/RocketLauncher1.png",
		'sprite_flash': "res://Sprites/Turrets/RocketLauncher1/RocketLauncher1_Flash.png"
		},
	'100mm Shell': {
		'type': 'ordnance',
		'info' : ['damage', 'radius'],
		'cost': 20,
		'sprite_headshot': "res://Sprites/Ordnance/100mmShell.png",
		'scene': "res://Scenes/Characters/Ordnance/100mmShell/100mmShell.tscn",
		'damage': 5, 
		'radius': 25
		},
	'mortars': {
		'type': 'ordnance',
		'info' : ['total damage', 'radius'],
		'cost': 20,
		'sprite_headshot': "res://Sprites/Ordnance/OrdnanceHeadshots/MortarsHeadshot.png",
		'scene': "res://Scenes/Characters/Ordnance/Mortars/Mortars.tscn",
		'damage': 0, 
		'total damage': 2,
		'radius': 75
		},
	'tear gas': {
		'type': 'ordnance',
		'info' : ['damage', 'radius', 'slowing', 'duration'],
		'cost': 25,
		'sprite_headshot': "res://Sprites/Ordnance/TearGas/TearGasDropImage.png",
		'scene': "res://Scenes/Characters/Ordnance/100mmShell/100mmShell.tscn",
		'texture': "res://Sprites/Ordnance/TearGas/TearGasDropImage.png",
		'explosion_scene': "res://Scenes/Characters/Ordnance/TearGas/TearGasArea2D.tscn",
		'damage': 0, 
		'radius': 75,
		'slowing': 0.50,
		'duration': 10
		},
	'health kit': {
		'type': 'ordnance',
		'info' : ['damage', 'radius', 'health/second', 'duration'],
		'cost': 25,
		'sprite_headshot': "res://Sprites/Ordnance/Healing/HealingDropImage.png",
		'scene': "res://Scenes/Characters/Ordnance/100mmShell/100mmShell.tscn",
		'texture': "res://Sprites/Ordnance/Healing/HealingDropImage.png",
		'explosion_scene': "res://Scenes/Characters/Ordnance/Healing/HealingArea2D.tscn",
		'damage': 0, 
		'radius': 30,
		'health/second': 1,
		'duration': 10 
		},
}

var upgrades = {
	'fortification' : {
		'type' : 'base',
		'cost' : 75,
		'description' : '+25% base health',
		'increment' : 1.25
	},
	'better boring' : {
		'type' : 'base',
		'cost' : 100,
		'description' : '+15 moontonium generation rate',
		'increment' : .85
	},
	'high explosives' : {
		'type' : 'base',
		'cost' : 30,
		'description' : '+25% ordnance damage',
		'increment' : 1.25,
		'items' : ['100mm Shell', 'mortars'],
		'stat' : 'damage'
	},
	'slow release' : {
		'type' : 'base',
		'cost' : 30,
		'description' : '+25% healing and tear gas duration',
		'increment' : 1.25,
		'items' : ['tear gas', 'health kit'],
		'stat' : 'duration'
	},
	'medical' : {
		'type' : 'base',
		'cost' : 30,
		'description' : '+50% health from health kits',
		'increment' : 1.5,
		'items' : ['health kit'],
		'stat' : 'health/second'
	},
	'reinforced' : {
		'type' : 'base',
		'cost' : 150,
		'description' : '+1 turret build limit',
		'increment' : 1,
	},
	'machine gun' : {
		'type' : 'turret',
		'1' : {
			'cost' : 50,
			'stats' : {
				'fire_rate' : 0.3,
				'health' : 15
			},
			'description' : 'fire rate x2\nhealth +5'
		},
		'2' : {
			'cost' : 100,
			'stats' : {
				'fire_rate' : 0.2,
				'health' : 20,
			},
			'description' : 'fire rate x1.5\nhealth +5\n'
		},
	},
	'sniper' : {
		'type' : 'turret',
		'1' : {
			'cost' : 50,
			'stats' : {
				'fire_rate' : 1.8,
				'damage' : 5,
				'health' : 7
			},
			'description' : 'fire rate x1.25\ndamage +2\nhealth +2'
		},
		'2' : {
			'cost' : 100,
			'stats' : {
				'fire_rate' : 1.4,
				'damage' : 7,
				'health' : 10
			},
			'description' : 'fire rate x1.15\ndamage +2\nhealth +3'
		},
	},
	'shotgun' : {
		'type' : 'turret',
		'1' : {
			'cost' : 65,
			'stats' : {
				'damage' : 2.5,
				'health' : 20
			},
			'description' : 'damage +1.5\nhealth +8'
		},
		'2' : {
			'cost' : 120,
			'stats' : {
				'damage' : 4,
				'health' : 30
			},
			'description' : 'damage +1.5\nhealth +10'
		},
	},
	'rocket launcher' : {
		'type' : 'turret',
		'1' : {
			'cost' : 65,
			'stats' : {
				'splash_radius' : 70,
				'fire_rate' : 1.0,
				'damage' : 2.5
			},
			'description' : 'damage +1\nsplash radius +20'
		},
		'2' : {
			'cost' : 120,
			'stats' : {
				'splash_radius' : 100,
				'damage' : 4,
				'fire_rate' : 0.9
			},
			'description' : 'damage +1.5\nsplash radius +30'
		},
	}
}


const BACKUP_DIR = 'user://Items_Backup/'
var backup_path = BACKUP_DIR + 'items.dat'

func _ready():
	save_backup()

func save_backup():
	var data = {
		'items' : self.items,
		'upgrades' : self.upgrades
	}
	
	var dir = Directory.new()
	if !dir.dir_exists(BACKUP_DIR):
		dir.make_dir_recursive(BACKUP_DIR)
	
	var file = File.new()
	var error = file.open(backup_path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()

func load_backup():
	var file = File.new()
	if file.file_exists(backup_path):
		var error = file.open(backup_path, File.READ)
		if error == OK:
			var data = file.get_var()

			self.items = data.get('items')
			self.upgrades = data.get('upgrades')

			file.close()
	else:
		print('No Load Data')
