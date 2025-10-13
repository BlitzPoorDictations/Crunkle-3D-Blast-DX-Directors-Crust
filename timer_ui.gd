extends Control
@onready var label=$Label
func _physics_process(delta: float) -> void:
	if PlayerGlobalManager.timeleft==0:
		if PlayerGlobalManager.hasdata:
			label.text="[E] - Record\n[Q] - Playback"
		else:
			label.text="[E] - Record"
	else:
		label.text=str(int(ceil(PlayerGlobalManager.timeleft)))+"\n[E] - Restart Recording [Q] - Playback"
