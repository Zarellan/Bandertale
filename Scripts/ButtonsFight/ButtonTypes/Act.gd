extends Buttons
class_name Act

var isAct:bool = false
var arrActs:Array = ["hello", "world", "yeah"]
var indexX:int = 0
var indexY:int = 0
var arrActObjs:Array[Array]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if (!isAct):
		return
	if (Input.is_action_just_pressed("ui_left")):
		ActChoice(-1,0)
	if (Input.is_action_just_pressed("ui_right")):
		ActChoice(1,0)
	if (Input.is_action_just_pressed("ui_up")):
		ActChoice(0,1)
	if (Input.is_action_just_pressed("ui_down")):
		ActChoice(0,-1)
	if (Input.is_action_just_pressed("ActionCancel")):
		Back()
	if (Input.is_action_just_pressed("ActionAccept")):
		ActPress()
	pass

func Activate():
	isAct = true
	BringActs()
	ActChoice(0,0)

func Back():
	isAct = false
	for i in range(arrActObjs.size()):
		for j in range(arrActObjs[i].size()):
			arrActObjs[i][j].obj.queue_free()
			#arrActObjs[i][j].queue_free()
	arrActObjs.clear()
	fightHandler.BackToMain()


func BringActs():
	var x = 100.0
	var y = 270.0
	var texXtemp:Array = []
	for i in range(0,arrActs.size()):
		var tex:Text2D = InstantiateUtil.Instantiate(textPrefab,null)
		tex.ChangeText(arrActs[i],32)
		tex.position =  Vector2(x,y)
		texXtemp.append(ActData.new(tex,arrActs[i]))
		x += 300
		if (i % 2 == 1 && i != 0):
			y += 75
			x = 100
			arrActObjs.append(texXtemp)
			texXtemp = []
		if (i % 3 == 0 && i != 0 && i != 6):
			y = 270.0
	if (!texXtemp.is_empty()):
		arrActObjs.append(texXtemp)
		texXtemp = []

func ActChoice(incX,incY):
	indexX += incX
	indexY += incY
	OutOfBoundsCheck2DArray(arrActObjs)
	soul.position = arrActObjs[indexY][indexX].obj.position - Vector2(20,0)

func OutOfBoundsCheck2DArray(arr2D:Array[Array]):
	if (indexY > arr2D.size() - 1):
		indexY = 0
	if (indexY < 0):
		indexY = arr2D.size() - 1
	if (indexX > arr2D[indexY].size() - 1):
		indexX = 0
	if (indexX < 0):
		indexX = arr2D[indexY].size() - 1

func ActPress():
	print(arrActObjs[indexY][indexX].actName)
