extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# In order: Feed, Drink, Play, Clean, Pet
var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Panel:
			buttons.append(child.get_child(0))
			
	for button in buttons:
		var fun = "_on_" + button.name + "_clicked"
		button.connect("gui_input", self, fun)

func _on_button_clicked(event, button_idx):
	if event is InputEventMouseButton and event.is_pressed():
		var button = buttons[button_idx]
		var parent = button.get_parent()
		
		var small = Vector2(0.5, 0.5)
		var normal = Vector2(1.0, 1.0)
		$Tween.interpolate_property(
			parent,
			"rect_scale",
			small, normal, .55,
			Tween.TRANS_BOUNCE, Tween.EASE_OUT
		)
		
		var start = parent.rect_position + (parent.rect_size / 4)
		var end = parent.rect_position
		$Tween.interpolate_property(
			parent,
			"rect_position",
			start, end, .55,
			Tween.TRANS_BOUNCE, Tween.EASE_OUT
		)
		
		$Tween.start()
	
func _on_ButtonFeed_clicked(event):
	_on_button_clicked(event, 0)

func _on_ButtonDrink_clicked(event):
	_on_button_clicked(event, 1)

func _on_ButtonPlay_clicked(event):
	_on_button_clicked(event, 2)

func _on_ButtonClean_clicked(event):
	_on_button_clicked(event, 3)

func _on_ButtonPet_clicked(event):
	_on_button_clicked(event, 4)

func pop_in():
	var lowered = Vector2(0, 112)
	var raised = Vector2(0, 0)
	$Tween.interpolate_property(
		self,
		"position",
		lowered, raised, .99,
		Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
