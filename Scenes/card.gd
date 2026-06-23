extends Node3D

enum EffectType {
	ADD,
	MULTIPLY
}

var rng = RandomNumberGenerator.new()

var cost: int

var effects = [
	{"type": "add", "value": 1, "texture": preload("res://Textures/+1_card.png")},
	{"type": "add", "value": 2, "texture": preload("res://Textures/+2_card.png")},
	{"type": "add", "value": 3, "texture": preload("res://Textures/+3_card.png")},

	{"type": "add", "value": -1, "texture": preload("res://Textures/-1_card.png")},
	{"type": "add", "value": -2, "texture": preload("res://Textures/-2_card.png")},
	{"type": "add", "value": -3, "texture": preload("res://Textures/-3_card.png")},

	{"type": "mul", "value": 2, "texture": preload("res://Textures/2x_card.png")},
	{"type": "mul", "value": 0.5, "texture": preload("res://Textures/1over2x_card.png")}
]

@export var look: Texture2D

@export var effect_type: EffectType
@export var effect_value := 1.0


func _ready() -> void:
	$Cube.material_override = $Cube.material_override.duplicate()
	$Cube.material_override.albedo_texture = look


func _on_area_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var main = get_parent().get_parent()
			if main.result < 0:
				return
			var value = main.result
			match effect_type:
				EffectType.ADD:
					value += effect_value
				EffectType.MULTIPLY:
					value *= effect_value
			if value < 0 or value > 36:
				return
			if main.money - cost < 0:
				return
			main.pay(cost)
			main.result = value
			print(main.result)
			var data = get_random_card_data()
			main.draw_card(global_position, data.type, data.value, data.texture)
			queue_free()
				
func get_random_card_data():
	rng.randomize()
	return effects[rng.randi_range(0, effects.size() - 1)]
