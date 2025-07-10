extends Node2D
@onready var audio_main: AudioStreamPlayer2D = $Audio_Main

# Your defined constants
const MIN_PARTICLES : int = 8 # This usually refers to the maximum 'amount' property
const MAX_PARTICLES : int = 100 # This usually refers to the maximum 'amount' property
const MIN_LIFETIME : float = 0.5
const MAX_LIFETIME : float = 5.0
const MIN_SPEED : float = 30.0
const MAX_SPEED : float = 500.0


func _ready() -> void:
	# Get references to particles
	var particles1 := $ParticlesManager/Particles as GPUParticles2D
	var particles2 := $ParticlesManager/Particles3 as GPUParticles2D

	# --- Initialize particles with constant minimum values ---
	if particles1:
		particles1.amount = MIN_PARTICLES
		particles1.lifetime = MIN_LIFETIME
		if particles1.process_material is ParticleProcessMaterial:
			var material1 := particles1.process_material as ParticleProcessMaterial
			material1.initial_velocity_min = MIN_SPEED
			material1.initial_velocity_max = MIN_SPEED # Set initial max to min for a consistent starting speed
	if particles2:
		particles2.amount = MIN_PARTICLES
		particles2.lifetime = MIN_LIFETIME
		if particles2.process_material is ParticleProcessMaterial:
			var material2 := particles2.process_material as ParticleProcessMaterial
			material2.initial_velocity_min = MIN_SPEED
			material2.initial_velocity_max = MIN_SPEED


	# --- Audio setup ---
	audio_main.playing = true
	# Connect the 'finished' signal to a method that will restart the audio
	audio_main.finished.connect(func():
		audio_main.play()
	)


func _on_slider_somethin_value_changed(value: float) -> void:
	# Use MIN_SPEED and MAX_SPEED for clamping
	var clamped_value : float = clamp(value, MIN_SPEED, MAX_SPEED)

	var particles1 := $ParticlesManager/Particles as GPUParticles2D
	var particles2 := $ParticlesManager/Particles3 as GPUParticles2D

	if particles1 and particles1.process_material is ParticleProcessMaterial:
		var material1 := particles1.process_material as ParticleProcessMaterial
		material1.initial_velocity_min = clamped_value
		material1.initial_velocity_max = clamped_value

	if particles2 and particles2.process_material is ParticleProcessMaterial:
		var material2 := particles2.process_material as ParticleProcessMaterial
		material2.initial_velocity_min = clamped_value
		material2.initial_velocity_max = clamped_value


func _on_slider_amount_value_changed(value: float) -> void:
	# Use MIN_LIFETIME and MAX_LIFETIME for clamping
	$ParticlesManager/Particles.lifetime = clamp(value, MIN_LIFETIME, MAX_LIFETIME)
	$ParticlesManager/Particles3.lifetime = clamp(value, MIN_LIFETIME, MAX_LIFETIME)


func _on_slider_lifetime_value_changed(value: float) -> void:
	# Use MIN_PARTICLES and MAX_PARTICLES for clamping
	# Assuming 'value' directly controls the amount now, not '100 - value'
	# Note: GPUParticles2D.amount is an integer
	$ParticlesManager/Particles.amount = clamp(int(value), MIN_PARTICLES, MAX_PARTICLES)
	$ParticlesManager/Particles3.amount = clamp(int(value), MIN_PARTICLES, MAX_PARTICLES)

# --- Low-Pass Filter control starts here ---

func _on_slider_audio_filter_value_changed(value: float) -> void:
	# Get the index of the Master bus
	var master_bus_idx = AudioServer.get_bus_index("Master")

	if master_bus_idx != -1:
		# Get the effect from the Master bus at index 0 (assuming it's the first effect)
		var filter_effect = AudioServer.get_bus_effect(master_bus_idx, 0) as AudioEffectFilter

		if filter_effect:
			# Map the slider's value to the filter's cutoff frequency.
			# Adjust these values based on your slider's actual range and desired filter effect.
			# Assuming a slider range from 0 to 100 for this example.
			var min_slider_val = 0.0
			var max_slider_val = 100.0

			var min_cutoff_freq = 200.0
			var max_cutoff_freq = 10000.0

			# Map the slider's value to the desired frequency range
			var new_cutoff_frequency = remap(value, min_slider_val, max_slider_val, min_cutoff_freq, max_cutoff_freq)

			# Apply the new cutoff frequency to the low-pass filter
			filter_effect.cutoff_hz = clampf(new_cutoff_frequency, min_cutoff_freq, max_cutoff_freq)
