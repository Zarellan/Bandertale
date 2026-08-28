extends Attacks


var attackIndexes = 0
var attackSpe
var lava
func _ready() -> void:
	boxSize = Vector2(400.0,170)
	attackTimer = 18

func StartAttack():
	super._ready()
	super.StartAttack()
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.blue)
	TweenUtils.tweenY(fightHandler.enemy,205.0-15,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(fightHandler.box,307.0-7,0.3,TweenUtils.Ease.OutCirc)
	attackSpe = load("res://SpecialCasesAttacks/Attack10Spe.tscn").instantiate()
	add_child(attackSpe)
	attackSpe.position = Vector2(400,0)
	await get_tree().create_timer(1.2).timeout
	var warn = load("res://Prefabs/warningSign/WarningSign.tscn").instantiate()
	add_child(warn)
	warn.position = Vector2(324,372)
	warn.scale = Vector2(6.3,0.4)
	var aud = GlobalAudio.PlayOneShot("res://Sounds/WarningSound/warning sound.ogg")
	await get_tree().create_timer(1).timeout
	warn.queue_free()
	aud.stop()
	PrepareLava()
	pass

func _process(delta: float) -> void:
	print(fightHandler.enemy.position.y)
	pass
func _physics_process(delta: float) -> void:
	if (is_instance_valid(attackSpe) && attackSpe.global_position.x >-1239):
		attackSpe.global_position -= Vector2(100*delta,0)
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
	
func PrepareLava():
	lava = load("res://Scripts/Projectiles/Lava/Lava2.tscn").instantiate()
	fightHandler.box.clipOnly.add_child(lava)
	lava.global_scale = Vector2(3.2,1.0)
	lava.global_position = Vector2(325,700)
	TweenUtils.tweenCustom(self,lava.global_position.y,420,0.9,TweenUtils.Ease.OutCirc,func(val):
		lava.global_position.y = val)

func EndTurn():
	TweenUtils.tweenY(fightHandler.enemy,205.0,0.3,TweenUtils.Ease.OutCirc)
	lava.queue_free()
	super.EndTurn()
	fightHandler.soul.get_node("FirePartic").emitting = false
