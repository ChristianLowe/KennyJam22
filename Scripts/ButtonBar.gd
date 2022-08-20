extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pop_in():
	var lowered = Vector2(0, 64)
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
