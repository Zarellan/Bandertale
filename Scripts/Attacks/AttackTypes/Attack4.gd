extends Attacks


var attackIndexes = 0
var spikeArr = []
var spikeInc = 2
var gotHit = false
func _ready() -> void:
	boxSize = Vector2(400,150)
	#boxPos =  Vector2(325,307-100)
	attackTimer = 20

func PrepareAttack():
	#TweenUtils.tweenY(fightHandler.enemy,20,0.3,TweenUtils.Ease.OutCirc)
	pass
func StartAttack():
	super._ready()
	super.StartAttack()
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.red)
	SpawnBanderBlast(4,Vector2(165,250),Vector2(0.4,-0.4),90)
	SpawnBanderBlast(4,Vector2(fightHandler.box.position.x,250),Vector2(0.4,-0.4),90)
	SpawnBanderBlast(4,Vector2(490,250),Vector2(0.4,-0.4),90)
	await get_tree().create_timer(1.2).timeout
	SpawnBanderBlast(2,Vector2(230,250),Vector2(0.5,-0.5),90)
	SpawnBanderBlast(2,Vector2(450,250),Vector2(0.5,-0.5),90)
	await get_tree().create_timer(1.2).timeout
	SpawnBanderBlast(4,Vector2(165,250),Vector2(0.4,-0.4),90)
	SpawnBanderBlast(4,Vector2(fightHandler.box.position.x,250),Vector2(0.4,-0.4),90)
	SpawnBanderBlast(4,Vector2(490,250),Vector2(0.4,-0.4),90)
	await get_tree().create_timer(1.2).timeout
	fightHandler.enemy.anim.play("ThrowDown")
	fightHandler.enemy.anim.animation_finished.connect(func(anim_name):
		fightHandler.enemy.anim.play("Idle"))
	SpawnBanderBlast(5,Vector2(400,370),Vector2(0.4,-0.4),180)
	await get_tree().create_timer(1.2).timeout
	var b1 = SpawnBanderBlast(2,Vector2(230,250),Vector2(0.5,-0.5),90,1,1.5)
	var b2 = SpawnBanderBlast(2,Vector2(450,250),Vector2(0.5,-0.5),90,1,1.5)
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.red)
	await get_tree().create_timer(1).timeout
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Spear/spear1.wav")
	TweenUtils.tweenRotation(b2,180,0.5,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(b2,280,0.5,TweenUtils.Ease.OutCirc)
	await get_tree().create_timer(2).timeout
	EndTurn()
	pass

func _process(delta: float) -> void:
	pass

func SpawnBanderBlast(dist:float,pos:Vector2,scal:Vector2,rot:float = 0, dur:float = 0.8, whenStart = 1):
	var band = load("res://Prefabs/BanderBlaster/bander_blaster.tscn").instantiate()
	band.blastDistance = dist
	band.whenStart = whenStart
	add_child(band)
	band.scale = scal
	band.position = pos
	band.rotation_degrees = rot
	band.timeDuration = dur
	return band

func EndTurn():

	super.EndTurn()
	
