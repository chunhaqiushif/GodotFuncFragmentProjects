extends Timer

@export var trigger_index:int
signal trigger_signal
@export var obj:Label
@export var color_0:Color
@export var color_1:Color


func init(p_obj:Label, p_color_0:Color, p_color_1:Color) -> void:
	obj = p_obj
	color_0 = p_color_0
	color_1 = p_color_1
	

func _ready() -> void:
	self.timeout.connect(_on_show_effect_timer_timeout)


func _on_show_effect_timer_timeout() -> void:
	var type = trigger_index % 2
	if type == 0:
		trigger_signal.emit(obj, color_0)
	elif type == 1:
		trigger_signal.emit(obj, color_1)
	else:
		return
	trigger_index += 1
