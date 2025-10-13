extends CSGCylinder3D
@onready var sound=$AudioStreamPlayer3D
var pressed=false
var presscount:=0
@onready var onsound=load("res://ear effects/Button.wav")
@onready var offsound=load("res://ear effects/Button Off.wav")
@onready var buttofbuttob=$"Buttof Buttob"
var red=load("res://materials/buttom red.tres")
var green=load("res://materials/buttom green.tres")
func _on_area_3d_body_entered(body: Node3D) -> void:
	presscount+=1
	updatepressed()
func _on_area_3d_body_exited(body: Node3D) -> void:
	presscount-=1
	updatepressed()
func updatepressed():
	if presscount<0:
		presscount=0
	if not pressed and presscount>0:
		sound.stream=onsound
		sound.play()
	if pressed and presscount==0:
		sound.stream=offsound
		sound.play()
	pressed=presscount>0
	if pressed:
		buttofbuttob.material=green
		buttofbuttob.position.y=0
	else:
		buttofbuttob.material=red
		buttofbuttob.position.y=0.088
