extends Node


func _on_Area_area_entered(area):
	$TouchHaptics.trigger_pulse()
