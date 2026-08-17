extends Node2D
class_name FightHandler


@export var enemy:Enemy
#region customizeable
var dialogue = "hehe looool"

var turns = 0

var basedOfEnemyHealth = false # if false, you must make the enemy die on specific turn, else it's unbeatable
#endregion

static var waitAction = false #important to avoid race condition problem
@export var soul:Soul
@export var buttons:Array[Node2D]
@export var boxText:Node2D
@export var box:BoxHandler

#region healthManager
@export var healthBar:TextureProgressBar
@export var healthText:RichTextLabel
var health:int = 92
var maxHealth:int = 92
#endregion
#region EnemyManager
var isEnemyAttack:bool = false
var isMain:bool = false
var mainIndex:int = 0
#endregion
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#soul.ChangeSoulType(Soul.SoulType.blue)
	SetTurn(false)
	MainChoices(0)
	textDig.startDialogue(dialogue,0.06)
	pass # Replace with function body.


@export var textDig:TextAdv
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (isMain):
		if Input.is_action_just_pressed("ui_left"):
			MainChoices(-1)
		if Input.is_action_just_pressed("ui_right"):
			MainChoices(1)
		if Input.is_action_just_pressed("ActionAccept"):
			ActivateChoice()
		if Input.is_action_just_pressed("ActionCancel"):
			textDig.ForceFinish()
	healthBar.value = health
	healthText.text = str(health) + "/" + str(maxHealth)
	ActProcess()
	ItemProcess()
	pass

func SetTurn(shouldAttack):
	if !shouldAttack:
		isMain = true
		MainChoices(0)
		soul.FightEnd()
		TweenUtils.tweenCustom(self,box.box_size,Vector2(590.97,155.1),0.3,TweenUtils.Ease.OutCirc,func(val):
			box.box_size = val)
		soul.visible = true
	else:
		boxText.visible = false
		pass
	isEnemyAttack = shouldAttack
var attackData
func StartAttacking():
	attackData.StartAttack()
	pass
func ForceStartAttack(st:String):
	attackData = load(st).new() as Attacks
	add_child(attackData)
	soul.ChangeSoulType(soul.SoulType.idle)
	soul.position = box.position
	TweenUtils.tweenCustom(self,box.box_size,attackData.boxSize,0.3,TweenUtils.Ease.OutCirc,func(val):
		box.box_size = val)
	SetTurn(true)
	attackData.StartAttack()

func MainChoices(inc:int):
	mainIndex += inc
	OutBoundCheck(buttons)
	soul.position = buttons[mainIndex].position - Vector2(40,0)
	for i in range(buttons.size()):
		if i != mainIndex:
			buttons[i].texture = buttons[i].defaultButton
	buttons[mainIndex].texture = buttons[mainIndex].buttonChecked

var st = "res://Scripts/Attacks/AttackTypes/AttackTest.gd"

func EnemyDialogueStart(): #always start when ending player turn
	attackData = load(st).new() as Attacks
	add_child(attackData)
	soul.ChangeSoulType(soul.SoulType.idle)
	soul.position = box.position
	TweenUtils.tweenCustom(self,box.box_size,attackData.boxSize,0.3,TweenUtils.Ease.OutCirc,func(val):
		box.box_size = val)
	SetTurn(true)
	enemy.PlayDialogue(["tames hah haaah","lool loser"])
	
	#enemy.PlayDialogue("tames blaster")

func EnemyDialogueEnd():
	StartAttacking()

func EndDefense():
	SetTurn(false)
	boxText.visible = true
	textDig.startDialogue("tames blaster",0.06)
	turns += 1

func CleanChoices():
	for i in range(buttons.size()):
		buttons[i].texture = buttons[i].defaultButton

func ActivateChoice():
	if (!buttons[mainIndex].Allowed()):
		return
	buttons[mainIndex].waitAction = true
	buttons[mainIndex].Activate()
	isMain = false
	boxText.visible = false
func OutBoundCheck(sizeArr:Array):
	if (mainIndex > sizeArr.size()-1):
		mainIndex = 0
	if (mainIndex < 0):
		mainIndex = sizeArr.size()-1
	pass

var pressedAct = false

func IsActed(tex):
	pressedAct = true
	ActActionType(tex)

func ActProcess():
	if !pressedAct || waitAction:
		waitAction = false
		return
	if (Input.is_action_just_pressed("ActionCancel")):
		textDig.ForceFinish()
	if (Input.is_action_just_pressed("ActionAccept") && textDig.finishedDial):
		if (BoxDialogueArrayCheck()):
			pressedAct = false

var pressedItem = false
func IsItemed(tex:ItemData):
	pressedItem = true
	ItemActionType(tex.itemName)

func ItemProcess():
	if !pressedItem || waitAction:
		waitAction = false
		return
	if (Input.is_action_just_pressed("ActionCancel")):
		textDig.ForceFinish()
	if (Input.is_action_just_pressed("ActionAccept") && textDig.finishedDial):
		if (BoxDialogueArrayCheck()):
			pressedItem = false

var indexDial = 0
var diagTemp:Array

func BattleDialogueEncounter(st:Array):
	if (st.is_empty()):
		EnemyDialogueStart()
		return
	indexDial = 0
	diagTemp = st
	boxText.visible = true
	textDig.startDialogue(diagTemp[indexDial],0.06)
	soul.visible = false

func BoxDialogueArrayCheck():
	if (diagTemp.size()-1 <= indexDial):
		EnemyDialogueStart()
		return true
	else:
		indexDial += 1
		textDig.startDialogue(diagTemp[indexDial],0.06)
		return false

func BackToMain():
	isMain = true
	boxText.visible = true
	textDig.ForceFinish()
	MainChoices(0)

# customizeable functions
func ActActionType(st:String):
	match (st):
		"hello":BattleDialogueEncounter(["you said hello","you said hello[speed,1]...[speed,0.06]yeah"])
		_:
			pressedAct = false
			EnemyDialogueStart()
	pass

func ItemActionType(st:String):
	match (st):
		"L hero":
			BattleDialogueEncounter(["you ate l hero"])
		_:
			pressedItem = false
			EnemyDialogueStart()
	pass
