extends Node2D
class_name FightHandler

@export var soul:Soul
@export var buttons:Array[Node2D]

var isEnemyAttack:bool = false

var isMain:bool = true
var mainIndex:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	soul.ChangeSoulType(Soul.SoulType.blue)
	SetTurn(false)
	MainChoices(0)
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
		if Input.is_action_just_pressed("ui_down"):
			textDig.startDialogue("hehe looool",0.06)
	pass

func SetTurn(shouldAttack):
	if !shouldAttack:
		soul.FightEnd()
	else:
		pass
	isEnemyAttack = shouldAttack

func MainChoices(inc:int):
	mainIndex += inc
	OutBoundCheck(buttons)
	soul.position = buttons[mainIndex].position - Vector2(40,0)
	for i in range(buttons.size()):
		if i != mainIndex:
			buttons[i].texture = buttons[i].defaultButton
	buttons[mainIndex].texture = buttons[mainIndex].buttonChecked

func ActivateChoice():
	buttons[mainIndex].Activate()
	isMain = false
func OutBoundCheck(sizeArr:Array):
	if (mainIndex > sizeArr.size()-1):
		mainIndex = 0
	if (mainIndex < 0):
		mainIndex = sizeArr.size()-1
	pass

func BackToMain():
	isMain = true
	MainChoices(0)
