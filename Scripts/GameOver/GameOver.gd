extends Node2D
class_name GameOverScript

static var heartPos:Vector2
static var heartColor:Color

@export var heart:Sprite2D
@export var gameOverImage:Sprite2D

@export var soulDebris:PackedScene
@export var dialogueGameover:TextAdv

static var dialoguesLOL = ["you know[speed,0.5]...","the fangame would do numbers\n[wait,0.7]between 2015-2020","eh[wait,1]\nit's too late now"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	heart.position = heartPos
	heart.self_modulate = heartColor
	
	await get_tree().create_timer(1.2).timeout
	heart.get_node("AnimationPlayer").play("Broke")
	GlobalAudio.PlayOneShot("res://Sounds/GameOver/Break1.wav")
	await get_tree().create_timer(1.2).timeout
	GlobalAudio.PlayOneShot("res://Sounds/GameOver/Break2.wav")
	heart.visible = false
	for i in range (6):
		var s = InstantiateUtil.Instantiate(soulDebris,null)
		s.modulate = heart.self_modulate
		s.position = heart.position
	await get_tree().create_timer(1.2).timeout
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/GameOverDeterm.ogg")
	TweenUtils.tweenAlpha(gameOverImage,1,0.8,TweenUtils.Ease.linear)
	await get_tree().create_timer(0.7).timeout
	dialogueGameover.startDialogue(dialoguesLOL[indexDiag],0.04,"res://Sounds/Dialogues/Text2.wav",4)
	indexDiag += 1
	pass # Replace with function body.

var canDiag = false
var indexDiag:int = 0
var letsGoNow:bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ActionAccept") && !dialogueGameover.visible && !letsGoNow):
		TweenUtils.tweenAlpha(gameOverImage,0,0.8,TweenUtils.Ease.linear)
		TweenUtils.tweenCustom(self,GlobalSoundtrack.volume_db,-80,1.2,TweenUtils.Ease.linear,func(val):
			GlobalSoundtrack.volume_db = val)
		letsGoNow = true
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://Scenes/GameHandle.tscn")
	if (Input.is_action_just_pressed("ActionAccept") && dialogueGameover.finishedDial):
		if (indexDiag < dialoguesLOL.size()):
			dialogueGameover.startDialogue(dialoguesLOL[indexDiag],0.04,"res://Sounds/Dialogues/Text2.wav",4)
			indexDiag += 1
		else:
			dialogueGameover.visible = false
	if (Input.is_action_just_pressed("ActionCancel") && !dialogueGameover.finishedDial):
		dialogueGameover.ForceFinish()
	pass
