extends CanvasLayer

signal restart_game
signal quit_to_menu

@onready var label: Label = $PanelContainer/VBoxContainer/VBoxContainer/MessageLabel
@export var message: String

func _ready() -> void:
	label.text = message

func _on_retry_button_pressed() -> void:
	restart_game.emit()


func _on_back_to_menu_button_pressed() -> void:
	quit_to_menu.emit()
