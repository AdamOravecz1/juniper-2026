extends Node3D
@onready var roulette = get_tree().get_first_node_in_group("roulette")

func _on_red_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and roulette.ball_stopped and get_parent().bet_amount > 0:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			get_parent().bet = "red"
			get_parent().update_bet_chips()
			get_parent().update_holder_chips()
			print("RED")


func _on_black_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and roulette.ball_stopped and get_parent().bet_amount > 0:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			get_parent().bet = "black"
			get_parent().update_bet_chips()
			get_parent().update_holder_chips()
			print("BLACK")
