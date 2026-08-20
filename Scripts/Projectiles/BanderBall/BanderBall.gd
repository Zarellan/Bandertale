extends Area2D

var isTouching:bool = false
var fightHandler:FightHandler

var reachedPlatf:bool = false
var reachedDownBox:bool = false

var mov:Vector2
var gravit:bool = false
var gravPow:float = 0
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	set_process(false)

var intervalTime:float = 0.01
var timePassed:float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isTouching:
		if timePassed > intervalTime:
			fightHandler.DamageSoul(5)
			timePassed = 0
		else:
			timePassed += delta
	pass

func _physics_process(delta: float) -> void:
	position += mov * delta
	if (gravit):
		mov.y += gravPow * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		set_process(true)
		isTouching = true
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		set_process(false)
		isTouching = false
	pass # Replace with function body.
