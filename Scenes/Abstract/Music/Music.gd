extends Node


#SONGS
onready var titleMusic = $TitleMusic
onready var gameMusic = $GameMusic

#SOUNDS
onready var UIHoverSound = $UIHoverSound
onready var UISelectSound = $UISelectSound
onready var UIAlertSound = $UIAlertSound
onready var UIErrorSound = $UIErrorSound
onready var dropWhistleSound = $DropWhistleSound
onready var explodeSound = $ExplodeSound
onready var groundHitSOund = $GroundHitSound


onready var sounds = [
	UIHoverSound,
	UISelectSound
]

onready var startMusicTween = $StartMusicTween
onready var stopMusicTween = $StopMusicTween

var Music_enabled = true 
var MusicAdjustment = 0
var EffectSounds_enabled = true
var EffectsAdjustment = 0
var last_sfx_adjustment = 0
var muted = false
var first = true
var songs_playing = []
var songs_to_stop = []


func play_music_fade(song, play_volume, tween_time=1):
	if Music_enabled:
		if songs_to_stop.has(song):
			songs_to_stop.erase(song)
			stopMusicTween.stop(song)
		songs_playing.append(song)
		song.set_deferred('volume_db', -100)
		song.set_deferred('playing', true)
		startMusicTween.interpolate_property(song, 'volume_db', -35.0, play_volume+MusicAdjustment, tween_time, 
		Tween.TRANS_SINE, Tween.EASE_IN)
		startMusicTween.start()
	else:
		pass

func stop_music_fade(song, tween_time=3):
	if song.playing:
		songs_playing.erase(song)
		songs_to_stop.append(song)
		startMusicTween.stop(song)
		stopMusicTween.interpolate_property(song, 'volume_db', song.volume_db, -35.0, tween_time, 
		Tween.TRANS_SINE, Tween.EASE_IN)
		stopMusicTween.start()

func stop_all_music():
	for song in songs_playing:
		startMusicTween.stop(song)
		song.set_deferred('playing', false)
		songs_playing.erase(song)


func _on_StopMusicTween_tween_completed(_object, _key):
	for song in songs_to_stop:
		song.stop()
		songs_to_stop.erase(song)


func apply_settings():
	if EffectSounds_enabled:
		for sound in sounds:
			if muted:
				sound.volume_db += 100
			if first:
				sound.volume_db += last_sfx_adjustment
				first = false
			else:
				sound.volume_db += EffectsAdjustment
		muted = false
	elif !EffectSounds_enabled:
		for sound in sounds:
			if !muted:
				sound.volume_db -= 100
			sound.volume_db += EffectsAdjustment
		muted = true

