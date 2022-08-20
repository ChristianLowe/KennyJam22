extends AnimatedSprite
class_name PetStatusIcon

enum FloatDirection {
	Up,
	Down
}

export var float_amount: float = 35.0
var float_direction: int = FloatDirection.Up

# Called when the node enters the scene tree for the first time.
func _ready():
	$FloatTween.connect("tween_completed", self, "_on_float_tween_completed")

func float_up_and_down() -> void:
	$FloatTween.interpolate_property(
		self,
		"position:y",
		position.y,
		position.y-float_amount if float_direction == FloatDirection.Up else position.y+float_amount,
		1.0,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	
	$FloatTween.start()

func _on_float_tween_completed(object, key):
	float_direction = not float_direction
	float_up_and_down()
