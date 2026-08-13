extends Node
class_name Buttons

@export var defaultButton:Texture2D
@export var buttonChecked:Texture2D

var fightHandler:FightHandler

@onready var textPrefab:PackedScene = load("res://Prefabs/Text2D/TextWorld2D.tscn")
# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler") as FightHandler
	pass # Replace with function body.	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func Activate():
	print("here")
