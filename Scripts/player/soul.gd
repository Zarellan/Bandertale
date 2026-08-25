extends CharacterBody2D
class_name Soul

enum SoulType
{
	choice,
	red,
	blue,
	idle
}

enum Direction # works on blue soul only
{
	down,#default
	left,
	up,
	right
}

@export var soulSprite:Node2D
@export var fightHandler:FightHandler
var canStopJump = false
const SPEED = 180.0
const JUMP_VELOCITY = -400.0
const gravityStrength = 0.8

var soulType:SoulType
var soulDirections:Direction

var strictSoulBox = true
func _physics_process(delta: float) -> void:
	SoulMovement(delta)
	if (isCrushing):
		CrushSoulProcess()

func SoulMovement(delta):
	match (soulType):
		SoulType.red:
			SoulRedMovement(delta)
		SoulType.blue:
			SoulBlueMovement(delta)
		SoulType.choice:
			pass
		SoulType.idle:
			pass

func SoulRedMovement(_delta):

	var direction_horz := Input.get_axis("ui_left", "ui_right")
	var direction_vert := Input.get_axis("ui_up", "ui_down")
	if direction_horz:
		velocity.x = direction_horz * SPEED
	else:
		velocity.x = 0
	if direction_vert:
		velocity.y = direction_vert * SPEED
	else:
		velocity.y = 0
	ClampSoul()
	move_and_slide()
	pass

func ChangeSoulDirection(dir:Direction):
	soulDirections = dir
	soulSprite.rotation_degrees = dir * 90
	ChangeSoulType(SoulType.blue)

var isCrushing = false
func CrushSoulDirection(dir:Direction):
	ChangeSoulDirection(dir)
	match (dir):
		Direction.down:velocity.y = 800
		Direction.up:velocity.y = -800
		Direction.left:velocity.x = -800
		Direction.right:velocity.x = 800
		_:
			ChangeSoulDirection(Direction.down)
			velocity.y = 800
	isCrushing = true

func CrushSoulProcess():
	match (soulDirections):
		Direction.down:
			if (position.y + 15 > fightHandler.box.GetDownCorner()):
				TweenUtils.tweenShake(fightHandler.camera,5,15,0.2,TweenUtils.Ease.linear)
				GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Impact.wav")
				isCrushing = false
		Direction.up:
			if (position.y - 15 < fightHandler.box.GetUpCorner()):
				TweenUtils.tweenShake(fightHandler.camera,5,15,0.2,TweenUtils.Ease.linear)
				GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Impact.wav")
				isCrushing = false
		Direction.left:
			if (position.x - 15 < fightHandler.box.GetLeftCorner()):
				TweenUtils.tweenShake(fightHandler.camera,5,15,0.2,TweenUtils.Ease.linear)
				GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Impact.wav")
				isCrushing = false
		Direction.right:
			if (position.x + 15 > fightHandler.box.GetRightCorner()):
				TweenUtils.tweenShake(fightHandler.camera,5,15,0.2,TweenUtils.Ease.linear)
				GlobalAudio.PlayOneShot("res://Sounds/ProjectileSounds/Impact.wav")
				isCrushing = false

func SoulBlueMovement(delta):
	match (soulDirections):
		Direction.down: DownBlueSoul(delta)
		Direction.up: UpBlueSoul(delta)
		Direction.left: LeftBlueSoul(delta)
		Direction.right: RightBlueSoul(delta)
	ClampSoul()
	move_and_slide()

func DownBlueSoul(delta):
	if not is_on_floor():
		velocity += get_gravity() * gravityStrength * delta

	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		canStopJump = true
	if (Input.is_action_just_released("ui_up") && !is_on_floor() && canStopJump && velocity.y < -200):
		velocity.y = 0

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
func UpBlueSoul(delta):
	if not is_on_ceiling():
		velocity -= get_gravity() * gravityStrength * delta

	if Input.is_action_pressed("ui_down") and is_on_ceiling():
		velocity.y = -JUMP_VELOCITY
		canStopJump = true
	if (Input.is_action_just_released("ui_down") && !is_on_ceiling() && canStopJump && velocity.y > 200):
		velocity.y = 0

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
func LeftBlueSoul(delta):
	var touchedWall = CheckWall()["left"]
	if not touchedWall:
		velocity.x -= 980 * gravityStrength * delta

	# Handle jump.
	if Input.is_action_pressed("ui_right") and touchedWall:
		velocity.x = -JUMP_VELOCITY
		canStopJump = true
	if (Input.is_action_just_released("ui_right") && !touchedWall && canStopJump && velocity.x > 200):
		velocity.x = 0

	var direction := Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
func RightBlueSoul(delta):
	var touchedWall = CheckWall()["right"]
	if not touchedWall:
		velocity.x += 980 * gravityStrength * delta

	if Input.is_action_pressed("ui_left") and touchedWall:
		velocity.x = JUMP_VELOCITY
		canStopJump = true
	if (Input.is_action_just_released("ui_left") && !touchedWall && canStopJump && velocity.x < -200):
		velocity.x = 0

	var direction := Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)


func CheckWall():
	var left = false
	var right = false
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		if normal.x > 0.7:
			left = true
		elif normal.x < -0.7:
			right = true
	return {"left":left,"right":right}
func ChangeSoulType(soulT:SoulType):
	match(soulT):
		SoulType.red:
			soulSprite.self_modulate = Color(1,0,0)
		SoulType.blue:
			soulSprite.self_modulate = Color(0,0,1)
	soulType = soulT
	visible = true

func ClampSoul():
	if (!strictSoulBox):
		return
	position = Vector2(clamp(position.x,fightHandler.box.position.x-fightHandler.box.box_size.x/2,fightHandler.box.position.x+fightHandler.box.box_size.x/2),\
	clamp(position.y,fightHandler.box.position.y-fightHandler.box.box_size.y/2,fightHandler.box.position.y+fightHandler.box.box_size.y/2))
func FightEnd():
	soulSprite.self_modulate = Color(1,0,0)
	soulType = SoulType.choice
	velocity = Vector2(0,0)
