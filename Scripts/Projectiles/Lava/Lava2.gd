extends Area2D

var isTouching:bool = false
var fightHandler:FightHandler
var gotHurt = false
func _ready() -> void:
	fightHandler = get_tree().get_first_node_in_group("FightHandler")
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isTouching && !gotHurt:
		gotHurt = fightHandler.DamageSoul(30,0.7)
		fightHandler.soul.velocity = Vector2(0,-700)
		GlobalAudio.PlayOneShot("res://Sounds/MarioSounds/lava"+str(randi_range(1,3))+".wav")
		await get_tree().create_timer(0.7).timeout
		gotHurt = false
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		set_process(true)
		isTouching = true
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Soul"):
		set_process(false)
		isTouching = false
	pass # Replace with function body.
