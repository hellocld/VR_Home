extends Spatial

export(NodePath) var target
export(float) var mass:float
export(float) var max_velocity:float
export(float) var max_force:float

export(float) var cohesion_weight:float = 0.5
export(float) var separation_weight:float = 0.9
export(float) var alignment_weight:float = 0.6

export(float) var repulsion_force:float = 1.0

export(Vector3) var spawn_min:Vector3
export(Vector3) var spawn_max:Vector3

var steering_force:Vector3 = Vector3.ZERO
var acceleration:Vector3 = Vector3.ZERO
var velocity:Vector3 = Vector3.ZERO
var _target:Spatial
var neighbors
var visible_neighbors

func _ready():
	if target:
		_target = get_node(target) as Spatial
	transform.origin = Vector3(
		rand_range(spawn_min.x, spawn_max.x), 
		rand_range(spawn_min.y, spawn_max.y), 
		rand_range(spawn_min.z, spawn_max.z))
	neighbors = get_tree().get_nodes_in_group("Boid")


func _process(delta):
	separation()
	cohesion()
	alignment()
	# Clamp steering force to max force
	if steering_force.length() > max_force:
		steering_force = steering_force.normalized() * max_force
	if mass > 0:
		acceleration = steering_force / mass
	velocity += acceleration
	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity
	transform.origin = transform.origin + velocity * delta
	
	transform.basis.z = velocity.normalized()
	#var approx_up = transform.basis.y.normalized()
	transform.basis.x = transform.basis.z.cross(transform.basis.y)
	transform.basis.y = transform.basis.x.cross(transform.basis.z)
	transform.basis = transform.basis.orthonormalized()


func is_neighbor_visible(n) -> bool:
	return transform.basis.z.normalized().dot((transform.origin - n.transform.origin).normalized()) < 0


func seek(t:Vector3):
	var desired_velocity:Vector3 = (transform.origin - t).normalized() * max_velocity
	steering_force = desired_velocity - velocity


func separation():
	var sum:Vector3 = Vector3.ZERO
	for n in neighbors:
		if is_neighbor_visible(n):
			var rep = (n.transform.origin - transform.origin).normalized()
			sum += (rep * (1/(repulsion_force * repulsion_force)))
	steering_force += (sum * separation_weight)


func cohesion():
	var avg:Vector3 = Vector3.ZERO
	var t = 0
	for n in neighbors:
		if is_neighbor_visible(n):
			t += 1
			avg += n.transform.origin
	if t == 0:
		return
	avg /= t
	steering_force += ((avg - transform.origin).normalized() * cohesion_weight)


func alignment():
	var avg:Vector3 = Vector3.ZERO
	var t = 0
	for n in neighbors:
		if is_neighbor_visible(n):
			t += 1
			avg -= n.transform.basis.z
	if t == 0:
		return
	avg /= t
	steering_force += (avg * alignment_weight)

