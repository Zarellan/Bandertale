extends Node2D
class_name FightHandler


var attacks = ["res://Scripts/Attacks/AttackTypes/Attack1.gd", "res://Scripts/Attacks/AttackTypes/Attack2.gd"]
var dialogue = ["bander is fighting you", "dodged att"]
var enemyDialogueToPlay = [""]

@export var enemy:Enemy

@export var camera:Camera2D

#region DebugMode
var undye = false
#endregion
#region customizeable

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

var firstAttackSpec:bool = false #I was stuck so I used hardcode method
var fighted = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Engine.time_scale = 15
	#SetTurn(false)
	#MainChoices(0)
	#textDig.startDialogue(dialogue[turns],0.06,"res://Sounds/Dialogues/Text2.wav", 4)
	#GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/EnemyApproach.ogg")
	HealSoul(0)
	#ForceStartAttack("res://Scripts/Attacks/AttackTypes/Attack2.gd")
	Engine.time_scale = 40
	Engine.max_fps = 60
	undye = true
	ForceStartAttack("res://Scripts/Attacks/AttackTypes/FirstAttack.gd")
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
		TweenUtils.tweenX(box,325.0,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.tweenY(box,307.0,0.3,TweenUtils.Ease.OutCirc)
		soul.visible = true
	else:
		boxText.visible = false
		pass
	isEnemyAttack = shouldAttack
var attackData
func StartAttacking(): # WARNING: if you want instant attack, use ForceStartAttack instead
	if (!attackData):
		print("no attack exist")
		EndDefense()
		textDig.startDialogue("[color=red]SYSTEM WARNING[color=white]: no attack applied",0.06)
		return
	attackData.StartAttack()
	pass
func ForceStartAttack(st:String):
	attackData = load(st).new() as Attacks
	attackData.fightHandler = self
	add_child(attackData)
	attackData.PrepareAttack()
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
	if (inc != 0):
		SqueakAudio()
	pass
var st = "res://Scripts/Attacks/AttackTypes/AttackTest.gd"
var att = false
func EnemyDialogueStart(): #always start when ending player turn
	if (fighted):
		if (att):
			turns += 1
	att = true
	attackData = load(attacks[turns]).new() as Attacks
	attackData.fightHandler = self
	add_child(attackData)
	attackData.PrepareAttack()
	soul.ChangeSoulType(soul.SoulType.idle)
	soul.position = box.position
	TweenUtils.tweenCustom(self,box.box_size,attackData.boxSize,0.3,TweenUtils.Ease.OutCirc,func(val):
		box.box_size = val)
	TweenUtils.tweenX(box,attackData.boxPos.x,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(box,attackData.boxPos.y,0.3,TweenUtils.Ease.OutCirc)
	SetTurn(true)
	if (fighted):
		EnemyAttacksDials(turns)
		fighted = false
	enemy.PlayDialogue(enemyDialogueToPlay)
	
	#enemy.PlayDialogue("tames blaster")

func EnemyDialogueEnd():
	if (!firstAttackSpec):
		attackData.queue_free()
		textDig.startDialogue(dialogue[turns],0.06,"res://Sounds/Dialogues/Text2.wav", 4)
		EndDefense(false)
		firstAttackSpec = true
	else:
		StartAttacking()

func EndDefense(incTurn:bool = false):
	SetTurn(false)
	boxText.visible = true
	textDig.startDialogue(dialogue[turns],0.04,"res://Sounds/Dialogues/Text2.wav", 4)
	if (turns == 1):
		firstAttackSpec = true
	if (incTurn):
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
	SelectAudioSound()

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

var pressedMercy = false
func IsMercy(tex:ItemData):
	pressedMercy = true
	MercyAction()

func MercyProcess():
	if !pressedMercy || waitAction:
		waitAction = false
		return
	if (Input.is_action_just_pressed("ActionCancel")):
		textDig.ForceFinish()
	if (Input.is_action_just_pressed("ActionAccept") && textDig.finishedDial):
		if (BoxDialogueArrayCheck()):
			pressedMercy = false

var indexDial = 0
var diagTemp:Array

func BattleDialogueEncounter(st:Array):
	if (st.is_empty()):
		EnemyDialogueStart()
		return
	indexDial = 0
	diagTemp = st
	boxText.visible = true
	textDig.startDialogue(diagTemp[indexDial],0.04, "res://Sounds/Dialogues/Text2.wav",4)
	soul.visible = false

func BoxDialogueArrayCheck():
	if (diagTemp.size()-1 <= indexDial):
		EnemyDialogueStart()
		return true
	else:
		indexDial += 1
		textDig.startDialogue(diagTemp[indexDial],0.06, "res://Sounds/Dialogues/Text2.wav",4)
		return false

func BackToMain():
	isMain = true
	boxText.visible = true
	textDig.ForceFinish()
	MainChoices(0)

func HealSoul(healValue:int):
	health = clamp(health+healValue,0,maxHealth)
	healthBar.value = health
	healthText.text = str(health) + "/" + str(maxHealth)
	if (healValue != 0):
		GlobalAudio.PlayOneShot("res://Sounds/Fight/Heal.wav",0)

func DamageSoul(damageValue:int):
	if (undye):
		return
	health = max(health-damageValue,0)
	healthBar.value = health
	healthText.text = str(health) + "/" + str(maxHealth)
	if (damageValue != 0):
		GlobalAudio.PlayOneShot("res://Sounds/Fight/Hurt.wav",-3)
	if (health <= 0):
		GameOver()
func GameOver():
	get_tree().paused = true
	GameOverScript.heartPos = soul.position
	GameOverScript.heartColor = soul.soulSprite.self_modulate
	GlobalSoundtrack.stop()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func SqueakAudio():
	GlobalAudio.PlayOneShot("res://Sounds/Fight/Squeak.wav",3)
func SelectAudioSound():
	GlobalAudio.PlayOneShot("res://Sounds/Fight/select.wav",2)

# customizeable functions
func ActActionType(st:String):
	match (st):
		"check":
			BattleDialogueEncounter(["* ATK 99 DEF 99\n* he loves tames"])
			enemyDialogueToPlay = []
			#enemyDialogueToPlay = ["not a surprise[speed,0.6]...[speed,0.04]huh ?"]
		"mock":
			BattleDialogueEncounter(["* you proceed to mock him[speed,0.5]...[wait,0.5][speed,0.06]\n* he doesn't care"])
			enemyDialogueToPlay = ["atleast make a good one"]
		_:
			pressedAct = false
			EnemyDialogueStart()
	pass

func ItemActionType(st:String):
	match (st):
		"L hero":
			#TweenUtils.tweenShake($GameCamera,8,15,0.3,TweenUtils.Ease.linear)
			#TweenUtils.tweenShakeRotation($GameCamera,3,15,0.3,TweenUtils.Ease.linear)
			#GameOver()
			HealSoul(30)
			BattleDialogueEncounter(["you ate l hero"])
		_:
			pressedItem = false
			EnemyDialogueStart()
	pass

func MercyAction():
	pressedMercy = false
	ForceStartAttack(attacks[turns])
	pass

func EnemyAttacksDials(tur:int):
	match (tur):
		0:
			enemyDialogueToPlay = ["let's get to the fight"]
		1:
			enemyDialogueToPlay = ["yooo"]
