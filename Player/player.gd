extends CharacterBody2D

@export var movement_speed = 60.0
var hp = 50

# Weapon Reference
@onready var weapon = $Weapon

# Enemy Detection
var enemy_close = []

@onready var anim_player = $AnimationPlayer
@onready var sprite = $Sprite2D

func _physics_process(_delta):
	movement()
	global_position = global_position.round()
	
	# Aiming: Tell the weapon where to look
	weapon.aim(get_global_mouse_position())
	
	# Input: Tell the weapon to fire
	if Input.is_action_just_pressed("click"):
		weapon.fire(self)

func movement():
	var mov = Input.get_vector("left", "right", "up", "down")
	
	# Handle Sprite/Weapon Logic
	if mov.x < 0:
		sprite.flip_h = false # Assuming row 0 is left
		weapon.position = Vector2(-15, -1) 
		weapon.is_facing_right = false
		anim_player.play("walk_left")
	elif mov.x > 0:
		sprite.flip_h = false # Assuming row 1 is right
		weapon.position = Vector2(15, -1) 
		weapon.is_facing_right = true
		anim_player.play("walk_right")
		
	elif mov.y != 0:
		if weapon.is_facing_right:
			anim_player.play("walk_right")
		else:
			anim_player.play("walk_left")
	
	if mov == Vector2.ZERO:
		anim_player.stop() 
	
	velocity = mov * movement_speed
	move_and_slide()

# --- Health & Hurtbox Logic ---
func _on_hurt_box_hurt(damage):
	hp -= damage
	print("Player HP: ", hp)
	if hp <= 0:
		get_tree().reload_current_scene()

# --- Enemy Detection Logic ---
func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
