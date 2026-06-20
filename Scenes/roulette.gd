extends Node3D

@onready var cylinder_001: MeshInstance3D = $Cylinder_001
@onready var cylinder_002: MeshInstance3D = $Cylinder_002
@onready var cylinder_003: MeshInstance3D = $Cylinder_003
@onready var animatable_body_3d: AnimatableBody3D = $Cylinder_001/AnimatableBody3D

@onready var ball: RigidBody3D = $Ball

var spin_speed := 25.0      # radians/sec at start
var deceleration := 4.0     # how quickly it slows
var spinning := false

var result := 0
var color := "green"

const color_table := {
	0: "green",
	1: "red",
	2: "black",
	3: "red",
	4: "black",
	5: "red",
	6: "black",
	7: "red",
	8: "black",
	9: "red",
	10: "black",
	11: "black",
	12: "red",
	13: "black",
	14: "red",
	15: "black",
	16: "red",
	17: "black",
	18: "red",
	19: "black",
	20: "black",
	21: "red",
	22: "black",
	23: "red",
	24: "black",
	25: "red",
	26: "black",
	27: "red",
	28: "red",
	29: "black",
	30: "red",
	31: "black",
	32: "red",
	33: "black",
	34: "red",
	35: "black",
	36: "red"
}

func _ready():
	start_spin()
	start_ball()

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
			
	if ball.linear_velocity == Vector3.ZERO:
		print(result, color)

func start_spin():
	spin_speed = randf_range(20.0, 35.0)
	spinning = true
	

func start_ball():
	var base_dir := Vector3(0, 0, -1).normalized()  # fixed throw direction

	var start_force := randf_range(0.4, 0.8)

	ball.apply_impulse(base_dir * start_force)


func _on_ball_area_area_entered(area: Area3D) -> void:
	result = int(area.name)
	color = color_table[result]
