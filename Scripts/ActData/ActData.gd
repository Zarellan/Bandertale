extends Resource
class_name ActData

var obj:Node2D
var actName:String
var actDescription:String

func _init(ob:Node2D, nam:String, desc:String) -> void:
	obj = ob
	actName = nam
	actDescription = desc
