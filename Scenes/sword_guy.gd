extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal moved_finished(new_tile)

var activated := false

var tile_size := Vector3(0, 0, 0.184)
var side := "player"
var health := 3
var pos:int


func _ready() -> void:
	$Sphere.material_override = $Sphere.material_override.duplicate()
	$Cylinder.material_override = $Cylinder.material_override.duplicate()
	$Cylinder_001.material_override = $Cylinder_001.material_override.duplicate()
	if side == "player":
		$Sphere.material_override.albedo_color = Color(0.0, 0.475, 1.0, 1.0)
		$Cylinder.material_override.albedo_color = Color(0.0, 0.475, 1.0, 1.0)
		$Cylinder_001.material_override.albedo_color = Color(0.0, 0.475, 1.0, 1.0)
	else:
		$Sphere.material_override.albedo_color = Color(1.0, 0.282, 0.0, 1.0)
		$Cylinder.material_override.albedo_color = Color(1.0, 0.282, 0.0, 1.0)
		$Cylinder_001.material_override.albedo_color = Color(1.0, 0.282, 0.0, 1.0)
		rotation.y = deg_to_rad(180)
		tile_size = Vector3(0, 0, -0.184)

func hit(damage):
	health -= damage
	if health <= 0:
		get_parent().get_parent().figures.erase(pos)
		queue_free()
		
func heal():
	health = 3

func move():
	if not activated:
		activated = false
		return
	var next_tile: int
	if side == "player":
		next_tile = pos + 3
	else:
		next_tile = pos - 3

	# check if occupied
	if get_parent().get_parent().figures.has(next_tile):
		if get_parent().get_parent().figures[next_tile].side != side:
			if get_parent().get_parent().figures[next_tile].has_method("hit"):
				animation_player.play("Hit")
				await $AnimationPlayer.animation_finished
				get_parent().get_parent().figures[next_tile].hit(1)
		return # blocked, do nothing
		
	if side == "player" and pos >= 34:
		animation_player.play("Hit")
		await $AnimationPlayer.animation_finished
		get_parent().get_parent().damage_dealer()
		
	elif pos <= 3:
		animation_player.play("Hit")
		await $AnimationPlayer.animation_finished 
		get_parent().get_parent().damage_player()
		
	var tween = get_tree().create_tween()

	var start_pos = global_position
	var target_pos = start_pos + tile_size

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
	
	
