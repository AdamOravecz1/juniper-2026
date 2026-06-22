extends Node3D

@onready var chip1 = preload("res://3D/1chip.blend")
@onready var chip5 = preload("res://3D/5chip.blend")
@onready var chip25 = preload("res://3D/25chip.blend")
@onready var chip50 = preload("res://3D/50chip.blend")
@onready var chip100 = preload("res://3D/100chip.blend")

@onready var house_model = preload("res://Scenes/house.tscn")
@onready var sword_model = preload("res://Scenes/sword_guy.tscn")
@onready var bow_model = preload("res://Scenes/bow_guy.tscn")

@onready var _1_chip_holder = $"1ChipHolder"
@onready var _5_chip_holder = $"5ChipHolder"
@onready var _25_chip_holder = $"25ChipHolder"
@onready var _50_chip_holder = $"50ChipHolder"
@onready var _100_chip_holder = $"100ChipHolder"

@onready var red = $Red
@onready var black = $Black
@onready var odd = $Odd
@onready var even = $Even

@onready var low = $"1to18"
@onready var high = $"19to36"

@onready var first12 = $"1st12"
@onready var second12 = $"2nd12"
@onready var third12 = $"3rd12"

@onready var col1 = $Column1
@onready var col2 = $Column2
@onready var col3 = $Column3

var figures = {}

var money := 50
var bet_amount := 0

var bets = {
	"red":0,
	"black":0,
	"odd":0,
	"even":0,
	"low":0,
	"high":0,
	"first12":0,
	"second12":0,
	"third12":0,
	"col1":0,
	"col2":0,
	"col3":0
}

const STACK_HEIGHT := 0.018


func _ready():
	update_all()
	place_figure(32, sword_model, "enemy")
	place_figure(11, bow_model, "player")
	
func _on_button_pressed():
	print(figures)

	if $roulette.ball_stopped:

		var total := 0

		for b in bets.values():
			total += b

		if total > 0:
			$roulette.start_spin()
			$roulette.start_ball()


func check_result():

	var n = $roulette.result

	if $roulette.color == "red":
		money += bets.red * 2

	elif $roulette.color == "black":
		money += bets.black * 2


	if n != 0:

		if n % 2 == 0:
			money += bets.even * 2
		else:
			money += bets.odd * 2


		if n <= 18:
			money += bets.low * 2
		else:
			money += bets.high * 2


		if n <= 12:
			money += bets.first12 * 3
		elif n <= 24:
			money += bets.second12 * 3
		else:
			money += bets.third12 * 3


		match ((n - 1) % 3):

			0:
				money += bets.col1 * 3

			1:
				money += bets.col2 * 3

			2:
				money += bets.col3 * 3


	for key in bets:
		bets[key] = 0


	update_all()
	
	#if n != 0:
		#place_figure(n, sword_model, "player")
	
	for i in $Figures.get_children():
		if i.has_method("move"):
			await i.move()
	for i in $Buildings.get_children():
		if i.has_method("move"):
			await i.move()
	



func _on_up_pressed():

	if money > 0:
		money -= 1
		bet_amount += 1
		update_all()


func _on_down_pressed():

	if bet_amount > 0:
		bet_amount -= 1
		money += 1
		update_all()


func place_bet(name):

	if bet_amount <= 0:
		return

	bets[name] += bet_amount

	bet_amount = 0

	update_all()


func remove_bet(name):

	money += bets[name]

	bets[name] = 0

	update_all()


func update_all():

	update_holder_chips()
	update_bet_chips()

	$CanvasLayer/Bet.text = str(bet_amount)
	$CanvasLayer/Label.text = str(money)


func update_bet_chips():

	var mapping = {
		"red": red,
		"black": black,
		"odd": odd,
		"even": even,
		"low": low,
		"high": high,
		"first12": first12,
		"second12": second12,
		"third12": third12,
		"col1": col1,
		"col2": col2,
		"col3": col3
	}


	for node in mapping.values():

		for child in node.get_children():

			child.queue_free()


	for key in bets.keys():

		render_value(
			mapping[key],
			bets[key]
		)


func update_holder_chips():

	clear_holder()

	render_chips(_100_chip_holder, money / 100, chip100)
	render_chips(_50_chip_holder, (money % 100) / 50, chip50)
	render_chips(_25_chip_holder, (money % 50) / 25, chip25)
	render_chips(_5_chip_holder, (money % 25) / 5, chip5)
	render_chips(_1_chip_holder, money % 5, chip1)


func render_value(parent, amount):

	var values = [100,50,25,5,1]

	var scenes = {
		100:chip100,
		50:chip50,
		25:chip25,
		5:chip5,
		1:chip1
	}

	var height := 0.0

	for value in values:

		var count = amount / value

		for i in count:

			var chip = scenes[value].instantiate()

			parent.add_child(chip)

			chip.position = Vector3(
				0,
				height,
				0
			)

			height += STACK_HEIGHT

		amount %= value


func render_chips(parent, amount, scene):

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
			

func place_figure(tile_number, model, side):

	# remove old house if exists
	if figures.has(tile_number):

		if is_instance_valid(figures[tile_number]):
			figures[tile_number].queue_free()


	var figure = model.instantiate()
	figure.side = side
	
	if model == sword_model:
		$Figures.add_child(figure)
	else:
		$Buildings.add_child(figure)
	
	if figure.has_signal("moved_finished"):
		figure.moved_finished.connect(_on_figure_moved_finished.bind(figure))

	figure.pos = tile_number


	var start = $OnePos.global_position

	var cols = 3

	var x = (tile_number - 1) % cols
	var z = (tile_number - 1) / cols

	var tile_size_x = 0.259
	var tile_size_z = 0.184


	figure.global_position = start + Vector3(
		x * tile_size_x,
		0,
		z * tile_size_z
	)

	figures[tile_number] = figure
	
func _on_figure_moved_finished(new_tile, figure):

	# remove old entry
	for key in figures.keys():
		if figures[key] == figure:
			figures.erase(key)
			break

	# add new entry
	figures[new_tile] = figure
	
func spawn_guy(n, side):
	place_figure(n, sword_model, side)
