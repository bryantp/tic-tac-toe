extends CanvasLayer

signal selected_single_player
signal selected_leaderboard
signal selected_multiplayer
signal selected_settings

func _on_single_player_button_pressed() -> void:
	selected_single_player.emit()

func _on_leaderboard_pressed() -> void:
	selected_leaderboard.emit()

func _on_multiplayer_button_pressed() -> void:
	selected_multiplayer.emit()	

func _on_quit_button_pressed() -> void:
	pass # Replace with function body.

func _on_settings_button_pressed() -> void:
	selected_settings.emit()
