extends CanvasLayer
signal upgrade_selected(upgrade: Upgrade)

@onready var cards: Array[Control] = [$HBoxContainer/Card1/VBoxContainer, $HBoxContainer/Card2/VBoxContainer, $HBoxContainer/Card3/VBoxContainer]

func setup(choices: Array[Upgrade]) -> void:
	for i in cards.size():
		var card = cards[i]
		if i < choices.size():
			var upgrade = choices[i]
			card.visible = true
			card.get_node("NameLabel").text = upgrade.display_name
			card.get_node("DescLabel").text = upgrade.description
			if upgrade.icon:
				card.get_node("Icon").texture = upgrade.icon
			var button = card.get_node("Button") as Button
			if button.pressed.is_connected(_on_card_pressed):
				button.pressed.disconnect(_on_card_pressed)
			button.pressed.connect(_on_card_pressed.bind(upgrade))
		else:
			card.visible = false

func _on_card_pressed(upgrade: Upgrade) -> void:
	upgrade_selected.emit(upgrade)
