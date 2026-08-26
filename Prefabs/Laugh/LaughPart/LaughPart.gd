extends Sprite2D


@export var trail:Line2D
var paren:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func LaughID(ind:int,pare):
	paren = pare
	var vectPlace = [Vector2(-70,-50),Vector2(-10,-80),Vector2(30,-50)]
	var vectScal = [Vector2(0.785,0.656),Vector2(0.85,0.71),Vector2(0.6,0.50)]
	var randDur = randf_range(0.20,0.3)
	TweenUtils.tweenY(self,vectPlace[ind].y,randDur,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenX(self,vectPlace[ind].x,randDur,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenScalePingPong(self,vectScal[ind] + Vector2(0.05,-0.05),vectScal[ind]+Vector2(0,0.05),randf_range(0.04,0.06),TweenUtils.Ease.InOutBounce)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (trailArray.size() <= maxTrail-1):
		Trail(delta)
	trail.modulate = paren.modulate
	pass

var trailArray:Array
var maxTrail = 20
var starInterval:float = 0
func Trail(delta):
	starInterval += delta
	if (starInterval <= 0.01):
		return
	else:
		starInterval = 0.0
	trailArray.push_front(global_position)
	
	if (trailArray.size() > maxTrail):
		trailArray.pop_back()
	trail.clear_points()
	for point in trailArray:
		trail.add_point(point)
	await get_tree().create_timer(0.5).timeout
