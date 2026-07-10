extends Node2D

@export var projectile_scene : PackedScene
@onready var spawn_point = $SpawnPoint

var is_facing_right : bool = false 

# Store the direction the player is aiming at
var aim_direction : Vector2 = Vector2.RIGHT 

func aim(target_pos : Vector2):
	# 1. Update the direction we are aiming
	aim_direction = (target_pos - global_position).normalized()
	
	# 2. Set visual rotation to a fixed angle (Radians!)
	# deg_to_rad converts degrees to the units Godot needs
	if is_facing_right:
		rotation = deg_to_rad(16) 
	else:
		rotation = deg_to_rad(-16)
		

func fire(owner_player : Node2D):
	var proj = projectile_scene.instantiate()
	get_tree().root.add_child(proj)
	
	
	
	proj.my_player = owner_player
	proj.global_position = spawn_point.global_position
	
	# IMPORTANT: Point the projectile at the mouse, NOT the weapon rotation
	proj.look_at(get_global_mouse_position())
	print("Weapon aim angle: ", rad_to_deg(proj.rotation))
