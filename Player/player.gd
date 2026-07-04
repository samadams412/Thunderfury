extends CharacterBody2D

var movement_speed = 60.0

func _physics_process(_delta): # Use _delta to show it is unused
	movement()
	
func movement():
	# get_vector automatically handles the subtraction logic for you
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * movement_speed
	move_and_slide()
