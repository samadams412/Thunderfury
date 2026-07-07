extends CharacterBody2D

var movement_speed = 60.0
var hp = 50
#Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
#AttackNodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 1 #increase this to shoot multiple
var icespear_attackspeed = 1.5
var icespear_level = 1

#EnemyRelated
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _ready():
	pass
	#attack()

func _physics_process(_delta):
	movement()
	
func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

func movement():
	# Optimized vector movement
	var mov = Input.get_vector("left", "right", "up", "down")
	
	# Handle Sprite Flipping
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
		
	# Animation Logic (Tutorial style)
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			# This logic cycles through your frames
			sprite.frame = 0 if sprite.frame >= sprite.hframes - 1 else sprite.frame + 1
			walkTimer.start()
	
	# Physics
	velocity = mov * movement_speed
	move_and_slide()


func _on_hurt_box_hurt(damage):
	hp -= damage
	print("Player HP: ", hp)
	if hp <= 0:
		# For now, just reload the scene or print a death message
		get_tree().reload_current_scene()

# This is essentially loading the ammunition?
func _on_ice_spear_timer_timeout() -> void:
	return
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()

# This is shooting the ammo?
func _on_ice_spear_attack_timer_timeout() -> void:
	return
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target() #Player made function
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -=1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()
		
func get_random_target():
	return
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else: #if nothing returns just shoot UP
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
