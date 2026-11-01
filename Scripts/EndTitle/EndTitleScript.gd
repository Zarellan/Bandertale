extends Node2D

@export var textDialogue:RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudio.PlayOneShot("res://Sounds/IntroSound.ogg")
	
	await get_tree().create_timer(1).timeout
	textDialogue.startDialogue("Thank you for playing the demo",0.06,"res://Sounds/Dialogues/Text2.wav", 4,"english",true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
