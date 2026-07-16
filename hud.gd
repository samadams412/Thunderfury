extends CanvasLayer

@onready var hp_bar: ProgressBar = $HPFrame/HPBar
@onready var level_label: Label = $HPFrame/LevelLabel
@onready var xp_bar: ProgressBar = $XPBarContainer/XPBar

var player: Node = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.hp_changed.connect(_on_hp_changed)
	player.xp_changed.connect(_on_xp_changed)
	player.leveled_up.connect(_on_leveled_up)

	_on_hp_changed(player.hp, player.max_hp)
	_on_xp_changed(player.current_xp, player.xp_to_next_level)
	_on_leveled_up(player.level)

func _on_hp_changed(current: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current

func _on_xp_changed(current: int, xp_to_next: int) -> void:
	xp_bar.max_value = xp_to_next
	xp_bar.value = current

func _on_leveled_up(new_level: int) -> void:
	level_label.text = str(new_level)
