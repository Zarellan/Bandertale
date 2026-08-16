extends Node2D
class_name Enemy

@export var bubblePrefab:PackedScene
var fightHandler:FightHandler
var enemyName:String = "Bander"
var enemyHealth:int = 1
var attackPlaceOffset = Vector2(0,0)
var timeWhenAttackFinished:float = 0.9
var bubbleOffset = Vector2(50,0)
var enemyDialogue = false
var diag
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !enemyDialogue:
		return
	if Input.is_action_just_pressed("ActionCancel"):
		diag.get_node("Text").ForceFinish()
	if Input.is_action_just_pressed("ActionAccept") && diag.get_node("Text").finishedDial:
		diag.queue_free()
		fightHandler.StartAttacking()
		enemyDialogue = false
	pass

func GotAttacked():
	print("attack")

func PlayDialogue(textStr):
	diag = InstantiateUtil.Instantiate(bubblePrefab,null)
	diag.position = position + bubbleOffset
	await get_tree().process_frame
	diag.get_node("Text").startDialogue(textStr)
	enemyDialogue = true
	pass
