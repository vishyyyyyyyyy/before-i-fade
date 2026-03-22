extends Node

var music_on := true
var music_player: AudioStreamPlayer
var saved_position := 0.0
var playlist_positions := {} # key: "scene_index"
var playlist_indices := {}

# --- NEW ---
var playlists := {
	"menu": [
		preload("res://assets/audio/Story of Maple_mp3.mp3"),
		preload("res://assets/audio/soundgallerybydmitrytaras-horror-118577.mp3"),
		preload("res://assets/audio/geoffharvey-horror-playhouse-404813.mp3"),
		preload("res://assets/audio/geoffharvey-spooked-164545.mp3")
	],
	"puzzle1": [
		preload("res://assets/audio/kerosene-loop-at-different-pitches-190120.mp3")
	],
	"puzzle2": [
		preload("res://assets/audio/puzzle-game-bright-casual-video-game-music-249202.mp3")
	]
}

var current_playlist := []
var current_index := 0
var current_scene_music := ""

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.volume_db = -10
	add_child(music_player)
	music_player.finished.connect(_on_music_finished)
	print(music_player.volume_db)

	#default music
	play_scene_music("menu")

func _process(_delta):
	if music_player.volume_db != -10:
		print("Volume changed to: ", music_player.volume_db)
		music_player.volume_db = -10

func play_scene_music(scene_name: String):

	# save current position before switching
	if current_scene_music != "":
		var key = current_scene_music + "_" + str(current_index)
		playlist_positions[key] = music_player.get_playback_position()
		
	playlist_indices[current_scene_music] = current_index

	if current_scene_music == scene_name:
		return

	if not playlists.has(scene_name):
		push_warning("No music defined for scene: " + scene_name)
		return

	current_scene_music = scene_name
	current_playlist = playlists[scene_name]
	if playlist_indices.has(scene_name):
		current_index = playlist_indices[scene_name]
	else:
		current_index = 0

	_play_current_track()

#func _play_current_track():
	#if not music_on or current_playlist.is_empty():
		#return
#
	#music_player.stream = current_playlist[current_index]
#
	#var start_pos = 0.0
	#if playlist_positions.has(current_scene_music):
		#start_pos = playlist_positions[current_scene_music]
#
	#music_player.play(start_pos)

func _play_current_track():
	if not music_on or current_playlist.is_empty():
		return

	music_player.stream = current_playlist[current_index]
	music_player.volume_db = -10
	
	var key = current_scene_music + "_" + str(current_index)
	var start_pos = 0.0

	if playlist_positions.has(key):
		start_pos = playlist_positions[key]

	music_player.play(start_pos)

func _on_music_finished():
	if not music_on:
		return

	current_index = (current_index + 1) % current_playlist.size()
	_play_current_track()

func toggle_music():
	music_on = !music_on

	if music_on:
		music_player.play(saved_position)
	else:
		saved_position = music_player.get_playback_position()
		music_player.stop()
		
	var bus_idx = AudioServer.get_bus_index("Master")
	if bus_idx != -1:
		AudioServer.set_bus_mute(bus_idx, not music_on)
