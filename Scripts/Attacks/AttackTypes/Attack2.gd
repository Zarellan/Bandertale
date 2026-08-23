extends Attacks


var attackIndexes = 0
var spikeArr = []

func _ready() -> void:
	#boxSize = Vector2(500,300)
	#boxPos = Vector2(325,235)
	attackTimer = 20

func PrepareAttack():
	#TweenUtils.tweenY(fightHandler.enemy,20,0.3,TweenUtils.Ease.OutCirc)
	fightHandler.enemy.headSpr.texture = load("res://Sprites/BanderHead/banderitax face 3.png")
	pass
func StartAttack():
	super._ready()
	super.StartAttack()
	fightHandler.enemy.headSpr.texture = load("res://Sprites/BanderHead/BanderMoon.png")
	TweenUtils.tweenCustom(self,fightHandler.box.box_size,Vector2(500,300),0.3,TweenUtils.Ease.OutCirc,func(val):
		fightHandler.box.box_size = val)
	TweenUtils.tweenX(fightHandler.box,325.0,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(fightHandler.box,235,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(fightHandler.enemy,20,0.3,TweenUtils.Ease.OutCirc)
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	await get_tree().create_timer(0.4).timeout
	while (true):
		CreateSpikeCol()
		attackIndexes += 1
		SpawnBill()
		if (attackIndexes >= 6):
			break
		await get_tree().create_timer(2.1).timeout
	await get_tree().create_timer(3).timeout
	EndTurn()
	pass

func _process(delta: float) -> void:
	for i in range(spikeArr.size()):
		spikeArr[i].global_position.x -= 100 * delta

	pass

func CreateSpikeCol():
	for i in range(20):
		if (i > 9 && i < 13):
			continue
		var spike = load("res://Scripts/Projectiles/Spikes/Spikes.tscn").instantiate()
		fightHandler.box.clipOnly.add_child(spike)
		spike.global_scale = Vector2(1.5,1.4)
		spike.global_position = Vector2(fightHandler.box.GetRightCorner(),375 - (i*spike.sprite.texture.get_height()))
		spikeArr.append(spike)

func SpawnBill():
	var bill = load("res://Scripts/Projectiles/BulletBill/BulletBill.tscn").instantiate()
	add_child(bill)
	bill.position = Vector2(800,randf_range(300,310))
	bill.scale = Vector2(1.8,1.8)
	bill.movPlace = Vector2(-280,0)
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Bill/billfire.wav",0)

func EndTurn():
	for i in range(spikeArr.size()):
		spikeArr[i].queue_free()
	spikeArr.clear()
	TweenUtils.tweenY(fightHandler.enemy,172.0,0.3,TweenUtils.Ease.OutCirc)
	super.EndTurn()
	
