extends Attacks


var attackIndexes = 0
var spikeArr = []
var spikeArr2 = []

func _ready() -> void:
	boxSize = Vector2(500,150)
	attackTimer = 20

func StartAttack():
	super._ready()
	super.StartAttack()
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	
	while (true):
		CreateSpikeCol()
		CreateSpikeCol2()
		attackIndexes += 1
		if (attackIndexes >= 15):
			break
		await get_tree().create_timer(0.4).timeout
	await get_tree().create_timer(1).timeout
	EndTurn()
	pass

func _process(delta: float) -> void:
	for i in range(spikeArr.size()):
		spikeArr[i].global_position.x += 350 * delta
	for i in range(spikeArr2.size()):
		spikeArr2[i].global_position.x -= 350 * delta
	pass

func CreateSpikeCol():
	for i in range(9):
		if (i == 1 || i == 2):
			continue
		var spike = load("res://Scripts/Projectiles/Spikes/Spikes.tscn").instantiate()
		fightHandler.box.clipOnly.add_child(spike)
		spike.global_scale = Vector2(1.5,1.4)
		spike.global_position = Vector2(fightHandler.box.GetLeftCorner(),375 - (i*spike.sprite.texture.get_height()))
		spikeArr.append(spike)
func CreateSpikeCol2():
	for i in range(9):
		if (i == 1 || i == 2):
			continue
		var spike = load("res://Scripts/Projectiles/Spikes/Spikes.tscn").instantiate()
		fightHandler.box.clipOnly.add_child(spike)
		spike.global_scale = Vector2(1.5,1.4)
		spike.global_position = Vector2(fightHandler.box.GetRightCorner(),375 - (i*spike.sprite.texture.get_height()))
		spikeArr2.append(spike)

func EndTurn():
	for i in range(spikeArr.size()):
		spikeArr[i].queue_free()
	for i in range(spikeArr2.size()):
		spikeArr2[i].queue_free()
	spikeArr.clear()
	spikeArr2.clear()
	super.EndTurn()
