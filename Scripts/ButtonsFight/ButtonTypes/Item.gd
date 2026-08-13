extends Buttons
class_name Item

var itemsLol:Array = [
	{"name": "L hero",
	"hp": 12},
	{"name": "L hero",
	"hp": 12},
	{"name": "L hero 2",
	"hp": 12},
	{"name": "L hero 2",
	"hp": 12}
]

var itemIndex:int = 0

var itemsArr:Array

var soul:Soul

var isItem = false

var page = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	soul = get_tree().get_first_node_in_group("Soul")
	pass # Replace with function body.

func ChangeIndex(inc:int,isHoriz:bool = true):
	if isHoriz:
		HorizIndexProt(inc)
	else:
		if (itemsLol.size()-1 < itemIndex+inc):
			return
		itemIndex += inc
	SetVisible()
	soul.position = itemsArr[itemIndex].position - Vector2(20,0)
	#OutBoundCheck(itemsArr)

func HorizIndexProt(inc: int) -> void:
	var max_pages: int = ceil(itemsLol.size() / 4.0)
	
	var current_page: int = itemIndex / 4
	var local_slot: int = itemIndex % 4
	
	var col: int = local_slot % 2
	var row: int = local_slot / 2
	
	# Moving RIGHT off the right column
	if col == 1 && inc > 0:
		current_page = (current_page + 1) % max_pages # Loops back to Page 0 from last page
		local_slot = row * 2                          # Resets to left column, same row
			
	# Moving LEFT off the left column
	elif col == 0 && inc < 0:
		current_page = posmod(current_page - 1, max_pages) # Loops to last page from Page 0
		local_slot = (row * 2) + 1                         # Resets to right column, same row
			
	# Normal horizontal movement within the page
	else:
		col = posmod(col + inc, 2)
		local_slot = (row * 2) + col

	# Update state
	page = current_page
	itemIndex = (page * 4) + local_slot
	
	# Out-of-bounds guard for incomplete last pages
	if itemIndex >= itemsLol.size():
		itemIndex = itemsLol.size() - 1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (isItem):
		if (Input.is_action_just_pressed("ui_right")):
			ChangeIndex(1)
		if (Input.is_action_just_pressed("ui_left")):
			ChangeIndex(-1)
			
		# Local slot on current page (always 0, 1, 2, or 3)
		var local_slot: int = itemIndex % 4
		
		if (Input.is_action_just_pressed("ui_down")):
			# If local slot is 0 or 1, we are on the TOP row -> move DOWN (+2)
			if (local_slot < 2):
				ChangeIndex(2, false)
			# If local slot is 2 or 3, we are on the BOTTOM row -> move UP (-2)
			else:
				ChangeIndex(-2, false)
				
		if (Input.is_action_just_pressed("ui_up")):
			# If local slot is 2 or 3, we are on the BOTTOM row -> move UP (-2)
			if (local_slot >= 2):
				ChangeIndex(-2, false)
			# If local slot is 0 or 1, we are on the TOP row -> move DOWN (+2)
			else:
				ChangeIndex(2, false)
		if (Input.is_action_just_pressed("ActionCancel")):
			Back()

func Activate():
	isItem = true
	BringItems()
	ChangeIndex(0)

func Back():
	isItem = false
	for i in range(itemsArr.size()):
		itemsArr[i].queue_free()
	itemsArr.clear()
	fightHandler.BackToMain()

func BringItems():
	var x = 100.0
	var y = 270.0
	for i in range(0,itemsLol.size()):
		var tex:Text2D = InstantiateUtil.Instantiate(textPrefab,null)
		tex.ChangeText(itemsLol[i]["name"],32)
		tex.position =  Vector2(x,y)
		itemsArr.append(tex)
		x += 300
		if (i % 2 == 1 && i != 0):
			y += 75
			x = 100
		if (i % 3 == 0 && i != 0 && i != 6):
			y = 270.0

func SetVisible():
	for i in range(0,itemsLol.size()):
		itemsArr[i].visible = false
	for i in range((page*4),4+(page*4)):
		if (i > itemsLol.size()-1):
			break
		itemsArr[i].visible = true
func OutBoundCheck(sizeArr:Array):
	if (itemIndex > sizeArr.size()-1):
		itemIndex = 0
	if (itemIndex < 0):
		itemIndex = sizeArr.size()-1
	pass
