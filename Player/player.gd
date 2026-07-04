extends CharacterBody2D

var movement_speed = 60.0
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _physics_process(_delta):
	movement()
	
func movement():
	# Optimized vector movement
	var mov = Input.get_vector("left", "right", "up", "down")
	
	# Handle Sprite Flipping
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
		
	# Animation Logic (Tutorial style)
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			# This logic cycles through your frames
			sprite.frame = 0 if sprite.frame >= sprite.hframes - 1 else sprite.frame + 1
			walkTimer.start()
	
	# Physics
	velocity = mov * movement_speed
	move_and_slide()
