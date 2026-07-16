extends CharacterBody2D

@export var movement_speed = 60.0
@export var max_hp: int = 50
var hp = max_hp
var level: int = 1
var current_xp: int = 0
var xp_to_next_level: int = 100
var is_dead: bool = false
@export var level_up_sound: AudioStream
@export var hit_sound: AudioStream
@export var death_sound: AudioStream
@export var game_over_scene: PackedScene
@onready var level_up_effect = $LevelUpEffect
@onready var weapon = $Weapon

signal hp_changed(current_hp: int, max_hp: int)
signal xp_changed(current_xp: int, xp_to_next: int)
signal leveled_up(new_level: int)

# Enemy Detection
var enemy_close = []

@onready var anim_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var sprite_material: ShaderMaterial

func _ready() -> void:
	sprite_material = sprite.material.duplicate()
	sprite.material = sprite_material
	hp_changed.emit(hp, max_hp)
	xp_changed.emit(current_xp, xp_to_next_level)

func flash_hit() -> void:
	var tween = create_tween()
	tween.tween_property(sprite_material, "shader_parameter/flash_amount", 1.0, 0.05)
	tween.tween_property(sprite_material, "shader_parameter/flash_amount", 0.0, 0.15)

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
	
	if mov.x != 0:
		# 1. Set the state first
		weapon.is_facing_right = (mov.x > 0)
		
		# 2. Act based on that state
		if weapon.is_facing_right:
			sprite.flip_h = false
			weapon.position = Vector2(16, -3)
			anim_player.play("walk_right")
		else:
			sprite.flip_h = false # Assuming you handle sprite mirroring elsewhere
			weapon.position = Vector2(-17, -3)
			anim_player.play("walk_left")
			
	elif mov.y != 0:
		# Use the state to decide animation
		anim_player.play("walk_right" if weapon.is_facing_right else "walk_left")
	
	if mov == Vector2.ZERO:
		if not weapon.is_facing_right:
			anim_player.play("idle_left")
		elif weapon.is_facing_right:
			anim_player.play("idle_right")
			
	
	velocity = mov * movement_speed
	move_and_slide()

# --- Health & Hurtbox Logic ---
func _on_hurt_box_hurt(damage):
	if is_dead:
		return

	hp -= damage
	hp_changed.emit(hp, max_hp)
	print("Player HP: ", hp)
	flash_hit()
	
	if hp <= 0:
		is_dead = true
		SoundManager.play_sound(death_sound)
		show_game_over()
	else:
		SoundManager.play_sound(hit_sound)
		
func add_xp(value: int) -> void:
	current_xp += value
	while current_xp >= xp_to_next_level:
		current_xp -= xp_to_next_level
		level += 1
		xp_to_next_level += 50
		SoundManager.play_sound(level_up_sound)
		leveled_up.emit(level)
		level_up_effect.play()
	xp_changed.emit(current_xp, xp_to_next_level)
	
func show_game_over() -> void:
	get_tree().current_scene.add_child(game_over_scene.instantiate())
	get_tree().current_scene.set_game_state(false)

## --- Enemy Detection Logic ---
#func _on_enemy_detection_area_body_entered(body):
	#if not enemy_close.has(body):
		#enemy_close.append(body)
#
#func _on_enemy_detection_area_body_exited(body):
	#if enemy_close.has(body):
		#enemy_close.erase(body)
