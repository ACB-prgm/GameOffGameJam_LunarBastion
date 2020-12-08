extends CanvasLayer


var loaded = false

var muzzleFlashSide = preload("res://Scenes/Abstract/ParticlesCache/Materials/PlayerMuzzleFlashSide.tres")
var muzzleFlashFront = preload("res://Scenes/Abstract/ParticlesCache/Materials/PlayerMuzzleFlashFront.tres")
var bulletShellEffect = preload("res://Scenes/Abstract/ParticlesCache/Materials/BulletShellEffect.tres")
var spaceCannonFlash = preload("res://Scenes/Abstract/ParticlesCache/Materials/EarthCannonFlash.tres")
var mmShellExplode = preload("res://Scenes/Abstract/ParticlesCache/Materials/100mmShell.tres")
var mmShellExplode2 = preload("res://Scenes/Abstract/ParticlesCache/Materials/100mmShell2.tres")
var shotgunBullet = preload("res://Scenes/Abstract/ParticlesCache/Materials/ShotgunBullet.tres")
var dropPodSmoke = preload("res://Scenes/Abstract/ParticlesCache/Materials/DropPodSmoke.tres")
var landingDustEffect = preload("res://Scenes/Abstract/ParticlesCache/Materials/LandingDustEffect.tres")
var teargasparticles = preload("res://Scenes/Abstract/ParticlesCache/Materials/TearGasParticles.tres")
var healingParticles = preload("res://Scenes/Abstract/ParticlesCache/Materials/HealingParticles.tres")
var healingLoops = preload("res://Scenes/Abstract/ParticlesCache/Materials/HealingLoops.tres")
var enemyProjectile = preload("res://Scenes/Abstract/ParticlesCache/Materials/EnemyProjectile.tres")
var enemyProjectileExplosion = preload("res://Scenes/Abstract/ParticlesCache/Materials/EnemyProjectileExplosion.tres")
var godotLoadSceneParticles = preload("res://Scenes/StartUp/GodotSplash/GodotLogoParticles.tres")
var drillParticles = preload("res://Scenes/Abstract/ParticlesCache/Materials/BaseDrillParticles.tres")
var levelUpParticles = preload("res://Scenes/Abstract/ParticlesCache/Materials/LevelUpParticles.tres")

var materials = [
	muzzleFlashSide,
	muzzleFlashFront,
	bulletShellEffect,
	spaceCannonFlash,
	mmShellExplode,
	mmShellExplode2,
	shotgunBullet,
	dropPodSmoke,
	landingDustEffect,
	teargasparticles,
	healingParticles,
	healingLoops,
	enemyProjectile,
	enemyProjectileExplosion,
	godotLoadSceneParticles,
	drillParticles,
	levelUpParticles
]

func _ready():
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.position = Vector2(-1000,-1000)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)
	loaded = true
