extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10
# Add this: Set this to true for Ragnaros, false for the Goblin in the Inspector
@export var use_directional_animations : bool = false 

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

func _ready():
	if use_directional_animations:
		anim.play("walk_left") # Start with a default
	else:
		anim.play("walk")

func _physics_process(_delta):
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
	if hp <= 0:
		queue_free()
