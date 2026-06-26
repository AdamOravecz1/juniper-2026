extends Node3D

@onready var roulette = get_tree().get_first_node_in_group("roulette")
@onready var house: Node3D = $house
@onready var bow_guy: Node3D = $bow_guy

@onready var _1: Area3D = $"1"
@onready var _2: Area3D = $"2"
@onready var _3: Area3D = $"3"
@onready var _4: Area3D = $"4"
@onready var _5: Area3D = $"5"
@onready var _6: Area3D = $"6"
@onready var _7: Area3D = $"7"
@onready var _8: Area3D = $"8"
@onready var _9: Area3D = $"9"
@onready var _10: Area3D = $"10"
@onready var _11: Area3D = $"11"
@onready var _12: Area3D = $"12"
@onready var _13: Area3D = $"13"
@onready var _14: Area3D = $"14"
@onready var _15: Area3D = $"15"
@onready var _16: Area3D = $"16"
@onready var _17: Area3D = $"17"
@onready var _18: Area3D = $"18"
@onready var _19: Area3D = $"19"
@onready var _20: Area3D = $"20"
@onready var _21: Area3D = $"21"
@onready var _22: Area3D = $"22"
@onready var _23: Area3D = $"23"
@onready var _24: Area3D = $"24"
@onready var _25: Area3D = $"25"
@onready var _26: Area3D = $"26"
@onready var _27: Area3D = $"27"
@onready var _28: Area3D = $"28"
@onready var _29: Area3D = $"29"
@onready var _30: Area3D = $"30"
@onready var _31: Area3D = $"31"
@onready var _32: Area3D = $"32"
@onready var _33: Area3D = $"33"
@onready var _34: Area3D = $"34"
@onready var _35: Area3D = $"35"
@onready var _36: Area3D = $"36"


@onready var camera = get_viewport().get_camera_3d()
@onready var sword_guy: Node3D = $sword_guy
@onready var sword_area: Area3D = $sword_guy/sword_guy_area



@onready var drop_areas = [
	_1, _2, _3, _4, _5, _6,
	_7, _8, _9, _10, _11, _12
]

var dragging := false

var drag_started_on_sword := false
var start_pos := Vector3.ZERO
var drag_offset := Vector3.ZERO
var drag_plane : Plane
var drag_started_area: Area3D = null

var drag_started_node: Node3D = null

var item_data = {
	"sword": {"node": null, "cost": 5},
	"bow": {"node": null, "cost": 10},
	"house": {"node": null, "cost": 20}
}

func _ready():
	item_data["sword"]["node"] = sword_guy
	item_data["bow"]["node"] = bow_guy
	item_data["house"]["node"] = house

func _process(delta):

	if !dragging:
		return

	var mouse = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mouse)
	var dir = camera.project_ray_normal(mouse)

	var hit = drag_plane.intersects_ray(origin, dir)

	if hit != null and drag_started_node != null:

		drag_started_node.global_position.x = hit.x + drag_offset.x
		drag_started_node.global_position.z = hit.z + drag_offset.z
		drag_started_node.global_position.y = start_pos.y


func bet(event, bet):
	if event is InputEventMouseButton:
		if roulette.ball_stopped:
			if event.pressed:
				if event.button_index == MOUSE_BUTTON_LEFT:
					get_parent().place_bet(bet)
				
				elif event.button_index == MOUSE_BUTTON_RIGHT:
					get_parent().remove_bet(bet)
			

func _on_red_input_event(camera, event, pos, normal, shape):
	bet(event, "red")

func _on_black_input_event(camera, event, pos, normal, shape):
	bet(event, "black")

func _on_odd_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "odd")

func _on_even_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "even")

func _on_to_18_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "low")

func _on_to_36_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "high")


func _on_st_12_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "first12")


func _on_nd_12_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "second12")


func _on_rd_12_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "third12")


func _on_column_1_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "col1")


func _on_column_2_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "col2")


func _on_column_3_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	bet(event, "col3")


func _on_red_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_black_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_odd_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_to_36_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_even_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_to_18_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_st_12_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_nd_12_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_rd_12_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_column_1_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_column_2_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_column_3_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_red_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_black_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_odd_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_to_36_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_even_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_to_18_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_st_12_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_nd_12_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_rd_12_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_column_1_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_column_2_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_column_3_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_sword_guy_area_input_event(camera, event, pos, normal, shape):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and roulette.ball_stopped:
		start_drag("sword", pos)
			
func _input(event):

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:

		if !event.pressed and dragging:

			var item_name = ""

			for key in item_data.keys():
				if item_data[key]["node"] == drag_started_node:
					item_name = key
					break

			dragging = false

			var zone = get_closest_drop_zone()

			if zone != null:
				print(zone.name)

				var cost = item_data[item_name]["cost"]

				if get_parent().money >= cost and not get_parent().figures.has(int(zone.name)):
					get_parent().pay(cost)
					get_parent().place_figure(int(zone.name), item_name, "player")

			drag_started_node.global_position = start_pos
			drag_started_node = null
				
func get_closest_drop_zone() -> Area3D:
	var closest: Area3D = null
	var best_dist := INF

	for area in drop_areas:
		if area is Area3D and area.overlaps_area(drag_started_area):

			var dist = sword_guy.global_position.distance_to(area.global_position)

			if dist < best_dist:
				best_dist = dist
				closest = area

	return closest
	
func start_drag(item_name: String, pos: Vector3):

	drag_started_area = item_data[item_name]["node"].get_child(-1)
	dragging = true
	drag_started_node = item_data[item_name]["node"]

	start_pos = drag_started_node.global_position
	drag_plane = Plane(Vector3.UP, start_pos.y)

	drag_offset = drag_started_node.global_position - pos

func _on_sword_guy_area_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_sword_guy_area_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_bow_guy_area_input_event(camera, event, pos, normal, shape):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and roulette.ball_stopped:
		start_drag("bow", pos)


func _on_bow_guy_area_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_bow_guy_area_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_house_guy_area_input_event(camera, event, pos, normal, shape):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and roulette.ball_stopped:
		start_drag("house", pos)


func _on_house_guy_area_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_house_guy_area_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
