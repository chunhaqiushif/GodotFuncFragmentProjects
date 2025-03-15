extends RayCast2D
@onready var cursor = $Cursor
var fading_begin_distance:float = 100
var fading_end_distance:float = 50

func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var distance = self.global_position.distance_to(mouse_position)
	if distance <= fading_begin_distance and distance > fading_end_distance:
		var color_alpha = 1 - (fading_begin_distance - distance) / fading_begin_distance / (fading_end_distance/fading_begin_distance)
		cursor.self_modulate.a = color_alpha
	elif distance <= fading_end_distance:
		cursor.self_modulate.a = 0
	else:
		cursor.self_modulate.a = 1
	var direction = (mouse_position - self.global_position).normalized()
	self.look_at(mouse_position)
	
