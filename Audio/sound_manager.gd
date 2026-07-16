extends Node

@export var pool_size: int = 8

var players: Array[AudioStreamPlayer] = []
var next_index := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in pool_size:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		players.append(player)

func play_sound(stream: AudioStream) -> void:
	if stream == null:
		return
	var player := _get_available_player()
	player.stream = stream
	player.play()

func _get_available_player() -> AudioStreamPlayer:
	for p in players:
		if not p.playing:
			return p
	# All voices busy — steal the oldest one rather than drop the sound
	var player := players[next_index]
	next_index = (next_index + 1) % players.size()
	return player
