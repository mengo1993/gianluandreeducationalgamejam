extends Node2D
@onready var audio_main: AudioStreamPlayer2D = $Audio_Main
@onready var slider_speed: HSlider = $"Control/Container_V_ Effects/sliderSpeed"
@onready var pamplets: Control = $Pamplets

# Your defined constants for particles (remains unchanged)
const MIN_PARTICLES : int = 17
const MAX_PARTICLES : int = 50
const MIN_LIFETIME : float = 2.5
const MAX_LIFETIME : float = 5.0
const MIN_SPEED : float = 10.0
const MAX_START_SPEED : float = 15.0
const MAX_SPEED : float = 400.0
const MAX_RADIAL_SPEED : float = 10.0

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
			material1.initial_velocity_max = MAX_START_SPEED
			# Initialize Hue Variation using the correct property names
			material1.hue_variation_min = MIN_HUE_VARIATION
			material1.hue_variation_max = MIN_HUE_VARIATION # Start with no variation

	if particles2:
		particles2.amount = MIN_PARTICLES
		particles2.lifetime = MIN_LIFETIME
		if particles2.process_material is ParticleProcessMaterial:
			var material2 := particles2.process_material.duplicate() as ParticleProcessMaterial
			material2.initial_velocity_min = - MIN_SPEED
			material2.initial_velocity_max = - MAX_START_SPEED
			# Initialize Hue Variation using the correct property names
			material2.hue_variation_min = MIN_HUE_VARIATION
			material2.hue_variation_max = MIN_HUE_VARIATION
			particles2.process_material = material2

		


	# --- Audio setup ---
	audio_main.playing = true
	# Connect the 'finished' signal to a method that will restart the audio
	audio_main.finished.connect(func():
		audio_main.play()
	)
	
	# connect buttons to fade out
	for node in get_tree().get_nodes_in_group("pamplets_button"): # This gets all nodes, then filter
		if node is Button:
			node.mouse_exited.connect(pamplets.fade_out)



func _on_slider_speed_value_changed(value: float) -> void:
	edit_particles_speed(value)
	audio_delay_value_changed(value)
	#audio_filter_value_changed(value)



func _on_slider_amount_value_changed(value: float) -> void:
	edit_particles_amount(value)
	audio_filter_value_changed(value)


func _on_slider_lifetime_value_changed(value: float) -> void:
	edit_particles_lifetime(value)
	audio_reverb_value_changed(value)
	# audio function


# --- Slider for Hue Variation ---
func _on_slider_color_value_changed(value: float) -> void:
	edit_particles_hue(value)
	audio_pitchShift_value_changed(value)
	
func _on_slider_radial_speed_value_changed(value: float) -> void:
	edit_particles_radial_speed(value)
	audio_distortion_value_changed(value)
	# audio



##### PARTICLES
func edit_particles_speed(value: float) -> void:
	var t : float = clamp(value / 100.0, 0.0, 1.0)
	var speed : float = lerp(MIN_SPEED, MAX_SPEED, t)

	var particles1 := $ParticlesManager/Particles as GPUParticles2D
	var particles2 := $ParticlesManager/Particles3 as GPUParticles2D

	if particles1 and particles1.process_material is ParticleProcessMaterial:
		var material1 := particles1.process_material as ParticleProcessMaterial
		material1.initial_velocity_max = speed

	if particles2 and particles2.process_material is ParticleProcessMaterial:
		var material2 := particles2.process_material as ParticleProcessMaterial
		material2.initial_velocity_min = -speed
		material2.initial_velocity_max = -MIN_SPEED


func edit_particles_radial_speed(value: float) -> void:
	var radial_speed : float = lerp(0.0, MAX_RADIAL_SPEED, value)

	var particles1 := $ParticlesManager/Particles as GPUParticles2D
	var particles2 := $ParticlesManager/Particles3 as GPUParticles2D

	if particles1 and particles1.process_material is ParticleProcessMaterial:
		var material1 := particles1.process_material as ParticleProcessMaterial
		material1.radial_velocity_max = radial_speed

	if particles2 and particles2.process_material is ParticleProcessMaterial:
		var material2 := particles2.process_material as ParticleProcessMaterial
		material2.radial_velocity_max = radial_speed

func edit_particles_amount(value: float) -> void:
	var t : float = clamp(value / 100.0, 0.0, 1.0)
	var amount := int(lerp(MIN_PARTICLES, MAX_PARTICLES, t))

	$ParticlesManager/Particles.amount = amount
	$ParticlesManager/Particles3.amount = amount
	
func edit_particles_lifetime(value: float) -> void:
	var t : float = clamp(value / 100.0, 0.0, 1.0)
	var lifetime : float = lerp(MIN_LIFETIME, MAX_LIFETIME, t)

	$ParticlesManager/Particles.lifetime = lifetime
	$ParticlesManager/Particles3.lifetime = lifetime

func edit_particles_hue(value: float) -> void:
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

##### AUDIO
func audio_filter_value_changed(value: float) -> void:
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

func audio_distortion_value_changed(value: float) -> void:
	var master_bus_idx = AudioServer.get_bus_index("Master")

	if master_bus_idx != -1:
		# Assuming the Distortion effect is at index 1 on the Master bus.
		# You might need to adjust this index based on your Audio Bus layout.
		var distortion_effect = AudioServer.get_bus_effect(master_bus_idx, 1) as AudioEffectDistortion

		if distortion_effect:
			var min_slider_val = 0.0
			var max_slider_val = 100.0

			# Define the range for the distortion's drive property
			# The 'drive' property typically ranges from 0.0 to 1.0,
			# but you can adjust these values to suit your desired effect.
			var min_distortion_drive = 0.0
			var max_distortion_drive = 0.4

			# Remap the slider value to the desired distortion drive range
			var new_drive_value = remap(value, min_slider_val, max_slider_val, min_distortion_drive, max_distortion_drive)

			# Clamp the value to ensure it stays within the valid range for the drive property
			distortion_effect.drive = clampf(new_drive_value, min_distortion_drive, max_distortion_drive)


func audio_delay_value_changed(value: float) -> void:
	var master_bus_idx = AudioServer.get_bus_index("Master")

	if master_bus_idx != -1:
		# Assuming the Delay effect is at index 2 on the Master bus.
		# You might need to adjust this index based on your Audio Bus layout.
		var delay_effect = AudioServer.get_bus_effect(master_bus_idx, 2) as AudioEffectDelay

		if delay_effect:
			var min_slider_val = 0.0
			var max_slider_val = 100.0

			# Define the range for the delay's dry property
			# The 'dry' property typically ranges from 0.0 (no dry signal) to 1.0 (full dry signal).
			var min_delay_dry = 0.0
			var max_delay_dry = 1.0

			# Remap the slider value to the desired delay dry range
			var new_dry_value = remap(value, min_slider_val, max_slider_val, min_delay_dry, max_delay_dry)

			# Clamp the value to ensure it stays within the valid range for the dry property
			delay_effect.dry = clampf(new_dry_value, min_delay_dry, max_delay_dry)





###### POP UP PAMPLETS

## speed slider
#func _on_slider_speed_mouse_entered() -> void:
	#pamplets.visible = true
#func _on_slider_speed_mouse_exited() -> void:
	#pamplets.visible = false 
	
func audio_reverb_value_changed(value: float) -> void:
	var master_bus_idx = AudioServer.get_bus_index("Master")

	if master_bus_idx != -1:
		# Assuming the Reverb effect is at index 3 on the Master bus.
		# You might need to adjust this index based on your Audio Bus layout.
		var reverb_effect = AudioServer.get_bus_effect(master_bus_idx, 3) as AudioEffectReverb

		if reverb_effect:
			var min_slider_val = 0.0
			var max_slider_val = 100.0

			# Define the range for the reverb's wet property
			# The 'wet' property typically ranges from 0.0 (no wet signal) to 1.0 (full wet signal).
			var min_reverb_wet = 0.0 # As requested, starting from 0.0
			var max_reverb_wet = 1.0

			# Remap the slider value to the desired reverb wet range
			var new_wet_value = remap(value, min_slider_val, max_slider_val, min_reverb_wet, max_reverb_wet)

			# Clamp the value to ensure it stays within the valid range for the wet property
			reverb_effect.wet = clampf(new_wet_value, min_reverb_wet, max_reverb_wet)

func _on_description_1_mouse_entered() -> void:
	var texture : Texture2D = preload("res://moon.png")
	
	var plant_text = "[color=#872b2a]MOON"
	var title_text = "[color=#7456da]SOMETHING"
	
	# Use the variables
	var title : String  = plant_text + "\n\n" + title_text
	
	
	var description : String = "\n[color=#7456da]Something"
	pamplets.focus(texture, title, description)
	
func audio_pitchShift_value_changed(value: float) -> void:
	var master_bus_idx = AudioServer.get_bus_index("Master")

	if master_bus_idx != -1:
		# Assuming the PitchShift effect is at index 4 on the Master bus.
		# You might need to adjust this index based on your Audio Bus layout.
		var pitch_shift_effect = AudioServer.get_bus_effect(master_bus_idx, 4) as AudioEffectPitchShift

		if pitch_shift_effect:
			var min_slider_val = 0.0
			var max_slider_val = 100.0

			# Define the range for the pitch shift's pitch_scale property.
			# A common range is from 0.5 (lower pitch) to 2.0 (higher pitch),
			# with 1.0 being the original pitch.
			var min_pitch_scale = 0.5
			var max_pitch_scale = 1

			# Remap the slider value to the desired pitch_scale range
			var new_pitch_scale_value = remap(100 - value, min_slider_val, max_slider_val, min_pitch_scale, max_pitch_scale)

			# Clamp the value to ensure it stays within the valid range for the pitch_scale property
			pitch_shift_effect.pitch_scale = clampf(new_pitch_scale_value, min_pitch_scale, max_pitch_scale)

	


func _on_descripiton_2_mouse_entered() -> void:
	var texture : Texture2D = preload("res://jupiter.png")
	
	var plant_text = "[color=#872b2a]SATURN"
	var title_text = "[color=#7456da]SOMETHING"
	
	# Use the variables
	var title : String  = plant_text + "\n\n" + title_text
	
	
	var description : String = "\n[color=#7456da]Something"
	pamplets.focus(texture, title, description)
	
	


func _on_description_3_mouse_entered() -> void:
	var texture : Texture2D = preload("res://mars.png")
	
	var plant_text = "[color=#872b2a]MARS"
	var title_text = "[color=#7456da]LOW PASS FILTER"
	
	# Use the variables
	var title : String = plant_text +"\n\n" + title_text
	
	
	var description : String = "\n[color=#7456da]A low-pass filter allows low-frequency signals to pass through while blocking high-frequency ones. "
	pamplets.focus(texture, title, description)


func _on_desciption_4_mouse_entered() -> void:
	var texture : Texture2D = preload("res://saturn.png")
	
	var plant_text = "[color=#872b2a]JUPITER"
	var title_text = "[color=#7456da]SOMETHING"
	
	# Use the variables
	var title : String  = plant_text + "\n\n" + title_text
	
	
	var description : String = "\n[color=#7456da]Something"
	pamplets.focus(texture, title, description)


func _on_desciption_5_mouse_entered() -> void:
	var texture : Texture2D = preload("res://neptune.png")
	
	var plant_text = "[color=#872b2a]NEPTUNE"
	var title_text = "[color=#7456da]SOMETHING"
	
	# Use the variables
	var title : String  = plant_text + "\n\n" + title_text
	
	
	var description : String = "\n[color=#7456da]Something"
	pamplets.focus(texture, title, description)
