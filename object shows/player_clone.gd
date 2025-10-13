extends CharacterBody3D
var savedpositions=[]
@onready var particles=$CPUParticles3D
func _on_timer_timeout() -> void:
	if savedpositions.size()>0:
		position=savedpositions.pop_front()
		
