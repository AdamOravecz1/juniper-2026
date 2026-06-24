extends Node3D

@onready var chip1 = preload("res://3D/1chip.blend")
@onready var chip5 = preload("res://3D/5chip.blend")
@onready var chip25 = preload("res://3D/25chip.blend")
@onready var chip50 = preload("res://3D/50chip.blend")
@onready var chip100 = preload("res://3D/100chip.blend")

@onready var house_model = preload("res://Scenes/house.tscn")
@onready var sword_model = preload("res://Scenes/sword_guy.tscn")
@onready var bow_model = preload("res://Scenes/bow_guy.tscn")

@onready var card_model = preload("res://Scenes/card.tscn")

@onready var particle_scene = preload("res://Scenes/particle.tscn")

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

var result := -1
var color: String
var ball: int

var money := 50
var bet_amount := 0

var dealer_health = 10
var player_health = 10

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

const color_table := {
	0: "green",
	1: "red",
	2: "black",
	3: "red",
	4: "black",
	5: "red",
	6: "black",
	7: "red",
	8: "black",
	9: "red",
	10: "black",
	11: "black",
	12: "red",
	13: "black",
	14: "red",
	15: "black",
	16: "red",
	17: "black",
	18: "red",
	19: "black",
	20: "black",
	21: "red",
	22: "black",
	23: "red",
	24: "black",
	25: "red",
	26: "black",
	27: "red",
	28: "red",
	29: "black",
	30: "red",
	31: "black",
	32: "red",
	33: "black",
	34: "red",
	35: "black",
	36: "red"
}

const STACK_HEIGHT := 0.018


func _ready():
	update_all()
	randomize_cards()
	
func _on_button_pressed():
	if $roulette.ball_stopped:
		$dealer.deal()
		await get_tree().create_timer(1).timeout

		var total := 0
		hide_result()

		for b in bets.values():
			total += b

		if total > 0:
			$roulette.start_spin()
			$roulette.start_ball()


func check_result():

	var n = result
	

	if color_table[n] == "red":
		money += bets.red * 2

	elif color_table[n] == "black":
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
		

	if ball == 1 and result != 0:
		heal_area(result)
	elif ball == 2 and result != 0:
		damage_area(result)
	elif ball == 3 and result != 0 and n >= 25:
		place_figure(result, sword_model, "enemy")
	elif ball == 4 and result != 0 and n <= 12:
		place_figure(result, sword_model, "player")
	elif ball == 5 and result != 0 and n >= 25:
		place_figure(result, bow_model, "enemy")
	elif ball == 6 and result != 0 and n <= 12:
		place_figure(result, bow_model, "player")
	elif ball == 7 and result != 0 and n >= 25:
		place_figure(result, house_model, "enemy")
	elif ball == 7 and result != 0 and n <= 12:
		place_figure(result, house_model, "player")
		
	for i in $Figures.get_children():
		if i.has_method("move"):
			await i.move()
	for i in $Buildings.get_children():
		if i.has_method("move"):
			await i.move()
			
	result = -1
	



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
	
func heal_area(n):
	var tiles = [n, n + 1, n - 1, n + 3, n - 3]
	var start = $OnePos.global_position
	var cols = 3
	var tile_size_x = 0.259
	var tile_size_z = 0.184
	for tile in tiles:
		# Spawn particle regardless
		var particle = particle_scene.instantiate()
		particle.type = "heal"
		$Particles.add_child(particle)
		var x = (tile - 1) % cols
		var z = (tile - 1) / cols
		particle.global_position = start + Vector3(
			x * tile_size_x,
			0,
			z * tile_size_z
		)
		# Damage only if figure exists
		if figures.has(tile):
			figures[tile].heal()
	
func damage_area(n):
	var tiles = [n, n + 1, n - 1, n + 3, n - 3]
	var start = $OnePos.global_position
	var cols = 3
	var tile_size_x = 0.259
	var tile_size_z = 0.184
	for tile in tiles:
		# Spawn particle regardless
		var particle = particle_scene.instantiate()
		particle.type = "damage"
		$Particles.add_child(particle)
		var x = (tile - 1) % cols
		var z = (tile - 1) / cols
		particle.global_position = start + Vector3(
			x * tile_size_x,
			0,
			z * tile_size_z
		)
		# Damage only if figure exists
		if figures.has(tile):
			figures[tile].hit(3)


func _on_button_2_pressed() -> void:
	if result >= 0:
		check_result()
		ball = choose_ball()
		print(ball)
		for i in $CanvasLayer/NextBallNode.get_children():
			i.visible = false
		if ball != 0:
			$CanvasLayer/NextBallNode/NextBall.visible = true
		if ball == 1:
			$CanvasLayer/NextBallNode/HealImage.visible = true
		elif ball == 2:
			$CanvasLayer/NextBallNode/DamageImage.visible = true
		elif ball == 3:
			$CanvasLayer/NextBallNode/SwordImage.visible = true
			$CanvasLayer/NextBallNode/SwordImage.modulate = Color(1.0, 0.0, 0.0, 1.0)
		elif ball == 4:
			$CanvasLayer/NextBallNode/SwordImage.visible = true
			$CanvasLayer/NextBallNode/SwordImage.modulate = Color(0.0, 0.0, 1.0, 1.0)
		elif ball == 5:
			$CanvasLayer/NextBallNode/BowImage.visible = true
			$CanvasLayer/NextBallNode/BowImage.modulate = Color(1.0, 0.0, 0.0, 1.0)
		elif ball == 6:
			$CanvasLayer/NextBallNode/BowImage.visible = true
			$CanvasLayer/NextBallNode/BowImage.modulate = Color(0.0, 0.0, 1.0, 1.0)
		elif ball == 7:
			$CanvasLayer/NextBallNode/HouseImage.visible = true
			$CanvasLayer/NextBallNode/HouseImage.modulate = Color(1.0, 0.0, 0.0, 1.0)
		elif ball == 8:
			$CanvasLayer/NextBallNode/HouseImage.visible = true
			$CanvasLayer/NextBallNode/HouseImage.modulate = Color(0.0, 0.0, 1.0, 1.0)


func draw_card(pos, type, value, text):
	var card = card_model.instantiate()

	card.rotation.y = deg_to_rad(270)
	card.rotation.z = deg_to_rad(180)
	
	card.effect_type = card.EffectType["ADD"] if type == "add" else card.EffectType["MULTIPLY"]
	card.effect_value = value
	card.look = text
	card.cost = randi_range(1, 10)
	

	$CardPile.add_child(card)
	var tween = get_tree().create_tween()
	var lift = card.global_position + Vector3(0, 0.3, 0)
	# pick up
	tween.tween_property(card,"global_position",lift,0.2)
	# move toward middle
	var middle = (card.global_position +pos) / 2
	middle.y += 0.4
	tween.tween_property(card,"global_position",middle,0.3)
	# flip
	tween.parallel().tween_property(card,"rotation_degrees:z",0,0.3)
	# place on destination
	tween.tween_property(card,"global_position",pos,0.25)
	# settle
	tween.tween_property(card,"rotation_degrees:x",0,0.08)
	
	await tween.finished
	
	var labels = [
		$Label3D,
		$Label3D2,
		$Label3D3
	]

	var closest_label = null
	var closest_dist = INF

	for label in labels:

		var dist = label.global_position.distance_to(card.global_position)

		if dist < closest_dist:
			closest_dist = dist
			closest_label = label


	if closest_label:
		closest_label.text = str(card.cost)

	return card
		
func pay(n):
	money -= n
	update_all()
	
func randomize_cards():
	for card in $CardPile.get_children():
		var data = card.get_random_card_data()
		card.effect_type = card.EffectType["ADD"] if data.type == "add" else card.EffectType["MULTIPLY"]
		card.effect_value = data.value
		card.look = data.texture
		card.cost = randi_range(1, 10)
		card._ready()
		var labels = [
			$Label3D,
			$Label3D2,
			$Label3D3
		]

		var closest_label = null
		var closest_dist = INF

		for label in labels:

			var dist = label.global_position.distance_to(card.global_position)

			if dist < closest_dist:
				closest_dist = dist
				closest_label = label


		if closest_label:
			closest_label.text = str(card.cost)
			
func show_result(n):
	$CanvasLayer/ResultLabel.visible = true
	$CanvasLayer/Panel.visible = true
	$CanvasLayer/ResultLabel.text = str(int(n))
	var style = $CanvasLayer/Panel.get_theme_stylebox("panel").duplicate()
	if color_table[int(n)] == "red":
		style.bg_color = Color(0.686, 0.063, 0.0, 1.0)
	elif color_table[int(n)] == "black":
		style.bg_color = Color(0.073, 0.073, 0.073, 1.0)
	else:
		style.bg_color = Color(0.075, 0.431, 0.075, 1.0)
	$CanvasLayer/Panel.add_theme_stylebox_override("panel", style)
	
func hide_result():
	$CanvasLayer/ResultLabel.visible = false
	$CanvasLayer/Panel.visible = false
	
func choose_ball():
	var r = randf() # 0.0 - 1.0
	if r < 0.5:
		return 0
	elif r < 0.6:
		return 1
	elif r < 0.7:
		return 2
	elif r < 0.75:
		return 3
	elif r < 0.8:
		return 4
	elif r < 0.85:
		return 5
	elif r < 0.9:
		return 6
	elif r < 0.95:
		return 7
	else:
		return 8

func damage_dealer():
	dealer_health -= 1
	if dealer_health >= 0:
		print("dealer dead")
		
func damage_player():
	player_health -= 1
	if player_health >= 0:
		print("player dead")
