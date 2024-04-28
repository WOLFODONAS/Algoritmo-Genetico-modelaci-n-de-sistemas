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
	var maxX = 0
	var maxY = 0
	var ltSize = int(float(sqS/2.0))
	var endPoint = Vector2.ONE*sqS
	draw_string(get_theme_default_font(),Vector2(0,ltSize),"Input Matrix",HORIZONTAL_ALIGNMENT_CENTER,-1,ltSize)
	for i in startMatrix.size():
		for j in startMatrix[i].length():
			var startPoint = Vector2(j,i+1)*sqS
			
			
			draw_rect(Rect2(startPoint,endPoint),Color.RED,false,4)
			draw_char(get_theme_default_font(),startPoint+ (endPoint/2)+(Vector2(-0.25,0.5)*ltSize),startMatrix[i][j],ltSize)
	var endStartM:int = startMatrix.size()+2
	draw_string(get_theme_default_font(),Vector2(0,endStartM)*sqS*0.95,"Output Matrix",HORIZONTAL_ALIGNMENT_FILL,-1,ltSize)
	for i in endMatrix.size():
		for j in endMatrix[i].length():
			var startPoint = (Vector2(j,i+endStartM)*sqS) 
			if endPoint.x+startPoint.x>maxX:
				maxX = endPoint.x+startPoint.x
			if endPoint.y+startPoint.y>maxY:
				maxY = endPoint.y+startPoint.y
			draw_rect(Rect2(startPoint,endPoint),Color.LAWN_GREEN,false,4)
			draw_char(get_theme_default_font(),startPoint+ (endPoint/2)+(Vector2(-0.25,0.5)*ltSize),endMatrix[i][j],ltSize)
	get_parent().size= Vector2(maxX,maxY)



func _on_squere_size_value_changed(val)-> void:
	sqS = val
	if endMatrix != null:
		queue_redraw()
