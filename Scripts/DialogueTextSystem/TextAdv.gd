extends RichTextLabel
class_name TextAdv

@export var speed = 0.08

var maxLength;
var diagTimer;
var textMain
var commandText
var bBCodeText


var commands = []
var partsNum = []
var must_event = []

var reach = 0
var incIgnoreBBC = 0
var bbcode_offset = 0

var waitTimeTween;

var paused = false

var finishedDial:bool = false

var timerWait:Timer

var audioType:String = ""
var volumeDialogueDB:int = 0
func _ready() -> void:
	timerWait = Timer.new()
	timerWait.one_shot = true
	timerWait.autostart = false
	add_child(timerWait)
	timerWait.timeout.connect(_continue_dialogue)
	#startDialogue("welcome to the [wait,0.5][wave amp=50][rainbow]Signal Drift")
	pass


func _process(_delta: float) -> void:
	#print($".".visible_characters)
	#print($".".maxLength)
	pass

func startDialogue(textChr, sped = 0.06, audioT = "", volDBDiag = 0, lang = "english"):
	$".".text = textChr
	if diagTimer and diagTimer.is_valid():
		diagTimer.kill()
	if !timerWait.is_stopped():
		timerWait.stop()
	paused = false
	finishedDial = false
	bbcode_offset = 0
	$".".visible_characters = 0
	textMain = textChr
	commandText = textChr
	bBCodeText = textChr
	audioType = audioT
	volumeDialogueDB = volDBDiag
	if (lang == "english"):
		horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		add_theme_font_override("normal_font", load("res://Fonts/DeterminationMonoWebRegular-Z5oq.ttf"))
	elif (lang == "arabic"):
		horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		add_theme_font_override("normal_font", load("res://Fonts/PixelAE-Regular.ttf"))
	RemoveBBCodes()
	reach = 0
	incIgnoreBBC = 0
	event_system()
	RemoveCommands()
	maxLength = strippedLength(bBCodeText)
	$".".text = bBCodeText
	event_checker()
	speed = sped
	diag()
	pass

func RemoveCommands(): # commands to remove
	var regex_speed = RegEx.new()
	regex_speed.compile("\\[speed\\s*,\\s*[^\\]]*\\]")
	var regex_wait = RegEx.new()
	regex_wait.compile("\\[wait\\s*,\\s*[^\\]]*\\]")
	var regex_func = RegEx.new()
	regex_func.compile("\\[func\\s*,\\s*[^\\]]*\\]")
	bBCodeText = regex_speed.sub(bBCodeText, "", true)
	bBCodeText = regex_wait.sub(bBCodeText, "", true)
	bBCodeText = regex_func.sub(bBCodeText, "", true)

func RemoveBBCodes(): # BBCodes to remove
	var regex_open = RegEx.new()
	regex_open.compile("\\[wave[^\\]]*\\]")

	var regex_close = RegEx.new()
	regex_close.compile("\\[/wave\\]")
	
	var regex_open_rainbow = RegEx.new()
	regex_open_rainbow.compile("\\[rainbow[^\\]]*\\]")
	
	var regex_close_rainbow = RegEx.new()
	regex_close_rainbow.compile("\\[/rainbow\\]")

	commandText = regex_open.sub(commandText, "", true)
	commandText = regex_close.sub(commandText, "", true)
	commandText = regex_open_rainbow.sub(commandText, "", true)
	commandText = regex_close_rainbow.sub(commandText, "", true)

func diag():
	if (paused): return
	$".".visible_characters += 1
	reach += 1
	if (!audioType.is_empty() && maxLength >= $".".visible_characters):
		GlobalAudio.PlayOneShot(audioType,volumeDialogueDB)
	event_checker()
	diagTimer = create_tween()
	diagTimer.tween_interval(speed)
	diagTimer.finished.connect(_diag_finished)

func ForceFinish():
	if ((!is_instance_valid(diagTimer) || !diagTimer.is_valid()) && timerWait.is_stopped()):
		return
	if is_instance_valid(diagTimer) and diagTimer.is_valid():
		diagTimer.kill()
	if !timerWait.is_stopped():
		timerWait.stop()
	paused = false
	for i in range(0, partsNum.size()):
		if commands[i].begins_with("wait"):
			continue
			
		execute_event(commands[i])
	visible_characters = -1
	dialogue_finished()

func _diag_finished():
	if (maxLength < $".".visible_characters): # must apply max length on 20 later
		dialogue_finished()
	else:
		diag()

func dialogue_finished():
	finishedDial = true


func strippedLength(tex: String) -> int:
	var temp = RichTextLabel.new()
	temp.bbcode_enabled = true
	temp.text = tex
	var le = temp.get_parsed_text().length()
	temp.free()
	return le

var wave_active = false
var rainbow_active = false

func _continue_dialogue():
	paused = false
	diag()

func execute_event(command:String):
	
	var parts: PackedStringArray  = command.split(',')
	var args: PackedStringArray = parts
	match(args[0].strip_edges()):
		"speed": speed = float(args[1])
		"wait":
			if (timerWait.is_stopped()):
				timerWait.stop()
			timerWait.start(float(args[1]))
			paused = true
		"func":
			var method_name = args[1].strip_edges()
			var parameters = []
			for i in range(2, args.size()):
				parameters.append(args[i].strip_edges())
			
			# Search upward through parent nodes until a node has the method
			var target = get_parent()
			while target and not target.has_method(method_name):
				target = target.get_parent()
			
			if target:
				target.callv(method_name, parameters)
			else:
				print("TextAdv Warning: No parent node has method: ", method_name)


		
func event_system():
	commands.clear()
	partsNum.clear()
	remove_rectangle_string(commandText)
	#$".".text = cleanedText
	

var extraNum = 0
func remove_rectangle_string(tex):
	var helloSplit = tex.split('[')
	extraNum = 0

	var remainingText2 = tex
	#var remainingTextWithBBC = tex
	var remainedTextOverridden = ""
	for i in range(helloSplit.size() - 1):
		#var tag = helloSplit[i + 1].substr(0, helloSplit[i + 1].find("]"))
		self.partsNum.append(remainingText2.find("["))
		self.must_event.append(
			helloSplit[i + 1].substr(0, helloSplit[i + 1].find("]")).find("*") != -1
		)

		remainedTextOverridden = helloSplit[i + 1]\
			.substr(0, helloSplit[i + 1].find("]"))\
			.replace("*", "")

		self.commands.append(remainedTextOverridden)
		remainingText2 = remainingText2.substr(
			0,
			remainingText2.find("[")
		) + remainingText2.substr(
			remainingText2.find("]") + 1
		)
	#cleanedText = remainingText2 must fix this


func event_checker():
	for i in range(0, partsNum.size()):
		if (reach == partsNum[i]):
			execute_event(commands[i])
