extends Control

@export var segment_count: int = 20
@export var tick_color: Color = Color(0, 0, 0, 0.45)
@export var tick_width: float = 1.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)

func _draw() -> void:
	for i in range(1, segment_count):
		var x = size.x * (float(i) / segment_count)
		draw_line(Vector2(x, 0), Vector2(x, size.y), tick_color, tick_width)
