extends Attacks


var attackIndexes = 0

var lava
var warn
var aud
var bringLav:bool = false
var proj
var bringFakeLav:bool = false
var platforms = []
func _ready() -> void:
	boxSize = Vector2(500,150)
	attackTimer = 15

func StartAttack():
	super._ready()
	super.StartAttack()
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	PlatformSpawnings()
	TweenUtils.tweenCustom(self,fightHandler.box.box_size,Vector2(300,300-25),0.3,TweenUtils.Ease.OutCirc,func(val):
		fightHandler.box.box_size = val)
	TweenUtils.tweenY(fightHandler.box,235+25/2,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(fightHandler.enemy,90,0.3,TweenUtils.Ease.OutCirc)
	await get_tree().create_timer(1).timeout
	SpawnBullets()
	warn = load("res://Prefabs/warningSign/WarningSign.tscn").instantiate()
	add_child(warn)
	warn.position = Vector2(324,370)
	warn.scale = Vector2(4.7,0.4)
	aud = GlobalAudio.PlayOneShot("res://Sounds/WarningSound/warning sound.ogg")
	await get_tree().create_timer(1).timeout
	warn.queue_free()
	aud.stop()
	PrepareLava()
	while (true):
		var direction = randi_range(1,2) 
		var dirY = [180,260,350].pick_random()
		SpawnBanderBlast(4,Vector2((320 if direction == 1 else 325),dirY),\
		Vector2((-0.5 if direction == 2 else 0.5),0.5),0,0.8,1.25)
		attackIndexes += 1
		if (attackIndexes >= 14):
			break
		await get_tree().create_timer(2.3).timeout
	EndTurn()
	pass

func SpawnPlatform(posY:float,posXs:float):
	var platformer = load("res://Scripts/Projectiles/Platformer/platformer.tscn").instantiate()
	platformer.position = Vector2(posXs,posY)
	platformer.scale = Vector2(1.5,1.5)
	add_child(platformer)
	platforms.append(platformer)
func PlatformSpawnings():
	while (true):
		var dirY = [180,260,350]
		for i in range(dirY.size()):
			SpawnPlatform(dirY[i],700 if i == 1 else -100)
			await get_tree().create_timer(0.2).timeout
		await get_tree().create_timer(1.3).timeout
func SpawnBullets():
	var dirX = [-100,700]
	var mov = [180,-180]
	var scal = [-1.8,1.8]
	await get_tree().create_timer(1).timeout
	while (true):
		var ind = randi_range(0,1)
		SpawnBill(Vector2(dirX[ind],randf_range(140,340)),Vector2(mov[ind],0),Vector2(scal[ind],1.8))
		await get_tree().create_timer(randf_range(0.9,2.0)).timeout
func _process(delta: float) -> void:
	if (bringLav):
		lava.position.y -= 2.5 * delta
	if (is_instance_valid(proj) && bringFakeLav):
		proj.global_scale += Vector2(0,0.43) * delta
	pass
func _physics_process(delta: float) -> void:
	MovePlatforms(delta)
	pass

func MovePlatforms(delta):
	for i in range(platforms.size()):
		if (i % 3 == 0 || i % 3 == 2):
			platforms[i].position.x += 150 * delta
		elif (i % 3 == 1):
			platforms[i].position.x -= 150 * delta

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

func SpawnBill(pos:Vector2,mov,scal):
	var bill = load("res://Scripts/Projectiles/BulletBill/BulletBill.tscn").instantiate()
	add_child(bill)
	bill.position = pos
	bill.scale = scal
	bill.movPlace = mov
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Bill/billfire.wav",0)
	

func PrepareLava():
	lava = load("res://Scripts/Projectiles/Lava/Lava2.tscn").instantiate()
	fightHandler.box.clipOnly.add_child(lava)
	lava.global_scale = Vector2(3.2,1.0)
	lava.global_position = Vector2(325,700)
	TweenUtils.tweenCustom(self,lava.global_position.y,420,0.9,TweenUtils.Ease.OutCirc,func(val):
		lava.global_position.y = val)


func EndTurn():
	fightHandler.camera.enabled = true
	fightHandler.soul.get_node("GameCamera").enabled = false
	TweenUtils.tweenY(fightHandler.enemy,205.0,0.3,TweenUtils.Ease.OutCirc)
	lava.queue_free()
	super.EndTurn()
	fightHandler.soul.get_node("FirePartic").emitting = false
