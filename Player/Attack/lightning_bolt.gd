extends Area2D

@export var speed = 200
@export var damage = 5
@export var pierce_count = 1
var my_player : Node2D 

func _ready():
	var anim_node = $Sprite2D
	anim_node.play("lightning")
	
	await get_tree().create_timer(5.0, false).timeout
	#print("Timer finished, calling queue_free()")
	queue_free()
	
#func _process(_delta):
	#if get_tree().paused:
		#print("Bolt logic is paused") # This is not printint while paused
	#else:
		#print("Bolt logic is active")

func _physics_process(delta):
	position += transform.x * speed * delta
	$Sprite2D.position.y += sin(Time.get_ticks_msec() / 100.0) * 0.5 #adds effect to lightning
	
	
func handle_hit():
	pierce_count -= 1
	print("pierce count: ", pierce_count)
	if pierce_count <= 0:
		queue_free()
