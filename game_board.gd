extends Node2D

var game_square_scene_resource: PackedScene = preload("res://game_square.tscn")
var main_menu_scene_resource: PackedScene = preload("res://main_menu.tscn")
var main_menu_scene

var grid_count_vertical = 3
var grid_count_horizontal = 3
var board_places: Array[GameSquare] = []

enum GAME_STATE {MAIN_MENU, SINGLE_PLAYER}
var current_game_state = GAME_STATE.MAIN_MENU

enum PLAYER_TURN {PLAYER_ONE, PLAYER_TWO}
var current_player_turn = PLAYER_TURN.PLAYER_ONE

func _process(delta: float) -> void:
	if current_player_turn == PLAYER_TURN.PLAYER_ONE:
		$InputBlockingRect.visible = false
		$InputBlockingRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else: #The AI has to make a move
		$InputBlockingRect.visible = true
		$InputBlockingRect.mouse_filter = Control.MOUSE_FILTER_STOP
		_ai_make_move()
		
func _ai_make_move():
	print("AI Making Move")
	var empty_board_indices: Array[int] = []
	# Gather all of the empty board spaces
	for i in range(board_places.size()):
		var board_piece = board_places[i]
		if(board_piece.current_marker_type == GameSquare.MARKER_TYPE.NONE):
			empty_board_indices.append(i)
			
	print("Found %s empty board pieces" % empty_board_indices.size())
	# Pick one at random
	var random_index = randi_range(0, empty_board_indices.size())
	var chosen_board_piece = board_places[random_index]
	print("Chose index (%s,%s) as my board piece" % _get_xy_from_int(random_index))
	# Place a cirle for now
	chosen_board_piece.place_circle()
	_handle_potential_win(_check_win())
	current_player_turn = PLAYER_TURN.PLAYER_ONE

func _draw() -> void: 
	if current_game_state == GAME_STATE.MAIN_MENU:
		_render_main_menu()
	else:
		_render_game_board()

func _render_main_menu() -> void:
	main_menu_scene = main_menu_scene_resource.instantiate()	
	add_child(main_menu_scene)
	main_menu_scene.selected_single_player.connect(_set_game_mode_single_player)

# Signal handler for menu button single player
func _set_game_mode_single_player() -> void:
	current_game_state = GAME_STATE.SINGLE_PLAYER
	main_menu_scene.hide()
	queue_redraw()

func _render_game_board() -> void:
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
			game_square_scene.player_choice_made.connect(_handle_player_choice_made)
			var scale = Vector2(game_square_width / float(root_size.x), game_square_height / float(root_size.y))
			game_square_scene.set_scale(scale)
			current_y += game_square_height
			print("Placing Board Piece")
			board_places.append(game_square_scene)
		current_x += game_square_width
		
func _handle_player_choice_made(marker_type: GameSquare.MARKER_TYPE) -> void:
	print("Got player choice %s" % marker_type)
	if current_player_turn != PLAYER_TURN.PLAYER_ONE:
		# This will have to change when we have multiplayer
		push_error("Player can't make a choice when it's not their turn, quitting game.")
		get_tree().quit()
	#We're going to have to stop player one from making choices here
	current_player_turn = PLAYER_TURN.PLAYER_TWO
	_handle_potential_win(_check_win())
	
func _handle_potential_win(markerType: GameSquare.MARKER_TYPE) -> void:
	print("Winning Marker %s" %  GameSquare.MARKER_TYPE.keys()[markerType])
	
func _check_win():
	# There are only 8 possible ways to win, manually check them all
	var did_win: GameSquare.MARKER_TYPE
	var horizontalTop: Array[GameSquare] = [_get_grid_at_xy(0,0), _get_grid_at_xy(1,0), _get_grid_at_xy(2,0)]
	did_win = _check_row_for_win(horizontalTop)
	if did_win != GameSquare.MARKER_TYPE.NONE:
		return did_win
		
	var horizontalMiddle: Array[GameSquare] = [_get_grid_at_xy(0,1), _get_grid_at_xy(1,1), _get_grid_at_xy(2,1)]
	did_win = _check_row_for_win(horizontalMiddle)
	if did_win != GameSquare.MARKER_TYPE.NONE:
		return did_win
		
	var horizontalBottom: Array[GameSquare] = [_get_grid_at_xy(0,2), _get_grid_at_xy(1,2), _get_grid_at_xy(2,2)]
	did_win = _check_row_for_win(horizontalBottom)
	if did_win != GameSquare.MARKER_TYPE.NONE:
		return did_win
	
	var verticalLeft: Array[GameSquare] = [_get_grid_at_xy(0,0), _get_grid_at_xy(0,1), _get_grid_at_xy(0,2)]
	did_win = _check_row_for_win(verticalLeft)
	if did_win != GameSquare.MARKER_TYPE.NONE:
		return did_win
		
	var verticalMiddle: Array[GameSquare] = [_get_grid_at_xy(1,0), _get_grid_at_xy(1,1), _get_grid_at_xy(2,1)]
	did_win = _check_row_for_win(verticalMiddle)
	if did_win != GameSquare.MARKER_TYPE.NONE:
		return did_win
		
	var verticalRight: Array[GameSquare] = [_get_grid_at_xy(2,0), _get_grid_at_xy(2,1), _get_grid_at_xy(2,2)]
	did_win = _check_row_for_win(verticalRight)
	if did_win != GameSquare.MARKER_TYPE.NONE:
		return did_win
	
	var diagRight: Array[GameSquare] = [_get_grid_at_xy(0,0), _get_grid_at_xy(1,1), _get_grid_at_xy(2,1)]
	did_win = _check_row_for_win(diagRight)
	if did_win != GameSquare.MARKER_TYPE.NONE:
		return did_win
		
	var diagLeft: Array[GameSquare] = [_get_grid_at_xy(2,0), _get_grid_at_xy(1,1), _get_grid_at_xy(0,2)]
	return _check_row_for_win(diagLeft)

func _check_row_for_win(row: Array[GameSquare]) -> GameSquare.MARKER_TYPE:
	var x_wins = row.reduce(func(count, next): return count + 1 if next.current_marker_type == GameSquare.MARKER_TYPE.X else count, 0)
	if x_wins == 3:
		return GameSquare.MARKER_TYPE.X
	
	var circle_wins = row.reduce(func(count, next): return count + 1 if next.current_marker_type == GameSquare.MARKER_TYPE.CIRCLE else count, 0)
	if circle_wins == 3:
		return GameSquare.MARKER_TYPE.CIRCLE
	
	return GameSquare.MARKER_TYPE.NONE
	
func _get_grid_at_xy(x: int, y: int) -> GameSquare:
	return board_places[y * 3 + x]
	
func _get_xy_from_int(i: int) -> Array[int]:
	return [i / 3,i % 3]
