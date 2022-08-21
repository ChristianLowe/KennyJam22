extends Control

signal feed_button_pressed
signal drink_button_pressed
signal play_button_pressed
signal clean_button_pressed
signal pet_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonFeed_pressed():
	emit_signal("feed_button_pressed")


func _on_ButtonDrink_pressed():
	emit_signal("drink_button_pressed")


func _on_ButtonPlay_pressed():
	emit_signal("play_button_pressed")


func _on_ButtonClean_pressed():
	emit_signal("clean_button_pressed")


func _on_ButtonPet_pressed():
	emit_signal("pet_button_pressed")
