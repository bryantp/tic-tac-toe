class_name GameAI

static func ai_make_move(board_places: Array[GameSquare]) -> GameSquare:
	print("AI Making Move")
	var empty_board_indices: Array[int] = []
	# Gather all of the empty board spaces
	for i in range(board_places.size()):
		var board_piece = board_places[i]
		if(board_piece.current_marker_type == GameSquare.MARKER_TYPE.NONE):
			empty_board_indices.append(i)
			
	print("Found %s empty board pieces" % empty_board_indices.size())
	# Pick one at random
	var random_index = empty_board_indices[randi_range(0, empty_board_indices.size() - 1)]
	var chosen_board_piece = board_places[random_index]
	print("Chose index (%s,%s) as my board piece" % _get_xy_from_int(random_index))
	return chosen_board_piece
	
static func _get_xy_from_int(i: int) -> Array[int]:
	return [i / 3,i % 3]
