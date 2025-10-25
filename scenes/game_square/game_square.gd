extends Area2D

class_name GameSquare

signal player_choice_made(marker_type: MARKER_TYPE)

enum MARKER_TYPE {CIRCLE, X, NONE}
@export var current_marker_type: MARKER_TYPE = MARKER_TYPE.NONE

func _ready() -> void:
	current_marker_type = MARKER_TYPE.NONE
	$Circle.visible = false
	queue_redraw()

func place_circle() -> void:
	if current_marker_type != MARKER_TYPE.NONE:
		return	
	current_marker_type = MARKER_TYPE.CIRCLE
	if not $Circle.visible:
		$Circle.visible = true
	queue_redraw()
	
func place_x() -> void:
	if current_marker_type != MARKER_TYPE.NONE:
		return	
	
	current_marker_type = MARKER_TYPE.X
	var color = Color.BLACK
	var width = 5
	var size = get_tree().root.size
	
	var lineOne = Line2D.new()
	lineOne.name = "LineOne"
	lineOne.width = width
	lineOne.default_color = color
	lineOne.z_index = 1
	lineOne.points = [
		Vector2(0, 0),
		Vector2(size.x, size.y)
	]
	
	add_child(lineOne)
	
	var lineTwo = Line2D.new()
	lineTwo.name = "LineTwo"
	lineTwo.width = width
	lineTwo.default_color = color
	lineTwo.z_index = 1
	lineTwo.points = [
		Vector2(size.x, 0),
		Vector2(0, size.y),
	]
	
	add_child(lineTwo)
	queue_redraw()
		
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		if current_marker_type != MARKER_TYPE.NONE:
			return	
		print("Placing Mark on board")
		place_x()
		player_choice_made.emit(MARKER_TYPE.X)
