extends Control

var topIndv:Array[int]
var worstIndv:Array[int]
var maxF:int = -1


func _on_resized() -> void:
	queue_redraw()
func set_info(_topIndv:Array[int],_worstIndv:Array[int],_maxF:int):
	topIndv = _topIndv
	worstIndv = _worstIndv
	maxF = _maxF
	queue_redraw()
func _draw() -> void:
	var startPoint = Vector2.ONE*30
	
	var endPoint = size-(startPoint*2)
	draw_rect(Rect2(startPoint,endPoint),Color.DARK_SLATE_GRAY)
	var pasPos = Vector2(startPoint.x,startPoint.y+endPoint.y)
	draw_string(get_theme_default_font(),startPoint-(Vector2(0,5)),"Max fitness: "+str(maxF))
	var gener = "Generations :%s"%topIndv.size()
	draw_string(get_theme_default_font(),endPoint+Vector2(-gener.length()*6,startPoint.y+16),gener)
	if not maxF == -1:
		
		for i in topIndv.size():
			var x:float = endPoint.x * (float(i)/(topIndv.size()-1))
			var y:float = endPoint.y * (float(topIndv[i])/maxF)
			var currentPos = Vector2(startPoint.x +x,startPoint.y+endPoint.y-y)
			draw_circle(currentPos,3,Color.DARK_BLUE)
			draw_line(pasPos,
			currentPos,
			Color.GREEN if currentPos.y<pasPos.y else Color.RED)
			pasPos = currentPos
		pasPos = Vector2(startPoint.x,startPoint.y+endPoint.y)
		for i in worstIndv.size():
			var x:float = endPoint.x * (float(i)/(worstIndv.size()-1))
			var y:float = endPoint.y * (float(worstIndv[i])/maxF)
			var currentPos = Vector2(startPoint.x +x,startPoint.y+endPoint.y-y)
			draw_circle(currentPos,3,Color.DARK_RED)
			draw_line(pasPos,
			currentPos,
			Color.GREEN if currentPos.y<pasPos.y else Color.RED)
			pasPos = currentPos
