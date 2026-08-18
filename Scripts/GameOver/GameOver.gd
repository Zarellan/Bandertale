extends Node2D
class_name GameOverScript

static var heartPos:Vector2
static var heartColor:Color

@export var heart:Sprite2D
@export var soulDebris:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	heart.position = heartPos
	heart.self_modulate = heartColor
	
	await get_tree().create_timer(1.2).timeout
	heart.get_node("AnimationPlayer").play("Broke")
	await get_tree().create_timer(1.2).timeout
	heart.visible = false
	for i in range (6):
		var s = InstantiateUtil.Instantiate(soulDebris,null)
		s.modulate = heart.self_modulate
		s.position = heart.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
