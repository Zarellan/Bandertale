extends Node2D
class_name MainMenu

@export var bandertaleImage:Sprite2D
@export var menu:Node2D

@export var buttons:Array[MainMenuButton]
@export var soul:Node2D
var indexMain:int = 0

static var canInteract = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Change(0)
	await get_tree().create_timer(1,false).timeout
	bandertaleImage.visible = true
	GlobalAudio.PlayOneShot("res://Sounds/IntroSound.ogg")
	await get_tree().create_timer(1.2,false).timeout
	TweenUtils.tweenX(bandertaleImage,318,0.7,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(bandertaleImage,63,0.7,TweenUtils.Ease.OutCirc)
	await get_tree().create_timer(0.3,false).timeout
	TweenUtils.tweenAlpha(menu,1,0.2,TweenUtils.Ease.linear).finished.connect(func():
		canInteract = true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !canInteract:
		return
	if Input.is_action_just_pressed("ui_up"):
		Change(1)
	elif Input.is_action_just_pressed("ui_down"):
		Change(-1)
	if Input.is_action_just_pressed("ActionAccept"):
		SelectAudioSound()
		buttons[indexMain].ActiveButton()
	pass

func Change(inc:int):
	indexMain = posmod(indexMain + inc,buttons.size())
	soul.reparent(buttons[indexMain])
	soul.position = Vector2.ZERO
	if inc != 0:
		SqueakAudio()
	for i in range(buttons.size()):
		if i != indexMain:
			buttons[i].UnOverlappedButton()
	buttons[indexMain].OverlappedButton()


func SqueakAudio():
	GlobalAudio.PlayOneShot("res://Sounds/Fight/Squeak.wav",3)
func SelectAudioSound():
	GlobalAudio.PlayOneShot("res://Sounds/Fight/select.wav",2)
