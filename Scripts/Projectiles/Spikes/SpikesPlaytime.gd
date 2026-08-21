extends Area2D
class_name SpikesPlaytime

var isTouching:bool = false
var fightHandler:FightHandler

@export var sprite:Sprite2D
static var gotHit:bool = false
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isTouching:
		if (fightHandler.DamageSoul(0,0)): # hardcode: check if it can deflect damage and avoid race condition
			gotHit = fightHandler.DamageSoul(40,1)
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		set_process(true)
		isTouching = true
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		set_process(false)
		isTouching = false
	pass # Replace with function body.
