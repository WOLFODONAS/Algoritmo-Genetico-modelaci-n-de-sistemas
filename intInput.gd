extends HBoxContainer
var value:int=0

@export var nameing:String
@export var maxVal:int
@export var minVal:int
@export var step:int =1
signal valueChanged(val:int)
func _ready() -> void:
	_on_value_pressed(0)
func _on_value_pressed(extra_arg_0: int) -> void:
	value += extra_arg_0*step
	if value>maxVal:
		value = maxVal
	if value<minVal:
		value = minVal
	$Label.text = nameing+": %s"%value
	emit_signal("valueChanged",value)
