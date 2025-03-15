class_name  FloatContextCreator
## 用于生成各种飘字效果

var _effect_type: EFFECT_TYPE ## 生成效果类型
var _speed:float ## 生成速度
var _delta:float ## 生成间隔时间
var _interval:int ## 生成间隔像素距离
var _life_time:float ## 单个飘动数字生命周期
var _parent_node:Node ## 父节点
var _mark_node:Marker2D ## 生成坐标标记结点

var _prefab_float_context = preload("res://FloatContext.tscn") ## 飘字预设
var _prefab_timer_tick = preload("res://FloatContextCreatorTimer_Tick.tscn") ## 飘字计时器预设
var _prefab_timer_flash = preload("res://FloatContextCreatorTimer_Flash.tscn") ## 字体闪烁计时器预设
var _font_xolonium = preload("res://Font/Xolonium.ttf") ## 飘字字体-xolonium


## 飘字效果类型
enum EFFECT_TYPE{
	ONLY_FLOAT = 0,
	ZOOM_AND_FLOAT = 1,
	COLOR_FLASH_AND_FLOAT = 2
}


## 初始化飘动数字效果
func init(effect_type: EFFECT_TYPE, speed:float, delta:float, interval:int, life_time:float, parent_node:Node, mark_node:Marker2D) -> void:
	_effect_type = effect_type
	_speed = speed
	_delta = delta
	_interval = interval
	_life_time = life_time
	_parent_node = parent_node
	_mark_node = mark_node
	
	
## 显示飘字效果
func show_effect(contexts:Array):
	var show_times = len(contexts)
	if show_times < 1:
		return
	if _delta > 0:
		var timer:Timer = _prefab_timer_tick.instantiate()
		timer.wait_time = _delta
		timer.trigger_count = show_times
		timer.one_shot = false
		timer.trigger_signal.connect(self._init_effect_obj)
		timer.init(contexts)
		_parent_node.add_child(timer)
		timer.start()
	elif _delta == 0:
		for i in range(show_times):
			_init_effect_obj(i, contexts[i])
	else:
		return
	
	
## 生成飘字obj
func _init_effect_obj(obj_index = 0, text:String = ""):
	var global_pos:Vector2i = _mark_node.global_position
	var obj = _prefab_float_context.instantiate()
	_parent_node.add_child(obj)
	obj.name = _get_damage_node_name(obj_index)
	obj.text = text
	
	## 将obj的轴心与目标点对齐
	var offset_x = -obj.size.x / 2
	var offset_y = -(obj.size.y / 2 + obj_index * _interval)
	obj.global_position = Vector2(global_pos.x + offset_x, global_pos.y + offset_y)
	
	match _effect_type:
		EFFECT_TYPE.ONLY_FLOAT:
			_effect_damage_A(obj)
		EFFECT_TYPE.ZOOM_AND_FLOAT:
			_effect_damage_B(obj)
		EFFECT_TYPE.COLOR_FLASH_AND_FLOAT:
			_effect_damage_C(obj)
		_:
			return
	
	
## 根据时间戳和索引获取生成obj时的名称	
func _get_damage_node_name(index:int = 0):
	var time = Time.get_time_string_from_system()
	var node_name = ""
	if index == 0:
		node_name = "FCtxt[%s]" % [time]
	else:
		node_name = "FCtxt[%s]_%d" % [time, index]
	return 	node_name
	
	
## 仅上浮飘字效果
func _effect_damage_A(obj: Label):
	var to_pos = Vector2(obj.position.x, obj.position.y - _speed * _life_time)
	var tween = obj.create_tween()
	tween.parallel().tween_property(obj, "position", to_pos, _life_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(obj, "theme_override_colors/font_color:a", 0.0, _life_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(obj, "theme_override_colors/font_outline_color:a", 0.0, _life_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	obj.queue_free()
	

## 缩放强调上浮飘字效果
func _effect_damage_B(obj: Label):
	var change_scale_mul = 1.3
	var change_scale_time = 0.1
	var to_pos = Vector2(obj.position.x, obj.position.y - _speed * _life_time)
	var tween = obj.create_tween().set_parallel(true)
	tween.tween_property(obj, "position", to_pos, _life_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(obj, "theme_override_colors/font_color:a", 0.0, _life_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(obj, "theme_override_colors/font_outline_color:a", 0.0, _life_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	var tween_2 = obj.create_tween().set_parallel(false)
	var ori_scale = obj.scale
	tween_2.tween_property(obj, "scale", ori_scale * change_scale_mul, change_scale_time).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween_2.tween_property(obj, "scale", ori_scale, change_scale_time).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	obj.queue_free()


## 上浮并闪烁文本效果
func _effect_damage_C(obj: Label):
	var flash_delte:float = 0.1
	var to_pos = Vector2(obj.position.x, obj.position.y - _speed * _life_time)
	var tween = obj.create_tween().set_parallel(true)
	tween.tween_property(obj, "position", to_pos, _life_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	var color_1 = Color.YELLOW
	obj.add_theme_color_override("font_color", color_1)
	var color_2 = Color.WHITE
	var flash_timer:Timer = _prefab_timer_flash.instantiate()
	flash_timer.wait_time = flash_delte
	flash_timer.autostart = false
	flash_timer.name = "flash_timer"
	flash_timer.init(obj, Color8(252,102,  0), Color8(249,254, 39))
	obj.add_child(flash_timer)
	flash_timer.trigger_signal.connect(_effect_font_color_change)
	flash_timer.start()
	await tween.finished
	flash_timer.stop()
	flash_timer.queue_free()
	obj.queue_free()
	
	
func _effect_font_color_change(obj:Label, to_color:Color):
	var old_color_a = obj.get_theme_color("font_color").a
	var new_color = Color(to_color, old_color_a)
	obj.add_theme_color_override("font_color", new_color)
