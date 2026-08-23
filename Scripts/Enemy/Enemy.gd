extends Node2D
class_name Enemy


@export var head:Node2D
@export var headSpr:Node2D

@export var body:Node2D
@export var bodySpr:Node2D

@export var legs:Node2D

@export var bubblePrefab:PackedScene
@export var anim:AnimationPlayer
var fightHandler:FightHandler
var enemyName:String = "Bander"
var enemyHealth:int = 1
var attackPlaceOffset = Vector2(0,-40)
var timeWhenAttackFinished:float = 0.9
var bubbleOffset = Vector2(150,-60)
var enemyDialogue = false
var diag
var defPosX = 320.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	#StartShake()
	#await get_tree().create_timer(2).timeout
	#endShake()
	#anim.play("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (shake):
		ShakeHeadTest(_delta)
	if (shoot):
		ShootHeadTest(_delta)
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
	tw = TweenUtils.tweenX(get_node("SpriteHolder"),-60,0.6,TweenUtils.Ease.OutCirc)
	tw.finished.connect(func():
		await get_tree().create_timer(0.2).timeout
		TweenUtils.tweenX(get_node("SpriteHolder"),0,0.6,TweenUtils.Ease.InSine))
	fightHandler.fighted = true
var indexDialogue = 0
var dialogueArr
func PlayDialogue(textStr:Array, lang = "english"):
	if (textStr.is_empty()):
		fightHandler.EnemyDialogueEnd()
		return
	indexDialogue = 0
	dialogueArr = textStr
	diag = InstantiateUtil.Instantiate(bubblePrefab,null)
	diag.position = position + bubbleOffset
	await get_tree().process_frame
	diag.get_node("Text").startDialogue(textStr[indexDialogue],0.06,"res://Sounds/Dialogues/Bander.wav",0,lang)
	enemyDialogue = true
	pass

func BoxDialogueArrayCheck():
	if (dialogueArr.size()-1 <= indexDialogue):
		diag.queue_free()
		fightHandler.EnemyDialogueEnd()
		return true
	else:
		indexDialogue += 1
		diag.get_node("Text").startDialogue(dialogueArr[indexDialogue],0.06,"res://Sounds/Dialogues/Bander.wav")
		return false





#region ShakeSystem (hard coded but I tried)

var interP: float = 0.0
@export var build_up_duration: float = 2.0 # How long it takes to reach max intensity

var shake = false
var shoot = false

var defPosHead
var defPosBody

func StartShake(cal:Callable = Callable()):
	interP = 0
	legs.offset = Vector2(0,-11)
	legs.position.y = 11
	shake = true
	bodySpr.reparent(self)
	headSpr.reparent(self)
	await get_tree().create_timer(1).timeout
	if (cal.is_valid()):
		cal.call()
	shake = false
	shoot = true
	defPosHead = head.position
	defPosBody = body.position
	var player_position = fightHandler.soul.global_position
	# 1. Calculate the difference between the head and the player's position
	var direction = (player_position - head.global_position).normalized()
	var direction2 = (player_position - body.global_position).normalized()

	var knockback_distance = -23.0
	var target_pos = head.position + (direction * knockback_distance)
	var target_pos_2 = body.position + (direction2 * (knockback_distance/3))

	var target_leg_skew = (target_pos.x - defPosHead.x) * 0.005
	# Clamp it so the legs don't distort into infinity
	target_leg_skew = clamp(target_leg_skew, -0.4, 0.4)
	
	var duration = 0.20
	
	# 2. Use the calculated X and Y destinations in your tweens
	var tw: Tween = TweenUtils.tweenY(head, target_pos.y, duration, TweenUtils.Ease.OutCirc)
	TweenUtils.tweenX(head, target_pos.x, duration, TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(body, target_pos_2.y, duration, TweenUtils.Ease.OutCirc)
	TweenUtils.tweenX(body, target_pos_2.x, duration, TweenUtils.Ease.OutCirc)
	TweenUtils.tweenSkew(legs, target_leg_skew, duration, TweenUtils.Ease.OutCirc)
	tw.finished.connect(func():
		TweenUtils.tweenY(head, defPosHead.y, duration, TweenUtils.Ease.InSine)
		TweenUtils.tweenX(head, defPosHead.x, duration, TweenUtils.Ease.InSine)
		TweenUtils.tweenY(body, defPosBody.y, duration, TweenUtils.Ease.InSine)
		TweenUtils.tweenX(body, defPosBody.x, duration, TweenUtils.Ease.InSine)
		TweenUtils.tweenSkew(legs, 0, duration, TweenUtils.Ease.InSine))

func ShakeHeadTest(delta: float) -> void:
	interP = min(interP + delta, build_up_duration)
	
	var intensity_progress = interP / build_up_duration

	var dynamic_lerp_speed = lerp(2.0, 60.0, intensity_progress)
	
	var random_shake = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 3.0
	var target_pos = head.global_position + random_shake
	var target_pos2 = body.global_position + random_shake/2

	headSpr.global_position = headSpr.global_position.lerp(target_pos, dynamic_lerp_speed * delta)
	bodySpr.global_position = bodySpr.global_position.lerp(target_pos2, dynamic_lerp_speed * delta)

func ShootHeadTest(delta):
	headSpr.global_position = headSpr.global_position.lerp(head.global_position, 15 * delta)
	bodySpr.global_position = bodySpr.global_position.lerp(body.global_position, 15 * delta)

func endShake():
	bodySpr.reparent(body)
	bodySpr.position = Vector2.ZERO
	headSpr.reparent(head)
	headSpr.position = Vector2(0.0,-0.593)
	legs.offset = Vector2(0,0)
	legs.position.y = 0

#endregion
