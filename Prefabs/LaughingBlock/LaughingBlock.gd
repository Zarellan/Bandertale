extends Node2D

var fightHandler:FightHandler

@export var eBlock:Texture2D
@export var sprite:Sprite2D
@export var collis:CollisionShape2D
var hitted:bool = false
var defPosition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	defPosition = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Soul") && fightHandler.soul.velocity.y < -50 && !hitted):
		sprite.visible = true
		fightHandler.soul.velocity.y = 0 #the soul suddenly collides weirdly, so I need to manually stop it
		collis.set_deferred("disabled",false)
		TweenBlock()
		HittedBlock()
		hitted = true
	pass # Replace with function body.

func TweenBlock():
	TweenUtils.tweenY(self,defPosition.y-7,0.1,TweenUtils.Ease.OutCirc).finished.connect(func():
		TweenUtils.tweenY(self,defPosition.y,0.1,TweenUtils.Ease.InSine))

func HittedBlock():
	sprite.texture = eBlock
	var la = InstantiateUtil.Instantiate(load("res://Prefabs/Laugh/Laugh.tscn"),null)
	la.global_position = global_position
	la.scale = Vector2(0.7,0.7)
	GlobalAudio.PlayOneShot("res://Sounds/coin.wav")
