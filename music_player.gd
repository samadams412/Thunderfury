extends AudioStreamPlayer

var tracks = [
	preload("res://Audio/Music/DayBarrenDry01.mp3"),
	preload("res://Audio/Music/DayBarrenDry03.mp3"),
	preload("res://Audio/Music/orgrimmar02-zone.mp3")
]
var current_track = 0

func _ready():
	self.finished.connect(_on_track_finished)
	play_next()

func _on_track_finished():
	current_track = (current_track + 1) % tracks.size() # Loop back to 0
	play_next()

func play_next():
	self.stream = tracks[current_track]
	self.play()
