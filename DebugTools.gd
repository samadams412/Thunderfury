extends Node

@export var enabled: bool = true

func _unhandled_input(event: InputEvent) -> void:
	if not enabled or not OS.is_debug_build():
		return
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_KP_1:
				_grant_xp(50)
			KEY_KP_2:
				_skip_time(30)
			KEY_KP_3:
				_toggle_god_mode()
			KEY_KP_4:
				_kill_all_enemies()
			KEY_KP_5:
				_toggle_overlay()

func _grant_xp(amount: int) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.add_xp(amount)
		print("Debug: granted %d XP" % amount)

func _skip_time(seconds: int) -> void:
	var spawner = get_tree().get_first_node_in_group("spawner")
	if spawner:
		spawner.time += seconds
		spawner.run_time_changed.emit(spawner.time)
		print("Debug: skipped %d seconds, time now %d" % [seconds, spawner.time])

func _toggle_god_mode() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.god_mode = not player.god_mode
		print("Debug: god mode = ", player.god_mode)

func _kill_all_enemies() -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy._on_hurt_box_hurt(9999)
	print("Debug: killed %d enemies" % enemies.size())

func _toggle_overlay() -> void:
	var overlay = get_tree().get_first_node_in_group("debug_overlay")
	print("Debug: overlay found = ", overlay)
	if overlay:
		overlay.visible = not overlay.visible
		print("Debug: overlay visible = ", overlay.visible)
