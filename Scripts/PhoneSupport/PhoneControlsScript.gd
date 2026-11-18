extends Control
class_name PhoneControlsScript

var isPhone = true
@export var upButton:TouchScreenButton
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
		get_node("ScreenTouch").action_right = "ui_right"
		get_node("ScreenTouch").action_left = "ui_left"
func OnBlueSoul(dir:Soul.Direction):
	if isPhone:
		if dir == Soul.Direction.down || dir == Soul.Direction.up:
			get_node("ScreenTouch").action_up = "empty"
			get_node("ScreenTouch").action_down = "empty"
			get_node("ScreenTouch").action_right = "ui_right"
			get_node("ScreenTouch").action_left = "ui_left"
		else:
			get_node("ScreenTouch").action_up = "ui_up"
			get_node("ScreenTouch").action_down = "ui_down"
			get_node("ScreenTouch").action_right = "empty"
			get_node("ScreenTouch").action_left = "empty"
		match (dir):
			Soul.Direction.down:
				upButton.action = "ui_up"
			Soul.Direction.up:
				upButton.action = "ui_down"
			Soul.Direction.left:
				upButton.action = "ui_right"
			Soul.Direction.right:
				upButton.action = "ui_left"
