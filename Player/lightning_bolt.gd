extends Area2D

@export var speed = 200
@export var damage = 5
var my_player : Node2D 

func _ready():
	# If the bolt spawns pointing sideways, 
	# rotate it so it matches the mouse direction perfectly.
	#print("Initial bolt rotation: ", rad_to_deg(rotation))
	#rotation += deg_to_rad(90) 
	scale = Vector2(0.5, 0.5) # start smaller
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(self, "modulate", Color.CYAN, 0.2).from(Color.WHITE)
	tween.set_loops()
	rotation_degrees += 5
	# Cleanup after 3 seconds
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta):
	# Move forward along the projectile's local "Up" (which is now oriented to the mouse)
	position += transform.x * speed * delta
	position.y += sin(Time.get_ticks_msec() / 100.0) * 0.5

func _on_body_entered(body):
	if body == my_player:
		return
		
	if body.has_method("enemy_hit"):
		body.enemy_hit(damage)
		queue_free()
	elif not body.is_in_group("player"): 
		queue_free()
