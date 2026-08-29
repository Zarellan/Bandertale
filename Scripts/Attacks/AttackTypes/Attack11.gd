extends Attacks


var attackIndexes = 0
var spikeArr = []
var spikeArr2 = []

var attackSpe
var lava
func _ready() -> void:
	boxSize = Vector2(400.0,170)
	attackTimer = 18

func StartAttack():
	super._ready()
	super.StartAttack()
	await get_tree().create_timer(0.3).timeout
	#TeleportBox(Vector2(200,200),Vector2(200,170),attack1)
	#TeleportBox(Vector2(400,300), Vector2(400.0,170), attack2)
	#TeleportBox(Vector2(300,300), Vector2(400.0,170), attack3)
	TeleportBox(Vector2(325.0,307.0), Vector2(350.0,150), attack4)
	await get_tree().create_timer(6).timeout
	pass

func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	if (is_instance_valid(attackSpe) && attackSpe.global_position.x >-1239):
		attackSpe.global_position -= Vector2(100*delta,0)
	for i in range(spikeArr.size()):
		spikeArr[i].global_position.x += 350 * delta
	for i in range(spikeArr2.size()):
		spikeArr2[i].global_position.x -= 350 * delta

	pass

func TeleportBox(pos, size, cal:Callable):
	fightHandler.blackBack.color.a = 1
	await get_tree().create_timer(0.3).timeout
	fightHandler.box.position = pos
	fightHandler.box.box_size = size
	cal.call()
	fightHandler.blackBack.color.a = 0
	pass

func attack1():
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.red)
	fightHandler.soul.position = fightHandler.box.position
	fightHandler.enemy.position = Vector2(450,350)
	SpawnBanderBlast(4,fightHandler.box.position + Vector2(100,0),Vector2(-0.5,0.5),0)
	SpawnBanderBlast(4.7,fightHandler.box.position + Vector2(0,100),Vector2(-0.5,0.5),-90)
	await get_tree().create_timer(1.8).timeout
	TeleportBox(Vector2(400,300), Vector2(400.0,170), attack2)

func attack2():
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	fightHandler.enemy.position = Vector2(100,170)
	fightHandler.soul.position = fightHandler.box.position
	fightHandler.soul.position.y = fightHandler.box.GetDownCorner()-fightHandler.box.border_size
	while (true):
		CreateSpikeCol()
		CreateSpikeCol2()
		attackIndexes += 1
		if (attackIndexes >= 5):
			break
		await get_tree().create_timer(0.4).timeout
	await get_tree().create_timer(1).timeout
	for i in range(spikeArr.size()):
		spikeArr[i].queue_free()
	for i in range(spikeArr2.size()):
		spikeArr2[i].queue_free()
	spikeArr.clear()
	spikeArr2.clear()

	TeleportBox(Vector2(300,300), Vector2(400.0,170), attack3)
	pass
func attack3():
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	fightHandler.enemy.position = Vector2(100,170)
	fightHandler.soul.position = fightHandler.box.position
	fightHandler.soul.position.y = fightHandler.box.GetDownCorner()-fightHandler.box.border_size
	MountainSpikesCol1()
	MountainSpikesCol2()
	await get_tree().create_timer(1.5).timeout
	MountainSpikesCol1()
	MountainSpikesCol2()
	await get_tree().create_timer(1.2).timeout
	fightHandler.enemy.anim.play("ThrowUp")
	await get_tree().create_timer(0.4).timeout
	MountainSpikesCol3()
	MountainSpikesCol4()
	await get_tree().create_timer(0.5).timeout
	fightHandler.enemy.anim.play("Idle")
	await get_tree().create_timer(1.4).timeout
	MountainSpikesCol3()
	MountainSpikesCol4()
	await get_tree().create_timer(1.2).timeout
	for i in range(spikeArr.size()):
		spikeArr[i].queue_free()
	for i in range(spikeArr2.size()):
		spikeArr2[i].queue_free()
	spikeArr.clear()
	spikeArr2.clear()

	TeleportBox(Vector2(325.0,307.0), Vector2(350.0,150), attack4)
func attack4():
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	fightHandler.soul.ChangeSoulDirection(fightHandler.soul.Direction.down)
	fightHandler.enemy.position = Vector2(320.0,205.0)
	fightHandler.soul.position = fightHandler.box.position
	fightHandler.soul.position.y = fightHandler.box.GetDownCorner()-fightHandler.box.border_size
	SpawnBanderBlast(4,Vector2(400,fightHandler.box.GetDownCorner()-30),Vector2(-0.35,0.35),0,0.8,0.7)
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

func CreateSpikeCol():
	for i in range(10):
		if (i == 1 || i == 2):
			continue
		var spike = load("res://Scripts/Projectiles/Spikes/Spikes.tscn").instantiate()
		fightHandler.box.clipOnly.add_child(spike)
		spike.global_scale = Vector2(1.5,1.4)
		spike.global_position = Vector2(fightHandler.box.GetLeftCorner(),375 - (i*spike.sprite.texture.get_height()))
		spikeArr.append(spike)
func CreateSpikeCol2():
	for i in range(10):
		if (i == 1 || i == 2):
			continue
		var spike = load("res://Scripts/Projectiles/Spikes/Spikes.tscn").instantiate()
		fightHandler.box.clipOnly.add_child(spike)
		spike.global_scale = Vector2(1.5,1.4)
		spike.global_position = Vector2(fightHandler.box.GetRightCorner(),375 - (i*spike.sprite.texture.get_height()))
		spikeArr2.append(spike)

const spikePrefab = preload("res://Scripts/Projectiles/Spikes/Spikes.tscn")
func MountainSpikesCol1():
	var indexMount = 1
	var firstRowFin = false
	var inc = 1
	while (true):
		for i in range(indexMount):
			var spike = spikePrefab.instantiate()
			fightHandler.box.clipOnly.add_child(spike)
			spike.global_scale = Vector2(1.5,1.4)
			spike.global_position = Vector2(fightHandler.box.GetLeftCorner(),375 - (i*spike.sprite.texture.get_height()))
			spikeArr.append(spike)
		await get_tree().create_timer(0.08).timeout
		indexMount += inc
		if (indexMount > 5 && !firstRowFin):
			firstRowFin = true
			inc = -1
		if (indexMount < 1 && firstRowFin):
			break

func MountainSpikesCol2():
	var indexMount = 1
	var firstRowFin = false
	var inc = 1
	while (true):
		for i in range(indexMount):
			var spike = spikePrefab.instantiate()
			fightHandler.box.clipOnly.add_child(spike)
			spike.global_scale = Vector2(1.5,1.4)
			spike.global_position = Vector2(fightHandler.box.GetRightCorner(),375 - (i*spike.sprite.texture.get_height()))
			spikeArr2.append(spike)
		await get_tree().create_timer(0.08).timeout
		indexMount += inc
		if (indexMount > 5 && !firstRowFin):
			firstRowFin = true
			inc = -1
		if (indexMount < 1 && firstRowFin):
			break
	pass
	
func MountainSpikesCol3():
	var indexMount = 1
	var firstRowFin = false
	var inc = 1
	while (true):
		for i in range(indexMount):
			var spike = spikePrefab.instantiate()
			fightHandler.box.clipOnly.add_child(spike)
			spike.global_scale = Vector2(1.5,1.4)
			spike.global_position = Vector2(fightHandler.box.GetLeftCorner(),225 + (i*spike.sprite.texture.get_height()))
			spikeArr.append(spike)
		await get_tree().create_timer(0.08).timeout
		indexMount += inc
		if (indexMount > 5 && !firstRowFin):
			firstRowFin = true
			inc = -1
		if (indexMount < 1 && firstRowFin):
			break

func MountainSpikesCol4():
	var indexMount = 1
	var firstRowFin = false
	var inc = 1
	while (true):
		for i in range(indexMount):
			var spike = spikePrefab.instantiate()
			fightHandler.box.clipOnly.add_child(spike)
			spike.global_scale = Vector2(1.5,1.4)
			spike.global_position = Vector2(fightHandler.box.GetRightCorner(),225 + (i*spike.sprite.texture.get_height()))
			spikeArr2.append(spike)
		await get_tree().create_timer(0.08).timeout
		indexMount += inc
		if (indexMount > 5 && !firstRowFin):
			firstRowFin = true
			inc = -1
		if (indexMount < 1 && firstRowFin):
			break
	pass

func EndTurn():
	TweenUtils.tweenY(fightHandler.enemy,205.0,0.3,TweenUtils.Ease.OutCirc)
	lava.queue_free()
	super.EndTurn()
	fightHandler.soul.get_node("FirePartic").emitting = false
