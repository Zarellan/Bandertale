extends Area2D

var isTouching:bool = false
var fightHandler:FightHandler

@export var textLabel:RichTextLabel
@export var collision:CollisionShape2D

var playerPos:Vector2
var gotHit
var heal = false
var deadly = false
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isTouching:
		if (deadly):
			fightHandler.DamageSoul(999999999,0.2)
		if (!heal):
			gotHit = fightHandler.DamageSoul(32,0.2)
		else:
			gotHit = fightHandler.HealSoul(30)
	if (gotHit):
		queue_free()
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		set_process(true)
		isTouching = true
	pass # Replace with function body.

func SetText(tex):
	textLabel.text = tex
	collision.shape.size = Vector2(textLabel.get_content_width(),textLabel.get_content_height())

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		set_process(false)
		isTouching = false
	pass # Replace with function body.
