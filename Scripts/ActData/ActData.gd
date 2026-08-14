extends Resource
class_name ActData

var obj:Node2D
var actName:String


func _init(ob:Node2D, nam:String) -> void:
	obj = ob
	actName = nam
