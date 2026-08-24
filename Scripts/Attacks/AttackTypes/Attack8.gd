extends Attacks


var attackIndexes = 0

var lava
var warn
var aud
var bringLav:bool = false
var proj
var bringFakeLav:bool = false
func _ready() -> void:
	boxSize = Vector2(300,150)
	attackTimer = 20

func StartAttack():
	super._ready()
	super.StartAttack()
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	TweenUtils.tweenCustom(self,fightHandler.box.box_size,Vector2(300,700),0.3,TweenUtils.Ease.OutCirc,func(val):
		fightHandler.box.box_size = val)
	TweenUtils.tweenY(fightHandler.box,30,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenX(fightHandler.enemy.get_node("SpriteHolder"),-150,0.3,TweenUtils.Ease.OutCirc)
	fightHandler.camera.enabled = false
	fightHandler.soul.get_node("GameCamera").enabled = true
	LavaPass()
	
	
	
	await get_tree().create_timer(1).timeout
	proj = load("res://Scripts/Projectiles/projectile.tscn").instantiate()
	fightHandler.box.clipOnly.add_child(proj)
	proj.get_node("Sprite2D").offset = Vector2(0,-proj.get_node("Sprite2D").texture.get_height() * 0.5)
	proj.global_scale = Vector2(5,0)
	proj.global_position = Vector2(proj.global_position.x,380)
	proj.modulate = Color(18.892, 18.892, 18.892, 1.0)
	while (true):
		SpawnBill(Vector2(800,300 - (attackIndexes*50)))
		attackIndexes += 1
		if (attackIndexes >= 14):
			break
		await get_tree().create_timer(0.88).timeout
	EndTurn()
	pass

func _process(delta: float) -> void:
	if (bringLav):
		lava.position.y -= 2.5 * delta
	if (is_instance_valid(proj) && bringFakeLav):
		proj.global_scale += Vector2(0,0.43) * delta
	pass

func LavaPass():
	await get_tree().create_timer(1).timeout
	warn = load("res://Prefabs/warningSign/WarningSign.tscn").instantiate()
	add_child(warn)
	warn.position = Vector2(324,338)
	warn.scale = Vector2(4.7,1.36)
	aud = GlobalAudio.PlayOneShot("res://Sounds/WarningSound/warning sound.ogg")
	await get_tree().create_timer(1).timeout
	warn.queue_free()
	aud.stop()
	PrepareLava()
	await get_tree().create_timer(2).timeout
	bringFakeLav = true
	

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

func SpawnBill(pos:Vector2):
	var bill = load("res://Scripts/Projectiles/BulletBill/BulletBill.tscn").instantiate()
	add_child(bill)
	bill.position = pos
	bill.scale = Vector2(1.8,1.8)
	bill.movPlace = Vector2(-280,0)
	GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Bill/billfire.wav",0)
func PrepareLava():
	lava = load("res://Scripts/Projectiles/Lava/Lava2.tscn").instantiate()
	fightHandler.box.clipOnly.add_child(lava)
	lava.global_scale = Vector2(2.3,1.2)
	lava.global_position = Vector2(325,500)
	bringLav = true
	#TweenUtils.tweenCustom(self,lava.global_position.y,400,0.9,TweenUtils.Ease.OutCirc,func(val):
		#lava.global_position.y = val)

func EndTurn():
	fightHandler.camera.enabled = true
	fightHandler.soul.get_node("GameCamera").enabled = false
	lava.queue_free()
	proj.queue_free()
	TweenUtils.tweenX(fightHandler.enemy.get_node("SpriteHolder"),0,0.3,TweenUtils.Ease.OutCirc)
	super.EndTurn()
