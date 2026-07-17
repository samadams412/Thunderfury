extends Resource
class_name Upgrade

@export var display_name: String
@export var description: String
@export var icon: Texture2D
@export var weight: float = 1.0        # rarity — higher = more common
@export var max_stacks: int = -1       # -1 = unlimited

func apply(player: Node) -> void:
	pass  # overridden per upgrade type
