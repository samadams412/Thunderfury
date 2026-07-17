extends CanvasLayer

@onready var label: Label = $Label
var player: Node = null
var spawner: Node = null

func _ready() -> void:
	add_to_group("debug_overlay")
	player = get_tree().get_first_node_in_group("player")
	spawner = get_tree().get_first_node_in_group("spawner")

func _process(_delta: float) -> void:
	if not visible:
		return
	label.text = "HP: %d/%d\nLevel: %d\nXP: %d/%d\nTime: %d\nPierce: %d\nSpeed: %.1f\nFireRate: %.2f\nGod Mode: %s" % [
		player.hp, player.max_hp,
		player.level,
		player.current_xp, player.xp_to_next_level,
		spawner.time,
		player.weapon.pierce_count,
		player.movement_speed,
		player.weapon.fire_rate,
		player.god_mode
	]
