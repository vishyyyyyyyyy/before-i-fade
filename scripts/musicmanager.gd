extends Node

var music_on := true
var music_player: AudioStreamPlayer

# --- NEW ---
var playlists := {
	"menu": [
		preload("res://assets/audio/Story of Maple_mp3.mp3"),
	],
	"level1": [

	],
	"boss": [
	]
}

var current_playlist := []
var current_index := 0
var current_scene_music := ""

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.finished.connect(_on_music_finished)

	# Optional: default music
	play_scene_music("menu")

func play_scene_music(scene_name: String):
	if current_scene_music == scene_name:
		return # already playing correct music

	if not playlists.has(scene_name):
		push_warning("No music defined for scene: " + scene_name)
		return

	current_scene_music = scene_name
	current_playlist = playlists[scene_name]
	current_index = 0

	_play_current_track()

func _play_current_track():
	if not music_on or current_playlist.is_empty():
		return

	music_player.stream = current_playlist[current_index]
	music_player.play()

func _on_music_finished():
	if not music_on:
		return

	current_index = (current_index + 1) % current_playlist.size()
	_play_current_track()

func toggle_music():
	music_on = !music_on
	if music_on:
		_play_current_track()
	else:
		music_player.stop()
