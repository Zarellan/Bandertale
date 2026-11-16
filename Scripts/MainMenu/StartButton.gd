extends MainMenuButton


@export var colorRect:ColorRect
@export var canv:CanvasLayer
var soul
func ActiveButton():
	MainMenu.canInteract = false
	soul = get_tree().get_first_node_in_group("Soul")
	StartIt()
	soul.reparent(canv)
	SoulAppear()
var ind = 0
func SoulAppear():
	soul.visible = true
	GlobalAudio.PlayOneShot("res://Sounds/FlickSwitch.wav")
	if (ind >= 2):
		GlobalAudio.PlayOneShot("res://Sounds/BattleFall.wav")
		TweenUtils.tweenX(soul,43,0.6,TweenUtils.Ease.linear)
		TweenUtils.tweenY(soul,458,0.6,TweenUtils.Ease.linear)
		await get_tree().create_timer(0.65,false).timeout
		get_tree().change_scene_to_file("res://Scenes/GameHandle.tscn")
		return
	await get_tree().create_timer(0.08,false).timeout
	soul.visible = false
	await get_tree().create_timer(0.08,false).timeout
	ind += 1
	SoulAppear()
func StartIt():
	colorRect.color = Color.BLACK
	pass
