extends Attacks


func _ready() -> void:
	boxSize = Vector2(300,150)
	attackTimer = 4

func StartAttack():
	super._ready()
	super.StartAttack()
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.red)
	var bulletTest = load("res://Scripts/Projectiles/projectile.tscn").instantiate()
	bulletTest.position = Vector2(300,300)
	add_child(bulletTest)
	pass
