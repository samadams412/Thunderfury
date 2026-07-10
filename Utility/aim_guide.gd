extends Node2D

func _process(_delta):
	# This makes the node follow the mouse cursor exactly
	global_position = get_global_mouse_position()
