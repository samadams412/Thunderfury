extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10
@export var xp_value: int = 1
# Set this to true for Ragnaros, false for the Goblin 
@export var use_directional_animations : bool = false 
@export var hit_sound: AudioStream
@export var death_sound: AudioStream


func flash_hit() -> void:
	var tween = create_tween()
	tween.tween_property(sprite_material, "shader_parameter/flash_amount", 1.0, 0.05)
	tween.tween_property(sprite_material, "shader_parameter/flash_amount", 0.0, 0.15)

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var sprite_material: ShaderMaterial = sprite.material
@onready var anim = $AnimationPlayer

signal died(position: Vector2, xp_value: int)

func _ready():
	add_to_group("enemy")
	sprite_material = sprite.material.duplicate()
	sprite.material = sprite_material
	
	if use_directional_animations:
		anim.play("walk_left") # Start with a default facing left 
	else:
		anim.play("walk")

func _physics_process(_delta):
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		return
		
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	move_and_slide()
	
	if use_directional_animations:
		# Ragnaros Logic
		if direction.x < 0:
			if anim.current_animation != "walk_left":
				anim.play("walk_left")
		else:
			if anim.current_animation != "walk_right":
				anim.play("walk_right")
	else:
		# Goblin Logic
		if direction.x > 0.1:
			sprite.flip_h = true
		elif direction.x < -0.1:
			sprite.flip_h = false


func _on_hurt_box_hurt(damage):
	hp -= damage
	print("enemy hp: ", hp)
	flash_hit()

	if hp <= 0:
		SoundManager.play_sound(death_sound)
		died.emit(global_position, xp_value)
		queue_free()
	else:
		SoundManager.play_sound(hit_sound)
		
