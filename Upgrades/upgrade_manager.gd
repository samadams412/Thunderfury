extends Node

@export var upgrade_pool: Array[Upgrade] = []
@export var upgrade_card_scene: PackedScene

var stack_counts: Dictionary = {}
var player: Node = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.leveled_up.connect(_on_leveled_up)

func _on_leveled_up(new_level: int) -> void:
	if new_level % 3 != 0:
		return
	var choices = _pick_upgrades(3)
	if choices.is_empty():
		return
	_show_upgrade_ui(choices)

func _pick_upgrades(count: int) -> Array[Upgrade]:
	var eligible: Array[Upgrade] = []
	for upgrade in upgrade_pool:
		var stacks = stack_counts.get(upgrade, 0)
		if stacks < upgrade.max_stacks:
			eligible.append(upgrade)

	var chosen: Array[Upgrade] = []
	var pool_copy = eligible.duplicate()
	for i in min(count, pool_copy.size()):
		var picked = _weighted_pick(pool_copy)
		chosen.append(picked)
		pool_copy.erase(picked)
	return chosen

func _weighted_pick(pool: Array[Upgrade]) -> Upgrade:
	var total_weight := 0.0
	for u in pool:
		total_weight += u.weight
	var roll = randf() * total_weight
	var cumulative := 0.0
	for u in pool:
		cumulative += u.weight
		if roll <= cumulative:
			return u
	return pool[-1]

func _show_upgrade_ui(choices: Array[Upgrade]) -> void:
	get_tree().current_scene.set_game_state(false)
	var ui = upgrade_card_scene.instantiate()
	get_tree().current_scene.add_child(ui)
	ui.setup(choices)
	ui.upgrade_selected.connect(_on_upgrade_selected.bind(ui))

func _on_upgrade_selected(upgrade: Upgrade, ui: Node) -> void:
	upgrade.apply(player)
	stack_counts[upgrade] = stack_counts.get(upgrade, 0) + 1
	ui.queue_free()
	get_tree().current_scene.set_game_state(true)
