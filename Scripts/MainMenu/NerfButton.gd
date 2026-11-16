extends MainMenuButton

var hint
@export var text:RichTextLabel
func _ready() -> void:
	super._ready()
	hint = get_tree().get_first_node_in_group("Hint")
func ActiveButton():
	FightHandler.nerf = !FightHandler.nerf
	text.modulate = Color(1.0, 1.0, 0.0) if FightHandler.nerf else Color(1.0, 1.0, 1.0)

func OverlappedButton():
	super.OverlappedButton()
	if hint:
		TweenUtils.tweenAlpha(hint,1,0.3,TweenUtils.Ease.linear)

func UnOverlappedButton():
	super.UnOverlappedButton()
	if hint:
		TweenUtils.tweenAlpha(hint,0,0.3,TweenUtils.Ease.linear)
