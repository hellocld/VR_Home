extends Node


func _ready():
	var vr = ARVRServer.find_interface("OpenVR")
	if vr and vr.initialize():
		get_viewport().arvr = true
		get_viewport().keep_3d_linear = true
		OS.vsync_enabled = false
		Engine.iterations_per_second = 90
