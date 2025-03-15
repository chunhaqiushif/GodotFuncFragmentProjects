extends CanvasLayer
@onready var cursor_sprite:Texture2D = load("res://RoleRes/Mouse.tres")
@onready var delay_cursor = $Cursor

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	self.visible = true
	Input.set_custom_mouse_cursor(cursor_sprite, Input.CURSOR_ARROW, Vector2(15,15))
	
#
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		delay_cursor.global_position = delay_cursor.get_global_mouse_position()
		
	
