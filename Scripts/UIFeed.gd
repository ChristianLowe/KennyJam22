extends Control

signal feed_button_pressed
signal drink_button_pressed
signal play_button_pressed
signal clean_button_pressed
signal pet_button_pressed

onready var button_panels = [
	[$ButtonBar/ButtonFeedBackground,"feed_button_pressed", 10],
	[$ButtonBar/ButtonDrinkBackground,"drink_button_pressed", 15],
	[$ButtonBar/ButtonPlayBackground,"play_button_pressed", 20],
	[$ButtonBar/ButtonCleanBackground,"clean_button_pressed",15],
	[$ButtonBar/ButtonPetBackground,"pet_button_pressed",5],
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for panel_data in button_panels:
		var panel = panel_data[0]
		var signal_name = panel_data[1]
		var cooldown_seconds = panel_data[2]
		
		var button: TextureButton = panel.get_node('Button')
		var progress_bar: TextureProgress = panel.get_node('ProgressBar')
		var cooldown_timer: Timer = panel.get_node('Timer')
		
		button.connect(
			'pressed',
			self, 
			'_on_button_pressed', 
			[
				signal_name, 
				button, 
				progress_bar,
				cooldown_timer
			]
		)
		
		cooldown_timer.connect("timeout", self, "_on_cooldown_timer_timeout", [progress_bar, button, cooldown_timer, cooldown_seconds])
		
		progress_bar.set_max(cooldown_seconds)
		progress_bar.set_value(cooldown_seconds)
		progress_bar.hide()

func _on_button_pressed(signal_name: String, button: TextureButton, progress_bar: TextureProgress, cooldown_timer: Timer) -> void:
	emit_signal(signal_name)
	button.set_disabled(true)
	button.set_modulate(Color.black)
	progress_bar.show()
	cooldown_timer.start()
	print(button.get_parent().name)
	if button.get_parent().name == "ButtonPetBackground":
		if randi() % 2 == 0:
			get_parent().get_node("Audio").play_sfx("happy1")
		else:
			get_parent().get_node("Audio").play_sfx("happy2")
	else:
		if randi() % 2 == 0:
			get_parent().get_node("Audio").play_sfx("click1")
		else:
			get_parent().get_node("Audio").play_sfx("click2")

func _on_ButtonPlay_pressed():
	emit_signal("play_button_pressed")


func _on_ButtonClean_pressed():
	emit_signal("clean_button_pressed")


func _on_ButtonPet_pressed():
	emit_signal("pet_button_pressed")

func _on_cooldown_timer_timeout(progress_bar: TextureProgress, button: TextureButton, cooldown_timer: Timer, cooldown_seconds: int):
	progress_bar.set_value(progress_bar.get_value()-1)
	
	if progress_bar.get_value() <= 0:
		button.set_disabled(false)
		button.set_modulate(Color.white)
		cooldown_timer.stop()
		progress_bar.set_max(cooldown_seconds)
		progress_bar.set_value(cooldown_seconds)
		progress_bar.hide()
