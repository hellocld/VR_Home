extends Spatial

signal pressed
signal released


export(bool) var toggle = false
export(float) var contact_range = 0.55

var button_on:bool = false
var pressed:bool = false
onready var mesh = $MeshInstance
onready var default_basis_y = mesh.transform.basis.y


func _on_Area_area_entered(area):
	var vec:Vector3 = (area.global_transform.origin - global_transform.origin).normalized()
	var dot:float = vec.dot(global_transform.basis.y)
	if dot < contact_range:
		return
	else:
		pressed = true
		if area.get_groups().find("Left Hand") >= 0:
			$LeftHaptics.trigger_pulse()
		else:
			$RightHaptics.trigger_pulse()
	if toggle:
		button_on = !button_on
	else:
		button_on = true
	_set_scale(button_on)
	emit_signal("pressed")


func _on_Area_area_exited(area):
	if !pressed:
		return
	pressed = false
	if !toggle:
		button_on = false
		_set_scale(button_on)
	emit_signal("released")


func _set_scale(is_on):
	if is_on:
		mesh.transform.basis.y *= 0.5
	else:
		mesh.transform.basis.y = default_basis_y
