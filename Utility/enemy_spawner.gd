extends Node2D
@export var spawns: Array[Spawn_info] = []
@onready var player = get_tree().get_first_node_in_group("player")
@export var xp_orb_scene: PackedScene
@export var time = 0
signal run_time_changed(seconds: int)

func _ready():
	add_to_group("spawner")

func _on_timer_timeout():
	time += 1
	run_time_changed.emit(time)
	for i in spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				_spawn_batch(i.enemy, i.enemy_num)

func _spawn_batch(enemy_scene: PackedScene, count: int) -> void:
	for n in count:
		_spawn_single(enemy_scene)
		if n % 3 == 2:
			await get_tree().process_frame

func _spawn_single(enemy_scene: PackedScene) -> void:
	var enemy_spawn = enemy_scene.instantiate()
	enemy_spawn.global_position = get_random_position()
	add_child(enemy_spawn)
	enemy_spawn.died.connect(_on_enemy_died)

func _on_enemy_died(pos: Vector2, xp_value: int) -> void:
	var orb = xp_orb_scene.instantiate()
	orb.xp_value = xp_value
	orb.global_position = pos
	add_child.call_deferred(orb)
	orb.collected.connect(player.add_xp)	

func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)
