extends Node
class_name Attacks


var fightHandler:FightHandler
var attackTimer:float = 2
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	pass
func StartAttack():
	await get_tree().create_timer(attackTimer).timeout
	fightHandler.SetTurn(false)
	fightHandler.boxText.visible = true
	fightHandler.textDig.startDialogue("tames blaster",0.06)
	fightHandler.turns += 1
	queue_free()
	pass
