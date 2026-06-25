extends Node3D

signal pressed()
var down := false


func _on_area_3d_input_event(camera, event, event_position, normal, shape_idx):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:
				down = true
				$Area3D/down.play()
				for i in get_children():
					i.global_position.y -= 0.01

			else:
				down = false
				$Area3D/up.play()
				pressed.emit()
				for i in get_children():
					i.global_position.y += 0.01



func _on_area_3d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_3d_mouse_exited() -> void:
	if down:
		for i in get_children():
			i.global_position.y += 0.01
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
