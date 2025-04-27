extends Node2D

var Picked = false
var Returning = false
var LastPos = false
var Overstretched = false

var ReturnPos = Vector2.ZERO

var moveFactor = 0.2
@onready var LastMousePos = Vector2(get_viewport_rect().size.x,get_viewport_rect().size.y) * .5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Return():
	Picked = false
	LastPos = false
	var viewportrect = get_viewport_rect()
	print("--------START--------")
	print(viewportrect)
	viewportrect = Vector2(viewportrect.size.x,viewportrect.size.y) * .5
	print($Handle.global_position.round().distance_to(viewportrect))
	if $Handle.global_position.round().distance_to(viewportrect) > 1:
		print($Handle.global_position)
		print(to_global(viewportrect))
		$Handle.global_position = lerp($Handle.global_position,viewportrect,.1)
	else:
		Returning = false

func ReturnLastPos():
	# TODO: This causes the bug of not left clicking properly
	print('hi')
	Picked = false
	Returning = false
	if $Handle.global_position.round().distance_to(LastMousePos) > 1:
		$Handle.global_position = lerp($Handle.global_position,LastMousePos,.1)
	else:
		LastPos = false

func Overstretch():
		var returnFactor = .6
		var directionVector = $Handle.global_position.direction_to($Head.global_position)
		ReturnPos = Vector2(
		$Head.global_position.x - ((450*returnFactor)* directionVector.x),
		$Head.global_position.y - ((450*returnFactor)* directionVector.y)
		)
		LastMousePos = ReturnPos
		LastPos = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $Head.global_position.distance_to($Handle.global_position) > 450:
		Overstretch()
	
	# shift + LClick to return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and Input.is_action_pressed("Shift"):
		Picked = false
		Returning = true
		Return()
	
	# Follows Mouse
	if Picked:
		$Handle.global_position = lerp($Handle.global_position,get_global_mouse_position(),.1)
		LastMousePos = get_global_mouse_position()
		if not get_window().get_visible_rect().has_point(get_global_mouse_position()):
			Picked = false
			Returning = true
			
	# Returns to center
	if Returning:
		Return()
	
	if LastPos:
		ReturnLastPos()

# Listen for left clicks
func _input(event):
	# This needs to check if the mouse is hovering over the handle - should only run if mouse isn't touching
	#print(get_global_mouse_position().distance_to($Handle.global_position))
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and get_global_mouse_position().distance_to($Handle.global_position) > 15:
			LastPos = true
			Picked = false

func _on_handle_input_event(viewport, event, shape_idx):
	#print(event)
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			print(event)
			Picked = !Picked
