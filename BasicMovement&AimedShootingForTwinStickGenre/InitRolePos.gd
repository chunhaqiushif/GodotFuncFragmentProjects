extends Node2D

@export var role:AnimatedSprite2D

func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size  # 返回一个 Vector2，表示视口的宽度和高度
	var center_point = Vector2i(int(viewport_size.x / 2), int(viewport_size.y / 2))
	role.position = center_point
	
