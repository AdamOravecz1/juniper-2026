extends Node3D

signal moved_finished(new_tile)

var tile_size := Vector3(0, 0, 0.184)
var side := "player"
var health := 3
var pos:int


func _ready() -> void:
	if side == "player":
		$Sphere.material_override.albedo_color = Color(0.0, 0.475, 1.0, 1.0)
		$Cylinder.material_override.albedo_color = Color(0.0, 0.475, 1.0, 1.0)
		$Cylinder_001.material_override.albedo_color = Color(0.0, 0.475, 1.0, 1.0)

func hit(damage):
	health -= damage
	if health < 0:
		queue_free()
		
		

func move():

	var next_tile = pos + 3

	# check if occupied
	if get_parent().get_parent().figures.has(next_tile):
		return # blocked, do nothing

	var tween = get_tree().create_tween()

	var start_pos = global_position
	var target_pos = start_pos + Vector3(0, 0, 0.184)

	# lift
	tween.tween_property(self, "global_position:y", start_pos.y + 0.2, 0.1)

	# move forward
	tween.tween_property(self, "global_position", target_pos + Vector3(0, 0.2, 0), 0.15)

	# drop
	tween.tween_property(self, "global_position:y", start_pos.y, 0.1)

	tween.tween_callback(func():
		pos = next_tile
		moved_finished.emit(pos)
	)
	
	await moved_finished
	
