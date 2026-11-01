extends Control

var upPressed:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_overlap_touch_touched() -> void:
	Input.action_press("ui_up")
	Input.action_press("jump")
	upPressed = true
	pass # Replace with function body.


func _on_overlap_touch_untouched() -> void:
	if (!upPressed):
		return
	Input.action_release("ui_up")
	Input.action_release("jump")
	upPressed = false
	pass # Replace with function body.


func _on_touch_screen_button_pressed() -> void:
	Input.action_press("jump")
	pass # Replace with function body.


func _on_touch_screen_button_released() -> void:
	Input.action_release("jump")
	pass # Replace with function body.
