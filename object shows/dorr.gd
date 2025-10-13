extends CSGBox3D
@export var button:CSGCylinder3D
@export var button2:CSGCylinder3D
var closedy:float
@export var lock=false
var lockedopen=false
func _ready() -> void:
	closedy=position.y
func _physics_process(delta: float) -> void:
	if (lock and lockedopen)or(button and button.pressed and (not button2 or button2.pressed)):
		position.y=move_toward(position.y,closedy+5,delta*20)
		lockedopen=true
	else:
		position.y=move_toward(position.y,closedy,delta*20)
