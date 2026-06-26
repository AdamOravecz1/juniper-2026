extends Node3D

var tile_size := Vector3(0, 0, 0.184)
var side := "player"
var health := 3
var pos:int
var spawn_counter := 1

func _ready() -> void:
	$Cube_002.material_override = $Cube_002.material_override.duplicate()
	if side == "player":
		$Cube_002.material_override.albedo_color = Color(0.0, 0.475, 1.0, 1.0)
	else:
		$Cube_002.material_override.albedo_color = Color(1.0, 0.282, 0.0, 1.0)
		rotation.y = deg_to_rad(180)
		tile_size = Vector3(0, 0, -0.184)

func hit(damage):
	health -= damage
	$CPUParticles3D.emitting = true
	if health <= 0:
		get_parent().get_parent().figures.erase(pos)
		queue_free()
		
func heal():
	health = 3
		
func move():
	var next_tile: int
	if side == "player":
		next_tile = pos + 3
	else:
		next_tile = pos - 3	

	spawn_counter -= 1
	if spawn_counter <= 0:
		if side == "player":
			if not get_parent().get_parent().figures.has(next_tile):
				if not get_parent().get_parent().figures.has(next_tile):
					get_parent().get_parent().spawn_guy(next_tile, side)
		else:
			if not get_parent().get_parent().figures.has(next_tile):
				if not get_parent().get_parent().figures.has(next_tile):
					get_parent().get_parent().spawn_guy(next_tile, side)
		spawn_counter = 3
		
