extends Camera2D

@export var max_distance:float = 100
@export var min_distance:float = 30
@export var role:AnimatedSprite2D
var move_speed: float = 2

func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var role_position = role.global_position
	var distance = role_position.distance_to(mouse_position)
	
	var direction = (mouse_position - role_position).normalized()
	var real_distance = min(distance, max_distance)
	print(real_distance)
	if real_distance < min_distance:
		self.global_position = self.global_position.lerp(role.global_position, move_speed * delta)
	else:
		var target_position = calculate_target_position(role_position, direction, real_distance)
		self.global_position = self.global_position.lerp(target_position, move_speed * delta)
	
	
func calculate_target_position(start_position: Vector2, direction: Vector2, distance:float)->Vector2:
  	# 归一化方向向量
	var normalized_direction = direction.normalized()
	# 计算目标点坐标
	var target_position = start_position + normalized_direction * distance
	return target_position
	
	
