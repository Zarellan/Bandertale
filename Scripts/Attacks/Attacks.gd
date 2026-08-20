extends Node
class_name Attacks


var fightHandler:FightHandler
var attackTimer:float = 2
var boxSize:Vector2 = Vector2(200,150)
var boxPos:Vector2 = Vector2(325,307)
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	pass
func PrepareAttack():
	pass
func StartAttack():
	await get_tree().create_timer(attackTimer).timeout
	if is_inside_tree():
		EndTurn()
	pass

func EndTurn():
	fightHandler.EndDefense()
	queue_free()
