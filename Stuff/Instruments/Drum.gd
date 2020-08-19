extends Spatial


export(AudioStreamSample) var audio_sample


func _ready():
	if audio_sample:
		$AudioStreamPlayer3D.stream = audio_sample


func play():
	print("BANG!")
	$AudioStreamPlayer3D.play()


func _on_DrumArea_area_entered(area):
	play()


func _on_DrumRigid_body_entered(body):
	play()
