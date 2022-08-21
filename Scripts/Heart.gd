extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var small = Vector2(0.2, 0.2)
	var big = Vector2(0.5, 0.5)
	$Tween.interpolate_property(
		self,
		"scale",
		small, big, .66,
		Tween.TRANS_LINEAR, Tween.EASE_OUT_IN
	)
	$Tween.interpolate_property(
		$Sprite,
		"modulate:a",
		1.0, 0.0, .66,
		Tween.TRANS_LINEAR, Tween.EASE_OUT_IN
	)
	$Tween.start()
	
	yield(get_tree().create_timer(.66), "timeout")
	queue_free()
