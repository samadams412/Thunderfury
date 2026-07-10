extends CharacterBody2D

@export var movement_speed = 60.0
var hp = 50

# Projectile Setup
@export var projectile_scene : PackedScene 
@onready var aim_point = $AimPoint # Ensure this node exists under your Player
@onready var fire_timer = $FireRateTimer # Add a Timer node as a child to Player
@onready var anim_player = $AnimationPlayer
# EnemyRelated
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _physics_process(_delta):
	movement()
	
	# Aim the AimPoint at the mouse
	aim_point.look_at(get_global_mouse_position())
	
	# Handle firing
	if Input.is_action_pressed("click") and fire_timer.is_stopped():
		shoot()

func shoot():
	if projectile_scene:
		var proj = projectile_scene.instantiate()
		get_tree().root.add_child(proj)
		
		# Set position and rotation from the AimPoint
		proj.global_position = aim_point.global_position
		proj.rotation = aim_point.global_rotation
		
		fire_timer.start()



func movement():
	var mov = Input.get_vector("left", "right", "up", "down")
	
	# Handle Sprite Flipping and Animation Selection
	if mov.x < 0:
		sprite.flip_h = false 
		aim_point.position = Vector2(-15, 3)
		anim_player.play("walk_left")
		
	elif mov.x > 0:
		sprite.flip_h = false # 
		aim_point.position = Vector2(15, 3)
		anim_player.play("walk_right")
		
	
	# Handle Idle (when not moving)
	if mov == Vector2.ZERO:
		anim_player.stop() # Add Idle animation
	
	velocity = mov * movement_speed
	move_and_slide()

func _on_hurt_box_hurt(damage):
	hp -= damage
	print("Player HP: ", hp)
	if hp <= 0:
		get_tree().reload_current_scene()

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
