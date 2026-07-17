# upgrade_movement_speed.gd
extends Upgrade
class_name UpgradeMovementSpeed

@export var percent: float = 0.08

func apply(player: Node) -> void:
	player.movement_speed *= (1.0 + percent)
