extends Node

var label = Label.new()

func _ready():
	add_child(label)

func _physics_process(_delta):
	label.text = str(Engine.get_frames_per_second(), " : FPS")

func _process(_delta):
	pass
