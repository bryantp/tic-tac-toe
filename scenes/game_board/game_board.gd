extends Node2D

@onready var game_node: Node = %GameNode
@onready var game_over_menu_node: Node = %GameOverMenuNode

var game_square_scene_resource: PackedScene = preload("res://scenes/game_square/game_square.tscn")
var main_menu_scene_resource: PackedScene = preload("res://scenes/main_menu/main_menu.tscn")
var game_over_scene_resource: PackedScene = preload("res://scenes/game_over/game_over.tscn")
var main_menu_scene

var grid_count_vertical = 3
var grid_count_horizontal = 3
var board_places: Array[GameSquare] = []

enum GAME_STATE {MAIN_MENU, SINGLE_PLAYER, GAME_OVER, MULTI_PLAYER}
var current_game_state = GAME_STATE.MAIN_MENU

enum PLAYER_TURN {PLAYER_ONE, PLAYER_TWO}
var current_player_turn = PLAYER_TURN.PLAYER_ONE

var win_condition_check: WinConditionCheck

func _process(delta: float) -> void:
	if current_game_state != GAME_STATE.GAME_OVER:
		if current_player_turn == PLAYER_TURN.PLAYER_ONE:
			$InputBlockingRect.visible = false
			$InputBlockingRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else: #The AI has to make a move
			$InputBlockingRect.visible = true
			$InputBlockingRect.mouse_filter = Control.MOUSE_FILTER_STOP
			_ai_make_move()
		
func _ai_make_move():
	var chosen_board_piece = GameAI.ai_make_move(board_places)
	chosen_board_piece.place_circle()
	_handle_potential_win(win_condition_check.check_win())
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
			game_node.add_child(game_square_scene)
			game_square_scene.player_choice_made.connect(_handle_player_choice_made)
			var scale = Vector2(game_square_width / float(root_size.x), game_square_height / float(root_size.y))
			game_square_scene.set_scale(scale)
			current_y += game_square_height
			print("Placing Board Piece")
			board_places.append(game_square_scene)
		current_x += game_square_width
	win_condition_check = WinConditionCheck.new(board_places)
		
func _handle_player_choice_made(marker_type: GameSquare.MARKER_TYPE) -> void:
	print("Got player choice %s" % marker_type)
	if current_player_turn != PLAYER_TURN.PLAYER_ONE:
		# This will have to change when we have multiplayer
		push_error("Player can't make a choice when it's not their turn, quitting game.")
		get_tree().quit()
	#We're going to have to stop player one from making choices here
	current_player_turn = PLAYER_TURN.PLAYER_TWO
	_handle_potential_win(win_condition_check.check_win())
	
func _handle_potential_win(winCondition: WinConditionCheck.WinCondition) -> void:
	if winCondition == WinConditionCheck.WinCondition.NONE:
		return
	print("Winning Marker %s" %  WinConditionCheck.WinCondition.keys()[winCondition])
	var game_over = game_over_scene_resource.instantiate()
	game_over.restart_game.connect(_restart_game)
	game_over.quit_to_menu.connect(_quit_to_menu)
	if winCondition == WinConditionCheck.WinCondition.X:
		game_over.message = "You won!"
	elif winCondition == WinConditionCheck.WinCondition.CIRCLE:
		game_over.message = "You lost"
	else:
		game_over.message = "It was a tie"
	
	game_over_menu_node.add_child(game_over)
	current_game_state = GAME_STATE.GAME_OVER
	
func _restart_game() -> void:
	_wipe_game_board()
	current_game_state = GAME_STATE.SINGLE_PLAYER
	
func _quit_to_menu() -> void:
	main_menu_scene.show()
	current_game_state = GAME_STATE.MAIN_MENU
	_wipe_game_board()
	
func _wipe_game_board() -> void:
	board_places.clear()
	for child in game_node.get_children():
		child.queue_free()
		
	for child in game_over_menu_node.get_children():
		child.queue_free()
	queue_redraw()
