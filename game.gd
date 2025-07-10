extends Node2D
@onready var audio_main: AudioStreamPlayer2D = $Audio_Main

# Your defined constants for particles (remains unchanged)
const MIN_PARTICLES : int = 8
const MAX_PARTICLES : int = 100
const MIN_LIFETIME : float = 0.5
const MAX_LIFETIME : float = 5.0
const MIN_SPEED : float = 30.0
const MAX_SPEED : float = 500.0

# Constants for Hue Variation Range (using -1.0 to 1.0 as the full range)
# Adjust these based on how much hue variation you want to allow.
const MIN_HUE_VARIATION : float = 0.2  # Starting hue variation (e.g., no shift)
const MAX_HUE_VARIATION : float = 1.0  # Maximum hue variation (e.g., a full 360-degree shift)


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
			material1.initial_velocity_max = MIN_SPEED
			# Initialize Hue Variation using the correct property names
			material1.hue_variation_min = MIN_HUE_VARIATION
			material1.hue_variation_max = MIN_HUE_VARIATION # Start with no variation

	if particles2:
		particles2.amount = MIN_PARTICLES
		particles2.lifetime = MIN_LIFETIME
		if particles2.process_material is ParticleProcessMaterial:
			var material2 := particles2.process_material as ParticleProcessMaterial
			material2.initial_velocity_min = MIN_SPEED
			material2.initial_velocity_max = MIN_SPEED
			# Initialize Hue Variation using the correct property names
			material2.hue_variation_min = MIN_HUE_VARIATION
			material2.hue_variation_max = MIN_HUE_VARIATION


	# --- Audio setup ---
	audio_main.playing = true
	# Connect the 'finished' signal to a method that will restart the audio
	audio_main.finished.connect(func():
		audio_main.play()
	)


func _on_slider_somethin_value_changed(value: float) -> void:
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
	$ParticlesManager/Particles.lifetime = clamp(value, MIN_LIFETIME, MAX_LIFETIME)
	$ParticlesManager/Particles3.lifetime = clamp(value, MIN_LIFETIME, MAX_LIFETIME)


func _on_slider_lifetime_value_changed(value: float) -> void:
	$ParticlesManager/Particles.amount = clamp(int(value), MIN_PARTICLES, MAX_PARTICLES)
	$ParticlesManager/Particles3.amount = clamp(int(value), MIN_PARTICLES, MAX_PARTICLES)

# --- Low-Pass Filter control starts here ---

func _on_slider_audio_filter_value_changed(value: float) -> void:
	var master_bus_idx = AudioServer.get_bus_index("Master")

	if master_bus_idx != -1:
		var filter_effect = AudioServer.get_bus_effect(master_bus_idx, 0) as AudioEffectFilter

		if filter_effect:
			var min_slider_val = 0.0
			var max_slider_val = 100.0

			var min_cutoff_freq = 200.0
			var max_cutoff_freq = 10000.0

			var new_cutoff_frequency = remap(value, min_slider_val, max_slider_val, min_cutoff_freq, max_cutoff_freq)

			filter_effect.cutoff_hz = clampf(new_cutoff_frequency, min_cutoff_freq, max_cutoff_freq)

# --- Slider for Hue Variation ---
func _on_slider_color_value_changed(value: float) -> void:
	# Assuming your "color" slider also goes from 0.0 to 100.0
	var min_slider_val = 0.0
	var max_slider_val = 100.0

	# Map the slider value to the desired hue variation range
	var mapped_hue_variation = remap(value, min_slider_val, max_slider_val, MIN_HUE_VARIATION, MAX_HUE_VARIATION)
	var clamped_hue_variation = clampf(mapped_hue_variation, MIN_HUE_VARIATION, MAX_HUE_VARIATION)

	var particles1 := $ParticlesManager/Particles as GPUParticles2D
	var particles2 := $ParticlesManager/Particles3 as GPUParticles2D

	if particles1 and particles1.process_material is ParticleProcessMaterial:
		var material1 := particles1.process_material as ParticleProcessMaterial
		# Set both min and max hue variation using the direct property names
		material1.hue_variation_min = MIN_HUE_VARIATION
		material1.hue_variation_max = clamped_hue_variation

	if particles2 and particles2.process_material is ParticleProcessMaterial:
		var material2 := particles2.process_material as ParticleProcessMaterial
		material2.hue_variation_min = MIN_HUE_VARIATION
		material2.hue_variation_max = clamped_hue_variation
