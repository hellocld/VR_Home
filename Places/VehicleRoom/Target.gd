extends Spatial


func _on_Area_area_entered(area):
	random_position()


func random_position():
	transform.origin = Vector3(rand_range(-5, 5), rand_range(0, 5), rand_range(-5, 5))
