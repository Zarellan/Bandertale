extends Control
class_name PhoneControlsScript

var isPhone = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!DeviceCheckerUtil.IsUsingPhone()):
		get_node("ScreenTouch").queue_free()
		get_node("BottonRight").queue_free()
		isPhone = false
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func OnOtherSoul():
	if isPhone:
		get_node("ScreenTouch").action_up = "ui_up"
		get_node("ScreenTouch").action_down = "ui_down"

func OnBlueSoul():
	if isPhone:
		get_node("ScreenTouch").action_up = "empty"
		get_node("ScreenTouch").action_down = "empty"
