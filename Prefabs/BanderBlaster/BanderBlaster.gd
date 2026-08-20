extends Node2D


@export var line:Line2D
@export var sprite:Sprite2D
@export var blast2:Texture2D

@export var blastValue:float

var canHit:bool = false
var touched:bool = false

var fightHandler:FightHandler

var blastDistance = 0.2
var timeDuration = 0.8
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	TweenUtils.tweenX(sprite,-blastDistance*100.0,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenRotation(sprite,0,0.3,TweenUtils.Ease.OutCirc)
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/gasterblaster/blast1.wav")
	await get_tree().create_timer(1).timeout
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/gasterblaster/blast2.wav")
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/gasterblaster/blast4.ogg")
	BlastStart()
	TweenUtils.tweenX(sprite,-1400.0,timeDuration,TweenUtils.Ease.InSine)
	TweenUtils.tweenAlpha(self,0,timeDuration,TweenUtils.Ease.linear)
	await get_tree().create_timer(0.02).timeout
	canHit = true
	await get_tree().create_timer(timeDuration + 0.3).timeout
	queue_free()
	pass # Replace with function body.

var intervalTime:float = 0.01
var timePassed:float = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if touched && canHit:
		if timePassed > intervalTime:
			fightHandler.DamageSoul(3)
			timePassed = 0
		else:
			timePassed += delta
	if (modulate.a < 0.4):
		canHit = false
	pass

var twBlast:Tween
func BlastStart():
	sprite.texture = blast2
	twBlast = TweenUtils.tweenCustom(self,line.width,blastValue,0.15,TweenUtils.Ease.InOutSine,func(val):
		line.width = val)
	twBlast.finished.connect(func():
		twBlast = TweenUtils.tweenCustom(self,line.width,blastValue*0.95,0.15,TweenUtils.Ease.InOutSine,func(val):
			line.width = val
			)
		twBlast.finished.connect(BlastStart))
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		touched = true
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		touched = false
	pass # Replace with function body.
