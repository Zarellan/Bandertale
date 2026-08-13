extends Node2D
class_name Text2D

@export var textRich:RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func ChangeText(tex,size):
	textRich.text = tex
	textRich.add_theme_font_size_override("normal_font_size", size)
