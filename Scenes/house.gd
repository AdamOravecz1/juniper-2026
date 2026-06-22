extends Node3D

var side := "player"
var health := 3
var pos:int

func _ready() -> void:
	if side == "player":
		$Cube_002.material_override.albedo_color = Color(0.0, 0.475, 1.0, 1.0)

func hit(damage):
	health -= damage
	if health < 0:
		queue_free()
		
