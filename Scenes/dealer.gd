extends Node3D


func deal():
	$AnimationPlayer.play("spin")
	
func place():
	$AnimationPlayer.play("place")



@onready var label: RichTextLabel = $CanvasLayer/RichTextLabel

var dialogue := [
"Welcome, challenger. I am the dealer. Allow me to explain the rules before we begin.",
"You may bet on red, black, odd, even, 1–18, or 19–36; these pay double. You may also bet on 1st, 2nd, or 3rd twelve, or any column; these pay 2 to 1.",
"After the roulette outcome is determined, you may purchase cards that influence the result. Their prices are shown beneath them.",
"When you are ready, press OK to continue. After that, the board phase begins.",
"Figures move forward when they cannot attack. Sword wielders attack one space ahead; bow wielders attack two spaces away.",
"Figures have 3 health. Reaching the end of the board deals damage to my health and removes the figure.",
"Houses spawn a sword wielder every 3 turns if the space ahead is free. You may buy and place figures by dragging them onto the board (you: 1–12, me: 25+).",
"Each round may include a special roulette ball: damage destroys all figures and affects the next horizontally and verticaly; healing restores instead.",
"All key information (ball, funds, and both health pools) is shown on the television. Bets can be removed with right click.",
"That concludes the rules. Try your luck. The house always wins... eventually. Good luck."
]
var line_index := 0

var typing := false
var full_text := ""

var speed := 0.03


func _ready() -> void:


	line_index = 0

	show_line()


func show_line():

	if line_index >= dialogue.size():
		label.text = ""
		$CanvasLayer.queue_free()
		return

	full_text = dialogue[line_index]

	label.text = ""
	typing = true

	type_text()


func type_text():

	for c in full_text:

		if !typing:
			label.text = full_text
			return

		label.text += c

		await get_tree().create_timer(speed).timeout

	typing = false


func next_line():

	# If still typing → finish instantly
	if typing:
		typing = false
		return

	# Move to next line
	line_index += 1
	show_line()


func _on_button_pressed() -> void:
	next_line()


func _on_button_2_pressed() -> void:
	$CanvasLayer.queue_free()
