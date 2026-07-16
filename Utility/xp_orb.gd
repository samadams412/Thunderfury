extends Area2D
class_name XPOrb

@export var xp_value: int = 1
@export var magnet_speed: float = 300.0
@export var pickup_distance: float = 12.0
@export var pickup_sound: AudioStream

signal collected(xp_value: int)

var player: Node2D = null
var is_magnetized: bool = false

func _ready() -> void:
	collision_layer = 4
	collision_mask = 1
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_magnetized = true

func _physics_process(delta: float) -> void:
	if not is_magnetized or player == null:
		return

	var distance = global_position.distance_to(player.global_position)
	if distance <= pickup_distance:
		SoundManager.play_sound(pickup_sound)
		collected.emit(xp_value)
		queue_free()
		return

	var direction = global_position.direction_to(player.global_position)
	global_position += direction * magnet_speed * delta
