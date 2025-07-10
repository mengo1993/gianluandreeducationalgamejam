extends Node2D
@onready var audio_main: AudioStreamPlayer2D = $Audio_Main

const MAX_PARTICLES : int = 100
const MAX_LIFETIME : int = 100
# cambiare tra particles e particles2 per avere due effetti differenti 
func _on_slider_amount_value_changed(value: float) -> void:
	$particles.amount = clamp(int(value), 1, MAX_PARTICLES)
	get_node("Control/particles3").amount = clamp(int(value), 1, MAX_PARTICLES)

func _on_slider_lifetime_value_changed(value: float) -> void:
	$particles.lifetime = clamp(int(value), 0.5, MAX_LIFETIME)
	get_node("Control/particles3").lifetime = clamp(int(value), 0.5, MAX_LIFETIME)
	
	
# --- Low-Pass Filter control starts here ---

	# Get the index of the Master bus
	var master_bus_idx = AudioServer.get_bus_index("Master")

	if master_bus_idx != -1:
		# Get the effect from the Master bus at index 0 (assuming it's the first effect)
		# We cast it as AudioEffectFilter to ensure we can access its filter-specific properties.
		var filter_effect = AudioServer.get_bus_effect(master_bus_idx, 0) as AudioEffectFilter

		if filter_effect:
			# It's good practice to also ensure it's actually configured as a Low Pass filter,
			# although you should have set this in the editor.
			# You technically don't need this line if you've already set it in the editor.
			# filter_effect.set_cutoff(AudioEffectFilter.FILTER_LOWPASS) # This sets the type, not a property.
			# No, you don't call set_cutoff this way. The 'type' property is set directly.
			# filter_effect.type = AudioEffectFilter.FILTER_LOWPASS # This is how you'd set it in code

			# Map the slider's value to the filter's cutoff frequency.
			# Filter cutoff typically ranges from ~20 Hz to 20000 Hz (human hearing range).
			# Adjust these values based on your slider's actual range and desired filter effect.
			var min_slider_val = 0.5 # Your slider's minimum value
			var max_slider_val = MAX_LIFETIME # Your slider's maximum value (ensure MAX_LIFETIME is defined)

			var min_cutoff_freq = 200.0   # Lowest frequency for the filter (e.g., very muffled)
			var max_cutoff_freq = 10000.0 # Highest frequency (full open, no filtering)

			# Map the slider's value to the desired frequency range
			var new_cutoff_frequency = remap(value, min_slider_val, max_slider_val, min_cutoff_freq, max_cutoff_freq)

			# Apply the new cutoff frequency to the low-pass filter
			# The property is 'cutoff_hz' for the frequency
			filter_effect.cutoff_hz = clampf(new_cutoff_frequency, min_cutoff_freq, max_cutoff_freq)
			
func _ready() -> void:
	audio_main.playing = true
	# Connect the 'finished' signal to a method that will restart the audio
	audio_main.finished.connect(func(): 
		audio_main.play()
	)

	
	
