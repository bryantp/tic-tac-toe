class_name WinConditionCheck

var board_places: Array[GameSquare]

func _init(board_places) -> void:
	self.board_places = board_places

func check_win() -> GameSquare.MARKER_TYPE:
	var win_patterns = [
		# Rows
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)],
		[Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)],
		[Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2)],
		# Columns
		[Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2)],
		[Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)],
		[Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2)],
		# Diagonals
		[Vector2i(0, 0), Vector2i(1, 1), Vector2i(2, 2)],
		[Vector2i(2, 0), Vector2i(1, 1), Vector2i(0, 2)]
	]

	for pattern in win_patterns:
		var squares: Array[GameSquare] = []
		for pos in pattern:
			squares.append(_get_grid_at_xy(pos.x, pos.y))
		var result = _check_row_for_win(squares)
		if result != GameSquare.MARKER_TYPE.NONE:
			return result

	return GameSquare.MARKER_TYPE.NONE

func _check_row_for_win(row: Array[GameSquare]) -> GameSquare.MARKER_TYPE:
	var first_marker = row[0].current_marker_type

	# All three must match, and not be NONE
	if first_marker != GameSquare.MARKER_TYPE.NONE \
			and row.all(func(cell): return cell.current_marker_type == first_marker):
		return first_marker

	return GameSquare.MARKER_TYPE.NONE
	
func _get_grid_at_xy(x: int, y: int) -> GameSquare:
	return board_places[y * 3 + x]
