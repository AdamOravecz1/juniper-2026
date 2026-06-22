extends Node3D

enum EffectType {
	ADD,
	MULTIPLY
}

@export var look: Texture2D

@export var effect_type: EffectType
@export var effect_value := 1


func _ready() -> void:
	$Cube.material_override = $Cube.material_override.duplicate()
	$Cube.material_override.albedo_texture = look


func _on_area_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if get_parent().result >= 0:
				var value = get_parent().result
				match effect_type:
					EffectType.ADD:
						value += effect_value
					EffectType.MULTIPLY:
						value *= effect_value
				value = clamp(value, 0, 36)
				get_parent().result = value
				queue_free()
