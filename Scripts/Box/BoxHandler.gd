@tool
extends Node2D
class_name BoxHandler

@export var boxRight: Node2D
@export var boxLeft: Node2D
@export var boxUp: Node2D
@export var boxDown: Node2D
@export var clipOnly: Node2D

# The inner playing area size of the box
@export var box_size: Vector2 = Vector2(200, 100):
	set(value):
		box_size = value
		_update_box()

# Thickness of the border walls
@export var border_size: float = 8.0:
	set(value):
		border_size = value
		_update_box()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_box()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _update_box() -> void:
	var half_w = box_size.x / 2.0
	var half_h = box_size.y / 2.0
	var half_border = border_size / 2.0

	# 1. Position the 4 boxes so they form a continuous frame without outside line artifacts
	# Top and Bottom span the full width plus the corners, aligned with the inner height bounds
	if boxUp:
		boxUp.position = Vector2(0, -half_h - half_border)
	if boxDown:
		boxDown.position = Vector2(0, half_h + half_border)

	# Left and Right sit strictly between the top and bottom borders
	if boxLeft:
		boxLeft.position = Vector2(-half_w - half_border, 0)
	if boxRight:
		boxRight.position = Vector2(half_w + half_border, 0)

	# 2. Scale the boxes using 32.0 as the base pixel size
	# Top/Bottom: width spans full box size + 2 full borders, thickness equals border_size
	var total_width = box_size.x + (border_size * 2.0)
	if boxUp:
		boxUp.scale.x = total_width / 32.0
		boxUp.scale.y = border_size / 32.0
	if boxDown:
		boxDown.scale.x = total_width / 32.0
		boxDown.scale.y = border_size / 32.0

	# Left/Right: height equals inner box_size, thickness equals border_size
	if boxLeft:
		boxLeft.scale.x = border_size / 32.0
		boxLeft.scale.y = box_size.y / 32.0
	if boxRight:
		boxRight.scale.x = border_size / 32.0
		boxRight.scale.y = box_size.y / 32.0
	if clipOnly:
		clipOnly.position = Vector2.ZERO
		clipOnly.scale.x = box_size.x / 32.0
		clipOnly.scale.y = box_size.y / 32.0
# Position X of the outer right corner/edge
func GetGlobalRight() -> float:
	return (box_size.x / 2.0) + border_size
func GetRightCorner() -> float:
	return global_position.x + GetGlobalRight()

func GetGlobalLeft() -> float:
	return -(box_size.x / 2.0) - border_size
func GetLeftCorner() -> float:
	return global_position.x + GetGlobalLeft()


func GetGlobalDown() -> float:
	return (box_size.y / 2.0) + border_size
func GetDownCorner() -> float:
	return global_position.y + GetGlobalDown()

func GetGlobalUp() -> float:
	return -(box_size.y / 2.0) - border_size
func GetUpCorner() -> float:
	return global_position.y + GetGlobalUp()
