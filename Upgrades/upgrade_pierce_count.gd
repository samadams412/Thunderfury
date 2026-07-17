# upgrade_pierce_count.gd
extends Upgrade
class_name UpgradePierceCount

@export var amount: int = 1

func apply(player: Node) -> void:
	player.weapon.pierce_count += amount
