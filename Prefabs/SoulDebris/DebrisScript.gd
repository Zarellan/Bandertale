extends Sprite2D


var move:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move = Vector2(randf_range(-150,150),randf_range(-140,20))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += move * delta
	move.y += 100 * delta
	pass
