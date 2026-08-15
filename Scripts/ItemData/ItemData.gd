extends Resource
class_name ItemData

var obj:Node2D
var itemName:String
var itemDescription:String
var itemHeal:int

func _init(ob:Node2D, nam:String, desc:String, heal:int) -> void:
	obj = ob
	itemName = nam
	itemDescription = desc
	itemHeal = heal
