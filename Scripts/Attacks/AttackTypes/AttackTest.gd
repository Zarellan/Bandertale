extends Attacks


func StartAttack():
	super._ready()
	fightHandler.soul.ChangeSoulType(fightHandler.soul.SoulType.red)
	fightHandler.soul.position = fightHandler.box.position
	TweenUtils.tweenCustom(self,fightHandler.box.box_size,Vector2(200,155.1),0.3,TweenUtils.Ease.OutCirc,func(val):
		fightHandler.box.box_size = val)
	var bulletTest = load("res://Scripts/Projectiles/projectile.tscn").instantiate()
	bulletTest.position = Vector2(300,300)
	add_child(bulletTest)
	super.StartAttack()
	pass
