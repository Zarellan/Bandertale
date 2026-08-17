extends Attacks


func _ready() -> void:
	boxSize = Vector2(500,150)
	attackTimer = 0.4

var bullet
func StartAttack():
	super._ready()
	super.StartAttack()
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.red)
	bullet = load("res://Scripts/Projectiles/projectile.tscn").instantiate()
	bullet.position = Vector2(300,300)
	add_child(bullet)
	pass

func _process(delta: float) -> void:
	if (is_instance_valid(bullet)):
		bullet.position.y = fightHandler.box.GetUpCorner()
