extends Buttons
class_name Fight


@export var attackPanel:Sprite2D
@export var attackPole:Sprite2D
@export var slash:Sprite2D

var isFight = false
var isAttacking = false
var fightText

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if ((!isFight && !isAttacking) || waitAction):
		waitAction = false
		return
	if isFight:
		if (Input.is_action_just_pressed("ActionCancel")):
			Back()
		if (Input.is_action_just_pressed("ActionAccept")):
			ActivateFight()
	elif isAttacking:
		attackPole.position.x += 320 * delta
		if (attackPole.position.x > 275):
			Miss()
		if (Input.is_action_just_pressed("ActionAccept")):
			Attack()
	pass

func Activate():
	isFight = true
	BringFight()

func Back():
	isFight = false
	fightText.queue_free()
	fightHandler.BackToMain()

func BringFight():
	fightText = InstantiateUtil.Instantiate(textPrefab,null)
	fightText.ChangeText("* "+fightHandler.enemy.enemyName,32)
	fightText.position =  Vector2(100,270)
	soul.position = fightText.position - Vector2(20,0)
	attackPole.position.x = -274.851

func ActivateFight():
	fightHandler.SelectAudioSound()
	isFight = false
	fightText.queue_free()
	soul.visible = false
	waitAction = true
	isAttacking = true
	fightHandler.CleanChoices()
	#fightHandler.enemy.enemyHealth -= 1
	attackPanel.visible = true

func Attack():
	GlobalAudio.PlayOneShot("res://Sounds/Fight/Slash.wav",4)
	isAttacking = false
	attackPanel.get_node("AnimationPlayer").play("attacked")
	slash.get_node("AnimationPlayer").play("Slash")
	slash.position = fightHandler.enemy.position + fightHandler.enemy.attackPlaceOffset
	fightHandler.enemy.GotAttacked()
	await get_tree().create_timer(fightHandler.enemy.timeWhenAttackFinished).timeout
	attackPanel.visible = false
	#fightHandler.SetTurn(true)
	fightHandler.EnemyDialogueStart()

func Miss():
	isAttacking = false
	#attackPanel.get_node("AnimationPlayer").play("attacked")
	#slash.get_node("AnimationPlayer").play("Slash")
	#slash.position = fightHandler.enemy.position + fightHandler.enemy.attackPlaceOffset
	#fightHandler.enemy.GotAttacked()
	#await get_tree().create_timer(fightHandler.enemy.timeWhenAttackFinished).timeout
	attackPanel.visible = false
	#fightHandler.SetTurn(true)
	fightHandler.EnemyDialogueStart()
