extends Area2D

@export var speed = 200
@export var damage = 5
@export var pierce_count = 1
var my_player : Node2D 

func _ready():
	var anim_node = $Sprite2D
	anim_node.play("lightning")
	#print("Is Playing: ", anim_node.is_playing())
	#area_entered.connect(_on_area_entered)
	#body_entered.connect(_on_body_entered)
	#$Sprite2D.animation_finished.connect(_on_animation_finished)
	#scale = Vector2(0.5, 0.5) # start smaller
	#var tween = create_tween()
	#tween.tween_property(self, 'scale', Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(self, "modulate", Color.CYAN, 0.2).from(Color.WHITE)
	#tween.set_loops()
	#rotation_degrees += 5
	# Cleanup after 3 seconds
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta):
	position += transform.x * speed * delta
	$Sprite2D.position.y += sin(Time.get_ticks_msec() / 100.0) * 0.5 #adds effect to lightning
func handle_hit():
	pierce_count -= 1
	print("pierce count: ", pierce_count)
	if pierce_count <= 0:
		queue_free()
#func _on_body_entered(body):
	#print("BOLT TOUCHED BODY: ", body.name)
	#print("Collided with: ", body.name)
	#if body == my_player:
		#return
		#
	#if body.has_method("enemy_hit"):
		#body.enemy_hit(damage)
		#pierce_count -= 1 
		#print("pierce count: ", pierce_count)
		#
		#if pierce_count <= 0:
			#queue_free()
		#return
	#elif not body.is_in_group("player"): 
		#queue_free()

#func _on_animation_finished():
	#queue_free() #if animation finishes before hitting anything, clean it up

# Change _on_body_entered to _on_area_entered
#func _on_area_entered(area):
	#print("BOLT TOUCHED AREA: ", area.name, "Group: ", area.get_groups())
	## Check if we hit a hurtbox
	#if area.is_in_group("enemy_hurtbox"): 
		#print("Success, hit enemy hurtbox")
		## Ensure your HurtBox is in this group!
		#if area.get_parent().has_method("enemy_hit"):
			#area.get_parent().enemy_hit(damage)
			#
			#pierce_count -= 1 
			#print("pierce count: ", pierce_count)
			#
			#if pierce_count <= 0:
				#queue_free()
