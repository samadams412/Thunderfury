extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage)

func _on_area_entered(area):
	# 1. NEW: Ignore hits if the collision is currently disabled (prevents double-hits)
	if collision.disabled:
		return

	if area.is_in_group("attack"):
		# 2. Logic to tell the projectile it hit something (for pierce/lifecycle)
		if area.has_method("handle_hit"):
			area.handle_hit()
			
		# 3. Ensure we have damage to process
		if not area.get("damage") == null:
			match HurtBoxType:
				0: # cooldown
					# This disables the hurtbox to prevent further hits until timer finishes
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1: # HitOnce
					pass
				2: # DisableHitBox
					if area.has_method("tempdisable"):
						area.tempdisable()
			
			# 4. Trigger damage
			var damage = area.damage
			emit_signal("hurt", damage)
			
			# Note: We removed the extra area.enemy_hit(1) here 
			# because your enemy.gd handles damage via the 'hurt' signal.
			# Keep this ONLY if you have specific secondary logic needed.

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)
