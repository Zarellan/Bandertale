extends Attacks


var attackIndexes = 0
var spikeArr = []
var spikeInc = 2
var gotHit = false
func _ready() -> void:
	boxSize = Vector2(500,170)
	#boxPos =  Vector2(325,307-100)
	attackTimer = 20

func PrepareAttack():
	#TweenUtils.tweenY(fightHandler.enemy,20,0.3,TweenUtils.Ease.OutCirc)
	SpikesPlaytime.gotHit = false
	pass
func StartAttack():
	super._ready()
	super.StartAttack()
	#TweenUtils.tweenCustom(self,fightHandler.box.box_size,Vector2(500,300),0.3,TweenUtils.Ease.OutCirc,func(val):
		#fightHandler.box.box_size = val)
	TweenUtils.tweenX(fightHandler.box,325.0,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(fightHandler.box,307-7,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(fightHandler.enemy,172-15,0.3,TweenUtils.Ease.OutCirc)
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	await get_tree().create_timer(0.4).timeout
	SpawnBillTime()
	while (true):
		if (gotHit):
			return
		CreateSpikeCol()
		attackIndexes += 1
		spikeInc += 2
		if (attackIndexes >= 4):
			break
		await get_tree().create_timer(2.1).timeout
	await get_tree().create_timer(1.4).timeout
	if (gotHit):
		return
	GlobalAudio.PlayOneShot("res://Sounds/playtime/Wow! That's great! Let's play again!.wav",-10)
	await get_tree().create_timer(1.5).timeout
	EndTurn()
	pass

func SpawnBillTime():
	await get_tree().create_timer(2.1 * 3 - 0.8).timeout
	if (gotHit):
		return
	SpawnBill()
var cleaned = false
func _process(delta: float) -> void:
	#print(SpikesPlaytime.gotHit)
	if (SpikesPlaytime.gotHit && !cleaned):
		for i in range(spikeArr.size()):
			spikeArr[i].queue_free()
		TweenUtils.tweenShake(fightHandler.camera,5,15,0.2,TweenUtils.Ease.linear)
		spikeArr.clear()
		gotHit = true
		cleaned = true
		GlobalAudio.PlayOneShot("res://Sounds/playtime/messedUp.mp3",-10)
		await get_tree().create_timer(1.4).timeout
		EndTurn()
	for i in range(spikeArr.size()):
		spikeArr[i].global_position.x -= 300 * delta
	pass

func CreateSpikeCol():
	for i in range(spikeInc):
		var spike = load("res://Scripts/Projectiles/Spikes/SpikesPlaytime.tscn").instantiate()
		fightHandler.box.clipOnly.add_child(spike)
		spike.global_scale = Vector2(1.5,1.4)
		spike.global_position = Vector2(fightHandler.box.GetRightCorner(),375 - (i*spike.sprite.texture.get_height()))
		spikeArr.append(spike)
	GlobalAudio.PlayOneShot("res://Sounds/playtime/"+str(attackIndexes+1)+".wav",-10)

func SpawnBill():
	var bill = load("res://Scripts/Projectiles/BulletBill/BulletBill.tscn").instantiate()
	add_child(bill)
	bill.position = Vector2(640,randf_range(300,310))
	bill.scale = Vector2(1.8,1.8)
	bill.movPlace = Vector2(-300,0)
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Bill/billfire.wav",0)

func EndTurn():
	for i in range(spikeArr.size()):
		spikeArr[i].queue_free()
	spikeArr.clear()
	TweenUtils.tweenY(fightHandler.enemy,172.0,0.3,TweenUtils.Ease.OutCirc)
	super.EndTurn()
	
