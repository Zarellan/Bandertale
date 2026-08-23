extends Attacks


var attackIndexes = 0
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
	await get_tree().create_timer(1).timeout
	BanderSpawnAt()
	while (true):
		BanderBallSpawner(Vector2(-50,270),Vector2(0.55,0.55),Vector2(180,0),200)
		BanderBallSpawner(Vector2(700,345),Vector2(0.55,0.55),Vector2(-180,0),-200)
		attackIndexes += 1
		if (attackIndexes >= 14):
			break
		await get_tree().create_timer(0.8).timeout
	await get_tree().create_timer(5).timeout
	EndTurn()
	pass

func BanderSpawnAt():
	get_tree().create_timer(2).timeout
	while (true):
		SpawnBanderBlast(2,Vector2(500,270 if randi_range(0,1) else 350),Vector2(0.4,-0.4),180)
		if (attackIndexes >= 14):
			break
		await get_tree().create_timer(2).timeout

func BanderBallSpawner(pos,scal,toMov,rot = 0):
	var ball = load("res://Scripts/Projectiles/BanderBall/BanderBall.tscn").instantiate()
	ball.damageT = 2
	ball.cooldown = 0.01
	ball.mov = toMov
	ball.rotat = rot
	add_child(ball)
	ball.scale = scal
	ball.position = pos

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
	
