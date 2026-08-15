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

var health:int = 92

var isEnemyAttack:bool = false

var isMain:bool = false
var mainIndex:int = 0

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
	print(health)
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
		enemy.PlayDialogue("tames blaster")
		pass
	isEnemyAttack = shouldAttack
func StartAttacking():
	attacktest()
	
	await get_tree().create_timer(2).timeout
	SetTurn(false)
	boxText.visible = true
	textDig.startDialogue("tames blaster",0.06)
	print(textDig)
	turns += 1
	pass
func attacktest(): #will be removed once test succeed
	soul.ChangeSoulType(soul.SoulType.red)
	soul.position = box.position
	TweenUtils.tweenCustom(self,box.box_size,Vector2(200,200),0.3,TweenUtils.Ease.OutCirc,func(val):
		box.box_size = val)
	pass
func MainChoices(inc:int):
	mainIndex += inc
	OutBoundCheck(buttons)
	soul.position = buttons[mainIndex].position - Vector2(40,0)
	for i in range(buttons.size()):
		if i != mainIndex:
			buttons[i].texture = buttons[i].defaultButton
	buttons[mainIndex].texture = buttons[mainIndex].buttonChecked

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
	boxText.visible = true
	textDig.startDialogue(tex,0.06)
	soul.visible = false
	pressedAct = true
	
func ActProcess():
	if !pressedAct || waitAction:
		waitAction = false
		return
	if (Input.is_action_just_pressed("ActionCancel")):
		textDig.ForceFinish()
	if (Input.is_action_just_pressed("ActionAccept") && textDig.finishedDial):
		SetTurn(false)
		textDig.startDialogue(dialogue,0.06)
		pressedAct = false

var pressedItem = false

func IsItemed(tex:ItemData):
	boxText.visible = true
	textDig.startDialogue(tex.itemDescription,0.06)
	soul.visible = false
	pressedItem = true
	
func ItemProcess():
	if !pressedItem || waitAction:
		waitAction = false
		return
	if (Input.is_action_just_pressed("ActionCancel")):
		textDig.ForceFinish()
	if (Input.is_action_just_pressed("ActionAccept") && textDig.finishedDial):
		SetTurn(false)
		textDig.startDialogue(dialogue,0.06)
		pressedItem = false

func BackToMain():
	isMain = true
	boxText.visible = true
	textDig.text = dialogue
	MainChoices(0)
