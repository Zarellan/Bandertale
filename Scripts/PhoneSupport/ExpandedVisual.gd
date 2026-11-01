extends Control

func _ready() -> void:
	resized.connect(_on_resized)

func _on_resized() -> void:
	# Force the width to always match the height, keeping a 1:1 square
	custom_minimum_size.x = size.y
