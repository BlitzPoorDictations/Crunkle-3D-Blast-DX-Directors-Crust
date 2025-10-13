extends CSGSphere3D
@onready var sound=$AudioStreamPlayer
@onready var light=$OmniLight3D
var extrazpeed=0
func _physics_process(delta: float) -> void:
	rotation.y+=delta*(2+extrazpeed)
	extrazpeed=lerpf(extrazpeed,0,delta*5)
	light.light_energy=extrazpeed
func _on_area_3d_body_entered(body: Node3D) -> void:
	body.reset2spawn()
	sound.play()
	extrazpeed=20
