extends CanvasLayer

@onready var label: Label = $PanelContainer/VBoxContainer/VBoxContainer/MessageLabel
@export var message: String

func _ready() -> void:
	label.text = message
