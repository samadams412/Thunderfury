extends Button

func _ready():
	# Connect signals automatically
	self.mouse_entered.connect(_on_hover)
	self.pressed.connect(_on_click)

func _on_hover():
	SoundManager.play_sound(preload("res://Audio/GUI/Hover.ogg"))

func _on_click():
	SoundManager.play_sound(preload("res://Audio/GUI/Click.ogg"))
