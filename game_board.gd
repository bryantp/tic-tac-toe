extends Node

var grid_count_vertical = 3
var grid_count_horizontal = 3
var board_places: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var game_square_scene_resource: PackedScene = preload("res://game_square.tscn")
	var root_size = get_tree().root.size
	var game_square_height = root_size.y / grid_count_vertical
	var game_square_width = root_size.x / grid_count_horizontal

	var current_x = 0	
	var current_y = 0
	for i in range(0, grid_count_horizontal):
		current_y = 0
		for j in range(0, grid_count_vertical):
			var game_square_scene = game_square_scene_resource.instantiate()
			game_square_scene.position = Vector2(current_x,current_y)
			add_child(game_square_scene)
			var scale = Vector2(game_square_width / float(root_size.x), game_square_height / float(root_size.y))
			game_square_scene.set_scale(scale)
			current_y += game_square_height
		current_x += game_square_width
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
