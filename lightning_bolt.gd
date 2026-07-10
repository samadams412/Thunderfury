extends Area2D

@export var speed = 200
@export var damage = 5

func _ready():
	# 1. Handle the flip immediately when the bolt is created
	var player = get_tree().get_first_node_in_group("player")
	if player:
		# If facing left (flip_h is false), we flip the sprite vertically
		if player.sprite.flip_h == false:
			$Sprite2D.flip_v = true
		else:
			$Sprite2D.flip_v = false
			
	# 2. Cleanup timer (Separate from the flip logic)
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta):
	var direction = Vector2.from_angle(rotation)
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("enemy_hit"):
		body.enemy_hit(damage)
		queue_free()
