extends Node2D
var padding = 15 # Border with + Circle stroke width

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
	
func _draw() -> void:
	var size = get_tree().root.size
	draw_circle(Vector2(size.x/2, size.y/2),(size.x / 2) - 15 , Color.BLACK, false, 10)
