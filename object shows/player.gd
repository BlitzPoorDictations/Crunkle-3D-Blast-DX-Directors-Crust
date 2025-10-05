extends CharacterBody3D
@export var accel:=3.0
@export var decel:=3.0
@export var topspd:=6.0
var dirvel:=0.0
var mouse_locked=true
@onready var springtrap=$SpringArm3D
@export var mouseSens=0.01
@export var camtiltmin=-1.3
@export var camtiltmax=0.25
@export var gravity=50
var player_dir=Vector3.ZERO
@export var junpheight=20
@export var sprintmult=1.5
func _physics_process(delta: float) -> void:
	var input_dir=Input.get_vector("Move Leftward","Move Right","Move Forward","Move Backward",0.5)
	player_dir=(transform.basis*Vector3(input_dir.x,0,input_dir.y)).normalized().rotated(Vector3.UP,springtrap.rotation.y)
	var sprintapply=1.0
	if Input.is_action_pressed("Splinter"):
		sprintapply=sprintmult
	velocity.x=player_dir.x*topspd*sprintapply
	velocity.z=player_dir.z*topspd*sprintapply
	move_and_slide()
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y-=gravity*delta
func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Unlock Mouse"):
		mouse_locked=false
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("Lock Maus"):
		mouse_locked=true
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and mouse_locked:
		springtrap.rotation.y-=event.relative.x*mouseSens
		springtrap.rotation.x-=event.relative.y*mouseSens
		springtrap.rotation.x=clampf(springtrap.rotation.x,camtiltmin,camtiltmax)
	if event.is_action_pressed("Junp") and is_on_floor():
		velocity.y=junpheight
