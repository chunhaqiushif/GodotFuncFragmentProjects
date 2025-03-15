extends Button

@export var damage_option_btn:OptionButton ##飘字选项
@export var damage_count_input:LineEdit
@export var effect_speed_input:LineEdit
@export var effect_delta:LineEdit
@export var effect_life_time_input:LineEdit
@export var effect_interval:LineEdit
@export var font_option:OptionButton
@export var create_to_node:Node
@export var create_to_mark:Marker2D
var FCC = FloatContextCreator.new()

func _ready() -> void:
	self.pressed.connect(_on_pressed_button)


## 获取飘字显示类型文本
func get_damage_type_text():
	return damage_option_btn.get_item_text(damage_option_btn.get_selected_id()) 
	
	
## 获取飘字显示类型id	
func get_damage_type_id():
	return damage_option_btn.get_selected_id() 


## 获取单次飘字数量
func get_effect_count_one_time() -> int:
	return int(damage_count_input.text)
	
	
## 获取多次飘字的像素间隔
func get_effect_interval() -> int:
	return int(effect_interval.text)


## 获取单次中多个数量飘字的间隔时间	
func get_effect_delta()	-> float:
	return float(effect_delta.text)

	
## 获取飘字速度
func get_effect_speed() -> float:
	return float(effect_speed_input.text)
	
	
## 获取飘字时间	
func get_effect_life_time()	-> float:
	return float(effect_life_time_input.text)


func _create_random_num_context() -> String:
	randomize()
	var num = str(randi_range(1, 10000000))
	return num


func _on_pressed_button():
	var type = get_damage_type_id()
	var count = get_effect_count_one_time()
	var interval = get_effect_interval()
	var delta = get_effect_delta()
	var speed = get_effect_speed()
	var life_time = get_effect_life_time()
	
	
	var pos = create_to_mark.position
	var prefix_arr = ["", "+", "-", "!"]
	var prefix = prefix_arr[randi_range(0, len(prefix_arr) - 1)]
	var contexts = []
	
	for i in range(0, count):
		var context = prefix + _create_random_num_context()
		contexts.append(context)
		
	FCC.init(type, speed, delta, interval, life_time, create_to_node, create_to_mark)
	FCC.show_effect(contexts)
	
