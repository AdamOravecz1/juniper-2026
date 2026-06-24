extends CPUParticles3D

var heal_image := preload("res://Textures/heal_image.png")
var damage_image := preload("res://Textures/damage_image.png")

var type: String

func _ready() -> void:
	material_override = material_override.duplicate()
	if type == "heal":
		material_override.albedo_texture = heal_image
	else:
		material_override.albedo_texture = damage_image
