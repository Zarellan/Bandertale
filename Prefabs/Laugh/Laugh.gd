extends Node2D


var laughs = []
@export var laughPrefab:PackedScene
var defaultScale:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#defaultScale = laughSprite.scale
	Laugh()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Laugh():
	for i in range(3):
		var laug = InstantiateUtil.Instantiate(laughPrefab,self)
		laug.LaughID(i,self)
	GlobalAudio.PlayOneShot("res://Sounds/laughs/"+str(randi_range(1,4))+".wav")
	await get_tree().create_timer(2).timeout
	TweenUtils.tweenAlpha(self,0,0.3,TweenUtils.Ease.linear).finished.connect(func():
		queue_free())
