extends LineEdit

@export var add_button:Button
@export var sub_button:Button
@export var default:float
@export var param_min:float
@export var delta:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_button.connect("pressed", self.change_count.bind(delta))
	sub_button.connect("pressed", self.change_count.bind(-delta))
	self.text = str(default)


func change_count(delta_count: float) -> void:
	var count = float(self.text)
	count = count + delta_count
	if count < param_min:
		count = param_min
	self.text = str(count)
