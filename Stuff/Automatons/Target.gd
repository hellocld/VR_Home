extends Spatial

export(Vector3) var rand_min:Vector3
export(Vector3) var rand_max:Vector3

func _on_Area_area_entered(area):
	random_position()


func random_position():
	transform.origin = Vector3(
		rand_range(rand_min.x, rand_max.x), 
		rand_range(rand_min.y, rand_max.y), 
		rand_range(rand_min.z, rand_max.z))
