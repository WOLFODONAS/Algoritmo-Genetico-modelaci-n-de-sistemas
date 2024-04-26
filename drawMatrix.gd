extends Control


var startMatrix:Array[String]
var endMatrix:Array[String]
var sqS:int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_info(_startMatrix:Array[String],_endMatrix:Array[String]) ->void:
	startMatrix = _startMatrix
	endMatrix = _endMatrix
	queue_redraw()

func _draw() -> void:
	for i in startMatrix.size():
		for j in startMatrix[i].length():
			var startPoint = Vector2(j,i)*sqS
			var endPoint = Vector2.ONE*sqS
			var ltSize = int(float(sqS/2.0))
			draw_rect(Rect2(startPoint,endPoint),Color.RED,false,4)
			draw_char(get_theme_default_font(),startPoint+ (endPoint/2),startMatrix[i][j],ltSize)
	var endStartM:int = startMatrix.size()+1
	for i in endMatrix.size():
		for j in endMatrix[i].length():
			var startPoint = (Vector2(j,i+endStartM)*sqS) 
			var endPoint = Vector2.ONE*sqS
			var ltSize = int(float(sqS/2.0))
			draw_rect(Rect2(startPoint,endPoint),Color.LAWN_GREEN,false,4)
			draw_char(get_theme_default_font(),startPoint+ (endPoint/2),endMatrix[i][j],ltSize)




func _on_squere_size_value_changed(val)-> void:
	sqS = val
	if endMatrix != null:
		queue_redraw()
