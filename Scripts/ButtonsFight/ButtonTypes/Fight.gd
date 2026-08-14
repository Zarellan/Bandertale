extends Buttons
class_name Fight


var isFight = false

var fightText

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if (!isFight):
		return
	if (Input.is_action_just_pressed("ActionCancel")):
		Back()
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
	fightText.ChangeText("* Bander",32)
	fightText.position =  Vector2(100,270)
	soul.position = fightText.position - Vector2(20,0)
