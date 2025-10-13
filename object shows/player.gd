extends CharacterBody3D
@onready var recordtimer=$"Record Timer"
@export var accel:=3.0
@export var decel:=3.0
@export var topspd:=6.0
var dirvel:=0.0
var mouse_locked=true
@onready var springtrap=$SpringArm3D
@onready var timer=$Timer
@export var mouseSens=0.01
@export var camtiltmin=-1.3
@export var camtiltmax=0.25
@export var gravity=50
var player_dir=Vector3.ZERO
@export var junpheight=20
@export var sprintmult=1.5
var savedpositions=[]
var clome=null
var lastgroundpos:=Vector3.ZERO
var lastcheckpointpos:=Vector3.ZERO
var spawnpos:=Vector3.ZERO
func _physics_process(delta: float) -> void:
	if position.y<-50:
		position=lastcheckpointpos
		velocity=Vector3.ZERO
	PlayerGlobalManager.hasdata=savedpositions.size()>0
	PlayerGlobalManager.timeleft=recordtimer.time_left
	var input_dir=Input.get_vector("Move Leftward","Move Right","Move Forward","Move Backward",0.5)
	player_dir=(transform.basis*Vector3(input_dir.x,0,input_dir.y)).normalized().rotated(Vector3.UP,springtrap.rotation.y)
	var sprintapply=1.0
	if Input.is_action_pressed("Splinter"):
		sprintapply=sprintmult
	velocity.x=player_dir.x*topspd*sprintapply
	velocity.z=player_dir.z*topspd*sprintapply
	if is_on_floor():
		lastgroundpos=position
		if velocity.y<0:
			velocity.y=0
	else:
		velocity.y-=gravity*delta
	move_and_slide()
func _ready() -> void:
	spawnpos=position
	lastcheckpointpos=position
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Reset"):
		position=lastcheckpointpos
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
	if event.is_action_pressed("Record"):
		savedpositions.clear()
		if clome:
			clome.queue_free()
		timer.start()
		recordtimer.start()
	if event.is_action_pressed("Blaypack"):
		if clome:
			clome.queue_free()
		recordtimer.stop()
		if savedpositions.size()>0:
			timer.stop()
			clome=load("res://object shows/player_clone.tscn").instantiate()
			get_parent().add_child(clome)
			clome.savedpositions=savedpositions.duplicate()
			clome.position=savedpositions[0]
			clome.get_node("CPUParticles3D").restart()
			clome.get_node("AudioStreamPlayer3D").play()
func _on_timer_timeout() -> void:
	savedpositions.append(position)
	#print(position)
func _on_record_timer_timeout() -> void:
	timer.stop()
func checkpoint(checkpointpos:Vector3):
	lastcheckpointpos=Vector3(checkpointpos.x,position.y,checkpointpos.z)
func reset2spawn():
	position=spawnpos
