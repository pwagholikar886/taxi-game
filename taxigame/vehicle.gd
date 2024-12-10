extends Area2D

# Variables
var vel = [0, 0]
var rot_vel = 0

# Constants
const rotAcc = 20
const driveAcc = 4000
const rotFric = 0.05
const rollFric = 0.01
const perpFric = 0.1
const driftFric = 0.01


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'dt' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	
	# Create two unit vectors, one in the direction of the car and one perpendicular to it.
	# These vectors will be used in the calculations later on in this method
	var straight = createVec(rotation, 1)
	var perp = [straight[1], -straight[0]]
	
	# Check for WASD inputs and change the rotational and linear velocities of the car accordingly
	if Input.is_action_pressed("forward"):
		vel = addVecs(vel, multVec(straight, driveAcc * dt))
	if Input.is_action_pressed("reverse"):
		vel = addVecs(vel, multVec(straight, -driveAcc * dt))
	if Input.is_action_pressed("turn_left"):
		rot_vel += rotAcc * dt
	if Input.is_action_pressed("turn_right"):
		rot_vel -= rotAcc * dt
	
	# Check if space is pressed to increase drifting or keep skid friction high
	var perpFricApplied
	if Input.is_action_pressed("drift"):
		perpFricApplied = driftFric
	else:
		perpFricApplied = perpFric
	
	# Apply rolling friction (in the direction of the car) to the velocity
	var straight_comp = dot(straight, vel)
	var vec_to_remove = multVec(straight, -straight_comp * rollFric)
	vel = addVecs(vel, vec_to_remove)
	
	# Apply skid friction (perpendicular to the car). This will be high when space is not pressed (not drifting).
	var perp_comp = dot(perp, vel)
	vec_to_remove = multVec(perp, -perp_comp * perpFricApplied)
	vel = addVecs(vel, vec_to_remove)
	
	# Apply turning friction
	rot_vel *= (1 - rotFric)
	
	# Update position
	position.x += vel[0] * dt
	position.y += vel[1] * dt
	
	# Update rotation
	rotation += rot_vel * dt

# Vector operation functions
func dot(vec1, vec2) -> float:
	return vec1[0]*vec2[0] + vec1[1]*vec2[1]
func magnitude(vec) -> float:
	return sqrt(vec[0]*vec[0] + vec[1]*vec[1])
func createVec(dir, mag) -> Array:
	return [mag*cos(dir), mag*sin(dir)]
func addVecs(vec1, vec2) -> Array:
	return [vec1[0] + vec2[0], vec1[1] + vec2[1]]
func multVec(vec, val) -> Array:
	return [vec[0]*val, vec[1]*val]
	
	
	
	
