extends Node3D

@onready var chip1 = preload("res://3D/1chip.blend")
@onready var chip5 = preload("res://3D/5chip.blend")
@onready var chip25 = preload("res://3D/25chip.blend")
@onready var chip50 = preload("res://3D/50chip.blend")
@onready var chip100 = preload("res://3D/100chip.blend")

@onready var _1_chip_holder: Node3D = $"1ChipHolder"
@onready var _5_chip_holder: Node3D = $"5ChipHolder"
@onready var _25_chip_holder: Node3D = $"25ChipHolder"
@onready var _50_chip_holder: Node3D = $"50ChipHolder"
@onready var _100_chip_holder: Node3D = $"100ChipHolder"

@onready var red: Node3D = $Red
@onready var black: Node3D = $Black


var bet_amount := 0
var money := 50
var bet = null

const STACK_HEIGHT := 0.018


func _ready():
	update_holder_chips()
	update_bet_chips()


func _on_button_pressed() -> void:
	if $roulette.color and bet:
		$roulette.start_spin()
		$roulette.start_ball()


func check_result():
	if $roulette.color == bet:
		money += bet_amount * 2

	bet_amount = 0
	bet = null

	update_holder_chips()
	update_bet_chips()

	$CanvasLayer/Bet.text = str(bet_amount)
	$CanvasLayer/Label.text = str(money)


func _on_up_pressed() -> void:
	if money > 0:
		money -= 1
		bet_amount += 1

		if bet:
			update_holder_chips()
		update_bet_chips()

		$CanvasLayer/Bet.text = str(bet_amount)
		$CanvasLayer/Label.text = str(money)


func _on_down_pressed() -> void:
	if bet_amount > 0:
		bet_amount -= 1
		money += 1

		if bet:
			update_holder_chips()

		update_bet_chips()

		$CanvasLayer/Bet.text = str(bet_amount)
		$CanvasLayer/Label.text = str(money)


func update_holder_chips():
	clear_holder()

	render_chips(_100_chip_holder, money / 100, chip100)
	render_chips(_50_chip_holder, (money % 100) / 50, chip50)
	render_chips(_25_chip_holder, (money % 50) / 25, chip25)
	render_chips(_5_chip_holder, (money % 25) / 5, chip5)
	render_chips(_1_chip_holder, money % 5, chip1)


func update_bet_chips():

	for child in red.get_children():
		child.queue_free()

	for child in black.get_children():
		child.queue_free()

	if bet == "red":
		render_value(red, bet_amount)

	elif bet == "black":
		render_value(black, bet_amount)


func render_value(parent: Node3D, amount: int):

	var values = [100, 50, 25, 5, 1]
	var scenes = {
		100: chip100,
		50: chip50,
		25: chip25,
		5: chip5,
		1: chip1
	}

	var height := 0.0

	for value in values:

		var count = amount / value

		for i in count:

			var chip = scenes[value].instantiate()

			parent.add_child(chip)

			chip.position = Vector3(0, height, 0)

			height += STACK_HEIGHT

		amount %= value


func render_chips(parent: Node3D, amount: int, scene):

	for i in amount:

		var chip = scene.instantiate()

		parent.add_child(chip)

		chip.position = Vector3(
			0,
			i * STACK_HEIGHT,
			0
		)


func clear_holder():

	for holder in [
		_1_chip_holder,
		_5_chip_holder,
		_25_chip_holder,
		_50_chip_holder,
		_100_chip_holder
	]:
		for child in holder.get_children():
			child.queue_free()
