extends Node2D
class_name Enemy

@export var bubblePrefab:PackedScene
var fightHandler:FightHandler
var enemyName:String = "Bander"
var enemyHealth:int = 1
var attackPlaceOffset = Vector2(0,0)
var timeWhenAttackFinished:float = 0.9
var bubbleOffset = Vector2(150,-60)
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
		if (BoxDialogueArrayCheck()):
			enemyDialogue = false
	pass

var tw:Tween
func GotAttacked():
	tw = TweenUtils.tweenX(get_node("Sprite2D"),-120,0.6,TweenUtils.Ease.OutCirc)
	tw.finished.connect(func():
		await get_tree().create_timer(0.2).timeout
		TweenUtils.tweenX(get_node("Sprite2D"),0,0.6,TweenUtils.Ease.InSine))

var indexDialogue = 0
var dialogueArr
func PlayDialogue(textStr:Array):
	if (textStr.is_empty()):
		fightHandler.EnemyDialogueEnd()
		return
	indexDialogue = 0
	dialogueArr = textStr
	diag = InstantiateUtil.Instantiate(bubblePrefab,null)
	diag.position = position + bubbleOffset
	await get_tree().process_frame
	diag.get_node("Text").startDialogue(textStr[indexDialogue])
	enemyDialogue = true
	pass

func BoxDialogueArrayCheck():
	if (dialogueArr.size()-1 <= indexDialogue):
		diag.queue_free()
		fightHandler.EnemyDialogueEnd()
		return true
	else:
		indexDialogue += 1
		diag.get_node("Text").startDialogue(dialogueArr[indexDialogue],0.06)
		return false
