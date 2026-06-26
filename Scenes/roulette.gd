extends Node3D

@onready var cylinder_001: MeshInstance3D = $Cylinder_001
@onready var cylinder_002: MeshInstance3D = $Cylinder_002
@onready var cylinder_003: MeshInstance3D = $Cylinder_003
@onready var animatable_body_3d: AnimatableBody3D = $Cylinder_001/AnimatableBody3D

@onready var ball: RigidBody3D = $Ball

var spin_speed := 25.0      # radians/sec at start
var deceleration := 4.0     # how quickly it slows
var spinning := false

var ball_stopped := true
var result = -1
var color = null



func _physics_process(delta: float) -> void:
	if spinning:
		cylinder_001.rotate_y(spin_speed * delta)
		cylinder_002.rotate_y(spin_speed * delta)
		cylinder_003.rotate_y(spin_speed * delta)
		animatable_body_3d.rotate_y(spin_speed * delta)

		spin_speed -= deceleration * delta
		if spin_speed <= 0:
			spin_speed = 0
			spinning = false
			
	if ball.linear_velocity != Vector3.ZERO and ball_stopped:
		ball_stopped = false
	if ball.linear_velocity == Vector3.ZERO and not ball_stopped:
		ball_stopped = true
		$Spin.stop()
		get_parent().result = result
		get_parent().show_result(result)
		await get_tree().create_timer(.5).timeout


func start_spin():
	if $Spin.is_inside_tree():
		$Spin.play()
	result = -1
	get_parent().result = -1
	color = null
	spin_speed = randf_range(20.0, 35.0)
	spinning = true
	

func start_ball():
	$Ball.freeze = false
	$Ball.global_position = $BallStart.global_position
	var base_dir := Vector3(0, 0, -1).normalized()  # fixed throw direction

	var start_force := randf_range(0.4, 0.8)

	ball.apply_impulse(base_dir * start_force)

func _on_ball_area_area_entered(area: Area3D) -> void:
	if area.name != "BallArea":
		result = int(area.name)
		


func _on_ball_area_body_exited(body: Node3D) -> void:
	if body == $Ball:
		start_ball()
		start_spin()
