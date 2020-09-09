extends Spatial

export(NodePath) var target
export(float) var mass:float
export(float) var max_velocity:float
export(float) var max_force:float

var steering_force:Vector3 = Vector3.ZERO
var acceleration:Vector3 = Vector3.ZERO
var velocity:Vector3 = Vector3.ZERO
var _target:Spatial


func _ready():
	_target = get_node(target) as Spatial
	transform.origin = Vector3(rand_range(-5, 5), rand_range(0, 5), rand_range(-5, 5))


func _process(delta):
	seek()
	# Clamp steering force to max force
	if steering_force.length() > max_force:
		steering_force = steering_force.normalized() * max_force
	if mass > 0:
		acceleration = steering_force / mass
	velocity += acceleration
	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity
	transform.origin = transform.origin - velocity * delta
	
	transform.basis.z = -velocity.normalized()
	#var approx_up = transform.basis.y.normalized()
	transform.basis.x = transform.basis.z.cross(transform.basis.y)
	transform.basis.y = transform.basis.x.cross(transform.basis.z)
	transform.basis = transform.basis.orthonormalized()

func seek():
	var desired_velocity:Vector3 = (transform.origin - _target.transform.origin).normalized() * max_velocity
	steering_force = desired_velocity - velocity
