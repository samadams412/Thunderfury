extends Node2D

@export var projectile_scene : PackedScene
@onready var spawn_point = $SpawnPoint
@export var fire_rate : float = 0.5
@onready var fire_rate_timer = $FireRateTimer


var is_facing_right : bool = false 

# Store the direction the player is aiming at
var aim_direction : Vector2 = Vector2.RIGHT 

func _ready():
	fire_rate_timer.wait_time = fire_rate

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
	# Only fire if timer is NOT running
	if not fire_rate_timer.is_stopped():
		return
	
	var spawn_pos = spawn_point.global_position
		
	if not projectile_scene:
		print("ERROR: Projectile scene not assigned!")
		return
	
	#tween for weapon fire responsiveness	
	var recoil_tween = create_tween()
	recoil_tween.tween_property(self, "rotation", rotation - 0.2, 0.05)
	recoil_tween.tween_property(self, "rotation", rotation + 0.2, 0.1)
		
	fire_rate_timer.start()
	
	var proj = projectile_scene.instantiate()
	proj.my_player = owner_player
	proj.global_position = spawn_pos
	#proj.global_position = spawn_point.global_position
	
	get_tree().root.add_child(proj)
	
	proj.look_at(get_global_mouse_position())
	print("Weapon aim angle: ", rad_to_deg(proj.rotation))
	print("SpawnPoint Global: ", spawn_pos)
	print("Projectile Global: ", proj.global_position)
