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

var money := 20
var bet_amount := 0

var dealer_health = 3
var player_health = 3

var rounds := 0

var columns = {
	1: [25, 28, 31, 34],
	2: [26, 29, 32, 35],
	3: [27, 30, 33, 36]
}

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
	19: "red",
	20: "black",
	21: "red",
	22: "black",
	23: "red",
	24: "black",
	25: "red",
	26: "black",
	27: "red",
	28: "black",
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
	place_figure(2, "house", "player")

	place_figure(35, "house", "dealer")


	update_all()
	randomize_cards()


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

	if money <= 0:
		money = 1
		

	update_all()



	if ball == 1 and result != 0:
		heal_area(result)
	elif ball == 2 and result != 0:
		damage_area(result)
		
	
	result = -1 

	await get_tree().create_timer(.5).timeout
	for i in $Figures.get_children():
		print(i)
		if i:
			if i.has_method("move"):
				await i.move()
	for i in $Buildings.get_children():
		if i:
			if i.has_method("move"):
				await i.move()
	

			
	



func place_bet(name):

	if bet_amount <= 0:
		return

	$Sounds/down.play()
	bets[name] += bet_amount

	bet_amount = 0

	update_all()


func remove_bet(name):

	money += bets[name]
	if bets[name] != 0:
		$Sounds/up.play()

	bets[name] = 0


	update_all()


func update_all():

	update_holder_chips()
	update_bet_chips()

	$Label3D4.text = str(bet_amount)
	$SubViewportContainer/SubViewport/Label.text = str(money)


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


	var figure = sword_model.instantiate()
	if model == "bow":
		figure = bow_model.instantiate()
	elif model == "house":
		figure = house_model.instantiate()
	figure.side = side
	
	if model == "sword" or model == "bow":
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
	var tile_size_z = 0.180


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
	place_figure(n, "sword", side)
	
func heal_area(n):
	var tiles = [n, n + 1, n - 1, n + 3, n - 3]
	if n == 1:
		tiles = [n, n + 1, n + 3]
	elif n == 3:
		tiles = [n, n - 1, n + 3]
	elif n == 34:
		tiles = [n, n + 1, n - 3]
	elif n == 36:
		tiles = [n, n - 1, n - 3]
	elif n == 2:
		tiles = [n, n + 1, n - 1, n + 3]
	elif n == 35:
		tiles = [n, n + 1, n - 1, n - 3]
	elif n % 3 == 1:
		tiles = [n, n + 1, n + 3, n - 3]
	elif n % 3 == 0:
		tiles = [n, n - 1, n + 3, n - 3]
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
	if n == 1:
		tiles = [n, n + 1, n + 3]
	elif n == 3:
		tiles = [n, n - 1, n + 3]
	elif n == 34:
		tiles = [n, n + 1, n - 3]
	elif n == 36:
		tiles = [n, n - 1, n - 3]
	elif n == 2:
		tiles = [n, n + 1, n - 1, n + 3]
	elif n == 35:
		tiles = [n, n + 1, n - 1, n - 3]
	elif n % 3 == 1:
		tiles = [n, n + 1, n + 3, n - 3]
	elif n % 3 == 0:
		tiles = [n, n - 1, n + 3, n - 3]
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


func draw_card(pos, type, value, text):
	var card = card_model.instantiate()
	$Sounds/draw.play()

	card.rotation.y = deg_to_rad(270)
	card.rotation.z = deg_to_rad(180)
	
	card.effect_type = card.EffectType["ADD"] if type == "add" else card.EffectType["MULTIPLY"]
	card.effect_value = value
	card.look = text
	card.cost = randi_range(5, 15)
	

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
	$Sounds/buy.play()
	update_all()
	
func randomize_cards():
	for card in $CardPile.get_children():
		var data = card.get_random_card_data()
		card.effect_type = card.EffectType["ADD"] if data.type == "add" else card.EffectType["MULTIPLY"]
		card.effect_value = data.value
		card.look = data.texture
		card.cost = randi_range(5, 15)
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
	$SubViewportContainer/SubViewport/ResultLabel.visible = true
	$SubViewportContainer/SubViewport/Panel.visible = true
	$SubViewportContainer/SubViewport/ResultLabel.text = str(int(n))
	var style = $SubViewportContainer/SubViewport/Panel.get_theme_stylebox("panel").duplicate()
	if color_table[int(n)] == "red":
		style.bg_color = Color(0.686, 0.063, 0.0, 1.0)
	elif color_table[int(n)] == "black":
		style.bg_color = Color(0.073, 0.073, 0.073, 1.0)
	else:
		style.bg_color = Color(0.075, 0.431, 0.075, 1.0)
	$SubViewportContainer/SubViewport/Panel.add_theme_stylebox_override("panel", style)
	
func hide_result():
	$SubViewportContainer/SubViewport/ResultLabel.visible = false
	$SubViewportContainer/SubViewport/Panel.visible = false
	
func choose_ball():
	var r = randf() # 0.0 - 1.0
	if r < 0.5:
		return 1
	else:
		return 2


func damage_dealer():
	dealer_health -= 1
	$SubViewportContainer/SubViewport/DealerBar.value = dealer_health
	if dealer_health <= 0:
		end("win")
		print("dealer dead")
		
func damage_player():
	player_health -= 1
	$SubViewportContainer/SubViewport/PlayerBar.value = player_health
	if player_health <= 0:
		end("lose")
		print("player dead")
		
func end(outcome):
	$CanvasLayer/EndCurtain.mouse_filter = Control.MOUSE_FILTER_STOP
	$CanvasLayer/Replay.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/EndCurtain, "color", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	tween.parallel().tween_property($CanvasLayer/Replay, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	if outcome == "win":
		tween.parallel().tween_property($CanvasLayer/WinLabel, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	else:
		tween.parallel().tween_property($CanvasLayer/LoseLabel, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	

func _on_replay_pressed() -> void:
	get_tree().reload_current_scene()


func _on_button_1_pressed() -> void:
	if money > 0 and bet_amount < 20:
		money -= 1
		bet_amount += 1
		update_all()
	

func _on_button_12_pressed() -> void:
	if bet_amount > 0:
		bet_amount -= 1
		money += 1
		update_all()


func _on_button_10_pressed() -> void:
	var add_amount = 10

	var allowed = min(add_amount, money)

	bet_amount += allowed
	money -= allowed

	if bet_amount > 20:
		var overflow = bet_amount - 20
		bet_amount = 20
		money += overflow  

	update_all()


func _on_button_101_pressed() -> void:
	if bet_amount-10 > 0:
		bet_amount -= 10
		money += 10
	else:
		money += bet_amount
		bet_amount = 0
	update_all()


func _on_button_ok_pressed() -> void:
	if result >= 0:
		rounds += 1
		
		await check_result()
		check_rounds()
		ball = choose_ball()

		for i in $SubViewportContainer/SubViewport/NextBallNode.get_children():
			i.visible = false
		if ball != 0:
			$SubViewportContainer/SubViewport/NextBallNode/NextBall.visible = true
		if ball == 1:
			$SubViewportContainer/SubViewport/NextBallNode/HealImage.visible = true
		elif ball == 2:
			$SubViewportContainer/SubViewport/NextBallNode/DamageImage.visible = true
			


		return
		
	if $roulette.ball_stopped:

		var total := 0

		for b in bets.values():
			total += b

		if total > 0:
			
			hide_result()
			$dealer.deal()
			await get_tree().create_timer(1).timeout
			$roulette.start_spin()
			$roulette.start_ball()

			
func check_rounds():
	if rounds % 11 == 0:
		$dealer.place()
		await get_tree().create_timer(1).timeout
		try_spawn_dealer("house")
		
	elif rounds % 7 == 0:
		$dealer.place()
		await get_tree().create_timer(1).timeout
		try_spawn_dealer("bow")

	elif rounds % 3 == 0:
		$dealer.place()
		await get_tree().create_timer(1).timeout
		try_spawn_dealer("sword")

	
func try_spawn_dealer(item_name: String):

	var column_score = {
		1: {"player": 0, "dealer": 0},
		2: {"player": 0, "dealer": 0},
		3: {"player": 0, "dealer": 0}
	}

	# FULL BOARD SCAN
	for tile in figures.keys():

		var col = (tile - 1) % 3 + 1

		if figures[tile].side == "player":
			column_score[col]["player"] += 1
		elif figures[tile].side == "dealer":
			column_score[col]["dealer"] += 1


	# PICK ADVANTAGE COLUMNS
	var best_columns = []

	for col in column_score.keys():
		if column_score[col]["player"] > column_score[col]["dealer"]:
			best_columns.append(col)

	# fallback if no advantage columns
	if best_columns.is_empty():
		best_columns = [1, 2, 3]

	best_columns.shuffle()


	# TRY PLACE IN BOTTOM 4 ONLY
	for col in best_columns:

		var available = []

		for tile in columns[col]:
			if !figures.has(tile):
				available.append(tile)

		if available.is_empty():
			continue

		var chosen_tile = available.pick_random()

		place_figure(chosen_tile, item_name, "dealer")
		return
			
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:

		if event.keycode == KEY_N:
			var sfx_bus = AudioServer.get_bus_index("SFX")
			print(sfx_bus)
			var muted = AudioServer.is_bus_mute(sfx_bus)
			AudioServer.set_bus_mute(sfx_bus, !muted)

		if event.keycode == KEY_M:
			var music_bus = AudioServer.get_bus_index("Music")
			var muted = AudioServer.is_bus_mute(music_bus)
			AudioServer.set_bus_mute(music_bus, !muted)
			
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
