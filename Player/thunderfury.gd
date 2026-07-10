extends Node2D

@export var bolt_scene : PackedScene 
@onready var muzzle = $MuzzlePosition
@onready var fire_timer = $FireRateTimer
@onready var sprite = $WeaponSprite

func _physics_process(_delta):
	# Aim toward the mouse
	look_at(get_global_mouse_position())
	
	# Keep the weapon sprite "upright"
	if rotation_degrees > 90 or rotation_degrees < -90:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	
	# Fire
	if Input.is_action_pressed("click") and fire_timer.is_stopped():
		fire()

func fire():
	if bolt_scene:
		var bolt = bolt_scene.instantiate()
		get_tree().root.add_child(bolt)
		bolt.global_position = muzzle.global_position
		bolt.rotation = global_rotation + deg_to_rad(-45)
		fire_timer.start()
		# Simple "kickback" animation
		var tween = create_tween()
		# Move sprite back slightly then forward
		tween.tween_property(sprite, "position:x", -5, 0.05)
		tween.tween_property(sprite, "position:x", 0, 0.1)
