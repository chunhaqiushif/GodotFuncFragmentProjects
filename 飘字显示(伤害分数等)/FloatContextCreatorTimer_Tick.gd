extends Timer

@export var trigger_count:int
@export var trigger_index:int
var contexts:Array = []
signal trigger_signal


func _ready() -> void:
	self.timeout.connect(_on_show_effect_timer_timeout)
	trigger_index = 0


func init(p_contexts:Array) -> void:
	contexts = p_contexts
	trigger_count = len(contexts)


func _on_show_effect_timer_timeout():
	if trigger_index >= trigger_count:
		self.stop()
		self.queue_free()
		return
	trigger_signal.emit(trigger_index, contexts[trigger_index])
	trigger_index += 1


func set_timer_name(name: String):
	self.name = name
