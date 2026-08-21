extends Area2D

var isTouching:bool = false
var fightHandler:FightHandler

func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isTouching:
		fightHandler.DamageSoul(3,0.02)
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
