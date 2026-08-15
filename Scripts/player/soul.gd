extends CharacterBody2D
class_name Soul

enum SoulType
{
	choice,
	red,
	blue
}

@export var soulSprite:Node2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const gravityStrength = 0.8

var soulType:SoulType

func _physics_process(delta: float) -> void:
	
	SoulMovement(delta)
	move_and_slide()

func SoulMovement(delta):
	match (soulType):
		SoulType.red:
			SoulRedMovement(delta)
		SoulType.blue:
			SoulBlueMovement(delta)
		SoulType.choice:
			pass

func SoulRedMovement(_delta):

	# Handle jump.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

	pass

func SoulBlueMovement(delta):
	if not is_on_floor():
		velocity += get_gravity() * gravityStrength * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if (Input.is_action_just_released("ui_accept") && !is_on_floor() && velocity.y < -200):
		velocity.y = 0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func ChangeSoulType(soulT:SoulType):
	match(soulT):
		SoulType.red:
			soulSprite.self_modulate = Color(1,0,0)
		SoulType.blue:
			soulSprite.self_modulate = Color(0,0,1)
	soulType = soulT
	visible = true

func FightEnd():
	soulSprite.self_modulate = Color(1,0,0)
	soulType = SoulType.choice
	velocity = Vector2(0,0)
