extends Attacks


func _ready() -> void:
	boxSize = Vector2(200,150)
	attackTimer = 20

var lava

var platformer

var banderBalls = []

var twPlatformY:Tween

var platformer2
func StartAttack():
	super._ready()
	super.StartAttack()
	#fightHandler.enemy.PlayDialogue(["let's get to the fight"])
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.red)
	await get_tree().create_timer(0.5).timeout
	fightHandler.enemy.anim.play("ThrowDown")
	#await get_tree().create_timer(0.1).timeout
	#fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	#fightHandler.soul.CrushSoulDirection(0)
	var warningS = load("res://Prefabs/warningSign/WarningSign.tscn").instantiate()
	add_child(warningS)
	warningS.position = Vector2(324,338)
	warningS.scale = Vector2(3.14,1.36)
	var aud = GlobalAudio.PlayOneShot("res://Sounds/WarningSound/warning sound.ogg")
	await get_tree().create_timer(0.5).timeout
	warningS.queue_free()
	aud.queue_free()
	PrepareLava()
	await get_tree().create_timer(0.2).timeout
	PreparePlatform()
	await get_tree().create_timer(0.7).timeout
	BringBullBill(Vector2(497.0,516.0),Vector2(497.0,282.0))
	await get_tree().create_timer(0.7).timeout
	BringBullBill(Vector2(470.0,516.0),Vector2(470.0,400.0),40)
	BringBullBill(Vector2(470.0,-100.0),Vector2(470.0,150.0),-40)
	await get_tree().create_timer(0.7).timeout
	BringBullBill(Vector2(497.0,516.0),Vector2(497.0,290.0))
	BringBullBill(Vector2(320.0,-200),Vector2(320.0,146),-90)
	await get_tree().create_timer(0.8).timeout
	TweenUtils.tweenCustom(self,lava.global_position.y,900,0.9,TweenUtils.Ease.InSine,func(val):
		lava.global_position.y = val)
	await get_tree().create_timer(0.7).timeout
	platformer.get_node("CollisionShape2D").disabled = true
	TweenUtils.tweenRotation(platformer,70,0.3,TweenUtils.Ease.OutCirc)
	await get_tree().create_timer(0.4).timeout
	fightHandler.enemy.anim.play("ThrowLeftOv")
	await get_tree().create_timer(0.1).timeout
	platformer.sync_to_physics = false
	TweenUtils.tweenX(platformer,160,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenRotation(platformer,0,0.3,TweenUtils.Ease.OutCirc)
	SpawnBanderBall()
	await get_tree().create_timer(0.7).timeout
	SpawnBanderBall()
	await get_tree().create_timer(0.4).timeout
	SpawnBanderBall()
	await get_tree().create_timer(3).timeout
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.red)
	SpawnBanderBlast(3,Vector2(200,fightHandler.soul.position.y),Vector2(0.4,0.4),0)
	SpawnBanderBlast(2,Vector2(fightHandler.soul.position.x,200),Vector2(0.4,0.4),90)
	await get_tree().create_timer(1).timeout
	SpawnBanderBlast(3,Vector2(200,fightHandler.soul.position.y),Vector2(0.4,0.4),0)
	SpawnBanderBlast(2,Vector2(fightHandler.soul.position.x,200),Vector2(0.4,0.4),90)
	await get_tree().create_timer(1.5).timeout
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	fightHandler.enemy.anim.play("ThrowDown")
	SpawnBanderBlast(2,Vector2(500,350),Vector2(-0.5,0.5),0,1.3)
	await get_tree().create_timer(0.8).timeout
	PreparePlatform2()
	await get_tree().create_timer(1.4).timeout
	Engine.time_scale = 1
	fightHandler.enemy.anim.play("Stop")
	fightHandler.enemy.PlayDialogue(["Dayum Boi"])
	pass

var indPlatfDur = 0

var platfMustFall = false

var gravPlatf:float = -400
func _process(delta: float) -> void:
	for i in range(banderBalls.size()):
		if (!banderBalls[i].reachedPlatf):
			if (is_instance_valid(platformer) && banderBalls[i].position.y + 85 >= platformer.position.y):
				banderBalls[i].mov = Vector2(randf_range(40,190),-600)
				GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Impact.wav")
				banderBalls[i].reachedPlatf = true
				fightHandler.camera.position = Vector2(320.0,240.0)
				TweenUtils.tweenShake(fightHandler.camera,5,15,0.2,TweenUtils.Ease.linear)
				indPlatfDur += 1
				if (indPlatfDur < 3):
					TweenUtils.StopTween(twPlatformY)
					twPlatformY = TweenUtils.tweenY(platformer,platformer.position	.y+20,0.3,TweenUtils.Ease.OutCirc)
				else:
					platfMustFall = true
					GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/kickkill.wav")
		elif (!banderBalls[i].reachedDownBox):
			if (is_instance_valid(platformer) && banderBalls[i].position.y + 85 >= fightHandler.box.GetDownCorner()):
				banderBalls[i].mov = Vector2(120,-600)
				GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Impact.wav")
				banderBalls[i].reachedDownBox = true
				fightHandler.camera.position = Vector2(320.0,240.0)
				TweenUtils.tweenShake(fightHandler.camera,5,15,0.2,TweenUtils.Ease.linear)
		if (banderBalls[i].reachedPlatf):
			banderBalls[i].rotation_degrees += 30 * delta
	if (is_instance_valid(platformer) && platfMustFall):
		platformer.position.x += 60 * delta
		platformer.rotation_degrees += 360 * delta
		platformer.position.y += gravPlatf * delta
		gravPlatf += 900 * delta

func PreparePlatform():
	platformer = load("res://Scripts/Projectiles/Platformer/platformer.tscn").instantiate()
	platformer.position = Vector2(-300,300.0)
	platformer.scale = Vector2(1.5,1.5)
	TweenUtils.tweenX(platformer,320,0.3,TweenUtils.Ease.OutCirc)
	add_child(platformer)

func PreparePlatform2():
	platformer2 = load("res://Scripts/Projectiles/Platformer/platformer.tscn").instantiate()
	platformer2.position = Vector2(270,600.0)
	platformer2.scale = Vector2(1.5,1.5)
	TweenUtils.tweenY(platformer2,295,0.3,TweenUtils.Ease.OutCirc)
	add_child(platformer2)

func PrepareLava():
	lava = load("res://Scripts/Projectiles/Lava/Lava2.tscn").instantiate()
	fightHandler.box.clipOnly.add_child(lava)
	lava.global_scale = Vector2(1.5,1.2)
	lava.global_position = Vector2(325,700)
	TweenUtils.tweenCustom(self,lava.global_position.y,400,0.9,TweenUtils.Ease.OutCirc,func(val):
		lava.global_position.y = val)

func BringBullBill(startFrom,endTo,rot = 0,speed = 300):
	var bulletBillHol = load("res://Prefabs/BulletBillGun/bullet_bill_gun.tscn").instantiate()
	add_child(bulletBillHol)
	bulletBillHol.position = startFrom
	bulletBillHol.scale = Vector2(1.6,1.6)
	bulletBillHol.sprite.rotation_degrees = rot
	TweenUtils.tweenY(bulletBillHol,endTo.y,0.4,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenX(bulletBillHol,endTo.x,0.4,TweenUtils.Ease.OutCirc)
	await get_tree().create_timer(0.6).timeout
	bulletBillHol.Shoot()
	bulletBillHol.bulBill.rotation = bulletBillHol.sprite.rotation
	bulletBillHol.bulBill.movPlace = -Vector2.from_angle(bulletBillHol.sprite.rotation) * speed

func SpawnBanderBall():
	var banderBall = load("res://Scripts/Projectiles/BanderBall/BanderBall.tscn").instantiate()
	add_child(banderBall)
	banderBall.scale = Vector2(1.1,1.1)
	banderBall.position = Vector2(160,-200)
	banderBall.gravit = true
	banderBall.gravPow = 900
	banderBalls.append(banderBall)

func SpawnBanderBlast(dist:float,pos:Vector2,scal:Vector2,rot:float = 0, dur:float = 0.8):
	var band = load("res://Prefabs/BanderBlaster/bander_blaster.tscn").instantiate()
	band.blastDistance = dist
	add_child(band)
	band.scale = scal
	band.position = pos
	band.rotation_degrees = rot
	band.timeDuration = dur

func EndTurn(): #just override on first attack
	pass
