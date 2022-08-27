extends Node2D

# References to the nodes in our scene
onready var _anim_player := $AnimationPlayer
onready var _track_1 := $Track1
onready var _track_2 := $Track2
onready var _player_sounds :Node = $PlayerSounds
export(Array, AudioStream) var theme_musics
var last_song
var current_song: AudioStream setget set_current_song
export (AudioStream) var first_song


func set_current_song(song) -> void:
	last_song = current_song
	current_song = song
	crossfade_to(current_song)


func crossfade_to(audio_stream: AudioStream) -> void:
	if _track_1.playing and _track_2.playing:
		return
	if _track_2.playing:
		_track_1.stream = audio_stream
		_track_1.play()
		_anim_player.play("FadeToTrack1")
	else:
		_track_2.stream = audio_stream
		_track_2.play()
		_anim_player.play("FadeToTrack2")


func play_random_song() -> void:
	var x = 0
	var selected_song: AudioStream
	while x != 7:
		var selected_index = Rng.rng.randi_range(0, theme_musics.size()-1)
		selected_song = theme_musics[selected_index]
		if current_song == null:
			break
		if selected_song.resource_path != current_song.resource_path:
			x = 7
	self.current_song = selected_song

func player_sounds_player(audio_name) -> void:
	_player_sounds.get_node(audio_name).play()


	
	


func _on_Track1_finished():
	play_random_song()


func _on_Track2_finished():
	play_random_song()
