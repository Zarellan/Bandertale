extends Buttons
class_name Mercy

var isMercy = false

var spareText

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if (!isMercy):
		return
	if (Input.is_action_just_pressed("ActionCancel")):
		Back()
	pass

func Activate():
	isMercy = true
	BringMercy()

func Back():
	isMercy = false
	spareText.queue_free()
	fightHandler.BackToMain()

func BringMercy():
	spareText = InstantiateUtil.Instantiate(textPrefab,null)
	spareText.ChangeText("* spare",32)
	spareText.position =  Vector2(100,270)
	soul.position = spareText.position - Vector2(20,0)
