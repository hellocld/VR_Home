extends Spatial

export(float) var speed = 1.0

func _process(delta):
	$Path/PathFollow.unit_offset += (delta * speed)
