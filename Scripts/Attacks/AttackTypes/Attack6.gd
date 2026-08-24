extends Attacks


var attackIndexes = 0

var textToThrow = []
var words = ["حقود","كلب","غبي","[color=red]ابلع","[color=green]تميس","sp"]
var ability = ["","","","deadly","heal",""]
func _ready() -> void:
	boxSize = Vector2(400,150)
	#boxPos =  Vector2(325,307-100)
	attackTimer = 20
	GameOverScript.dialoguesLOL = ["wait\n[wait,0.50]you died ?","you could just cheese it in the corner","that's ok[wait,0.5]\natleast you are learning =)"]

func PrepareAttack():
	#TweenUtils.tweenY(fightHandler.enemy,20,0.3,TweenUtils.Ease.OutCirc)
	
	pass
func StartAttack():
	super._ready()
	super.StartAttack()
	fightHandler.enemy.anim.play("Stop")
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.red)
	while (true):
		if (words.size() <= attackIndexes):
			break
		fightHandler.enemy.StartShake(func():
			if (ability[attackIndexes] == "deadly"):
				ThrowText(words[attackIndexes],false,true)
			elif (ability[attackIndexes] == "heal"):
				ThrowText(words[attackIndexes],true)
			else:
				ThrowText(words[attackIndexes])
			)
		await get_tree().create_timer(2).timeout
	await get_tree().create_timer(2.5).timeout
	EndTurn()
	pass

func _physics_process(delta: float) -> void:
	for i in range(textToThrow.size()):
		if (is_instance_valid(textToThrow[i])):
			textToThrow[i].global_position += textToThrow[i].playerPos * (300 if words[i] != "sp" else 150) * delta
		

func ThrowText(text = "Stupid",isHeal = false,isDeadly = false):
	var ball
	if (text != "sp"):
		ball = load("res://Scripts/Projectiles/TextProjectile/TextProjectile.tscn").instantiate()
	else:
		ball = load("res://Scripts/Projectiles/TextProjectileSpecial/TextProjectileSpecial.tscn").instantiate()
	ball.global_position = fightHandler.enemy.head.global_position 
	ball.playerPos = (fightHandler.soul.global_position - fightHandler.enemy.head.global_position).normalized()
	ball.heal = isHeal
	ball.deadly = isDeadly
	add_child(ball)
	if (text != "sp"):
		ball.SetText(text)
	else:
		ball.scale = Vector2(1.2,1.2)
	textToThrow.append(ball)
	GlobalAudio.PlayOneShot("res://Sounds/BanderVoices/bander speak "+str(randi_range(1,2))+".ogg",7)
	fightHandler.enemy.headSpr.texture = load("res://Sprites/BanderHead/BanderMoon2.png")
	attackIndexes += 1
	await get_tree().create_timer(0.2).timeout
	fightHandler.enemy.headSpr.texture = load("res://Sprites/BanderHead/BanderMoon.png")

func EndTurn():
	fightHandler.enemy.endShake()
	fightHandler.enemy.anim.play("Idle")
	GameOverScript.dialoguesLOL = ["you know[speed,0.5]...","the fangame would do numbers\n[wait,0.7]between 2015-2020","eh[wait,1]\nit's too late now"]
	super.EndTurn()
