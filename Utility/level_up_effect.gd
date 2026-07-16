extends Node2D

@onready var glow_beam: Sprite2D = $GlowBeam
@onready var core_beam: Sprite2D = $CoreBeam
@onready var ground_glow: Sprite2D = $GroundGlow
@onready var sparkles: GPUParticles2D = $Sparkles

func _ready() -> void:
	z_index = -1

	glow_beam.texture = _make_beam_texture(40, Color(1.0, 0.85, 0.3, 0.35))
	core_beam.texture = _make_beam_texture(10, Color(1.0, 0.95, 0.6, 0.9))
	ground_glow.texture = _make_radial_texture(48, Color(1.0, 0.85, 0.3, 0.5))
	ground_glow.position.y = 16

	for beam in [glow_beam, core_beam]:
		var mat := CanvasItemMaterial.new()
		mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		beam.material = mat
	var ground_mat := CanvasItemMaterial.new()
	ground_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	ground_glow.material = ground_mat

	glow_beam.modulate.a = 0.0
	core_beam.modulate.a = 0.0
	ground_glow.modulate.a = 0.0
	_setup_particles()

func _make_beam_texture(width: int, color: Color) -> ImageTexture:
	var height := 120
	var image := Image.create(width, height, false, Image.FORMAT_RGBA8)
	for y in height:
		var t: float = float(y) / height
		var edge_fade: float = 1.0 - abs(t - 0.5) * 2.0
		edge_fade = clamp(edge_fade * 1.6, 0.0, 1.0)
		for x in width:
			image.set_pixel(x, y, Color(color.r, color.g, color.b, color.a * edge_fade))
	return ImageTexture.create_from_image(image)

func _make_radial_texture(size: int, color: Color) -> ImageTexture:
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center := size / 2.0
	for y in size:
		for x in size:
			var dist: float = Vector2(x - center, y - center).length() / center
			var falloff: float = clamp(1.0 - dist, 0.0, 1.0)
			image.set_pixel(x, y, Color(color.r, color.g, color.b, color.a * falloff))
	return ImageTexture.create_from_image(image)

func _setup_particles() -> void:
	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 25.0
	mat.initial_velocity_min = 80.0
	mat.initial_velocity_max = 140.0
	mat.gravity = Vector3(0, 60, 0)
	mat.scale_min = 0.6
	mat.scale_max = 1.2
	mat.color = Color(1.0, 0.85, 0.3)

	var image := Image.create(4, 4, false, Image.FORMAT_RGBA8)
	image.fill(Color(1, 1, 1, 1))
	var particle_texture := ImageTexture.create_from_image(image)

	sparkles.process_material = mat
	sparkles.texture = particle_texture
	sparkles.amount = 24
	sparkles.lifetime = 0.7
	sparkles.one_shot = true
	sparkles.emitting = false

func play() -> void:
	for beam in [glow_beam, core_beam]:
		beam.modulate.a = 0.0
		beam.scale.y = 0.15

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(glow_beam, "modulate:a", 1.0, 0.1)
	tween.tween_property(core_beam, "modulate:a", 1.0, 0.1)
	tween.tween_property(ground_glow, "modulate:a", 1.0, 0.15)
	tween.tween_property(glow_beam, "scale:y", 1.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(core_beam, "scale:y", 1.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	tween.chain().tween_interval(0.3)
	tween.chain().tween_property(glow_beam, "modulate:a", 0.0, 0.4)
	tween.parallel().tween_property(core_beam, "modulate:a", 0.0, 0.4)
	tween.parallel().tween_property(ground_glow, "modulate:a", 0.0, 0.4)

	sparkles.restart()
	sparkles.emitting = true
