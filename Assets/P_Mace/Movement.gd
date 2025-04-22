extends Node2D

var Picked = false
var moveFactor = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Picked:
		# TODO: Add mouse delta to mouse movement - Input.get_last_mouse_velocity() does not work >:(
		$Handle.global_position = lerp($Handle.global_position,get_global_mouse_position(),.1)
		

func _on_handle_input_event(viewport, event, shape_idx):
	print(event)
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			Picked = !Picked
		
	#print(event)
	#print("Hello")
	pass
