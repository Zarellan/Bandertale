extends Node2D


@export var bulletBill:PackedScene
@export var sprite:Sprite2D

var movSprite = Vector2(0,0)

var startMoving = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Spear/spear1.wav")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (startMoving):
		sprite.position += movSprite * delta
		movSprite.y += 400 * 2 * delta
		sprite.rotation_degrees += 20 * delta
	pass

var bulBill
func Shoot():
	movSprite = Vector2(30,-300)
	startMoving = true
	bulBill = InstantiateUtil.Instantiate(bulletBill,null)
	bulBill.scale = scale + Vector2(0.08,0.08)
	bulBill.global_position = $Sprite2D/BillOffset.global_position
	#GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Spear/spear2.wav",-10)
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Bill/billfire.wav",0)
