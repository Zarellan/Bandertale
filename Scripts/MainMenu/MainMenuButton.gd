extends Node2D
class_name MainMenuButton

var startPosY
var deltatime = 0.0
var defPos = 0
func _ready() -> void:
	startPosY = randf_range(-20,20)
	defPos = global_position.y
	
func _process(delta: float) -> void:
	deltatime += delta
	global_position.y = defPos + sin((deltatime*2) + startPosY) * 2

func ActiveButton():
	pass

func OverlappedButton():
	pass

func UnOverlappedButton():
	pass
