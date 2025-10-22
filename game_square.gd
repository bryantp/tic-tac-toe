extends Area2D

func _ready() -> void:
	$Circle.visible = false
	queue_redraw()

func place_circle() -> void:
	$Circle.visible = true
	
func place_x() -> void:
	var color = Color.BLACK
	var width = 5
	var size = get_tree().root.size
	
	var lineOne = Line2D.new()
	lineOne.width = width
	lineOne.default_color = color
	lineOne.points = [
		Vector2(0, 0),
		Vector2(size.x, size.y)
	]
	
	add_child(lineOne)
	
	var lineTwo = Line2D.new()
	lineTwo.width = width
	lineTwo.default_color = color
	lineTwo.points = [
		Vector2(size.x, 0),
		Vector2(0, size.y),
	]
	
	add_child(lineTwo)
		
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		place_x()
