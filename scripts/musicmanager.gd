extends Node

var music_on := true
var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	var music_stream = preload("res://assets/audio/Story of Maple_mp3.mp3") as AudioStream
	music_player.stream = music_stream
	music_player.autoplay = music_on
	
	if music_on:
		music_player.play()
	
	# Connect finished signal to loop
	music_player.finished.connect(_on_music_finished)

func _on_music_finished():
	if music_on:
		music_player.play()
		
		
func toggle_music():
	music_on = !music_on
	if music_on:
		music_player.play()
	else:
		music_player.stop()
