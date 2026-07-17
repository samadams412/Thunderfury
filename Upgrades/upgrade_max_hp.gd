# upgrade_max_hp.gd
extends Upgrade
class_name UpgradeMaxHP

@export var percent: float = 0.08

func apply(player: Node) -> void:
	var increase = int(round(player.max_hp * percent))
	player.max_hp += increase
	player.hp += increase
	player.hp_changed.emit(player.hp, player.max_hp)
