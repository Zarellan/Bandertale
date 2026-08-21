extends Area2D

var isTouching:bool = false
var fightHandler:FightHandler

var movPlace = Vector2(0,0)

var hittedBill = false

var grav = false
var gr = 1000
@export var sprite:Sprite2D
@export var toJump:Node2D
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isTouching && !hittedBill:
		if (fightHandler.soul.global_position.y < toJump.global_position.y && fightHandler.soul.velocity.y > 2):
			if (Input.is_action_pressed("jump")):
				fightHandler.soul.velocity.y = -400
			else:
				fightHandler.soul.velocity.y = -200
			movPlace.y = -400
			sprite.rotation_degrees = 0
			sprite.scale = Vector2(sprite.scale.x,-abs(sprite.scale.y))
			grav = true
			hittedBill = true
			GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/kickkill.wav",5)
		if (fightHandler.soul.global_position.y < toJump.global_position.y):
			return
		fightHandler.DamageSoul(5,0.01)
		
	pass

func _physics_process(delta: float) -> void:
	position += movPlace * delta
	if grav:
		movPlace.y += gr * delta

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
