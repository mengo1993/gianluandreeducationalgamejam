extends Control
# Assumi che questo script sia attaccato al nodo genitore della RichTextLabel,
# oppure alla RichTextLabel stessa se è un nodo standalone.


@export var float_amplitude: float = 3 # Quanto si sposta su e giù in pixel
@export var float_duration: float = 2.0  # Durata di un ciclo completo (su e giù) in secondi
@export var float_offset: float = 0.0   # Offset iniziale per variare l'inizio del float tra più label

var initial_position_y: float
var tween: Tween = null

@onready var rich_text_label: RichTextLabel = $"RichTextLabel" # Sostituisci con il percorso corretto

func _ready():
	if rich_text_label == null:
		push_error("RichTextLabel non trovata! Assicurati che il percorso sia corretto.")
		return

	# Salva la posizione Y iniziale della label
	initial_position_y = rich_text_label.position.y

	# Avvia l'effetto float
	start_float_effect()

func start_float_effect():
	# Se un Tween è già attivo, fermalo e rimuovilo
	if tween != null && tween.is_running():
		tween.kill()

	tween = create_tween()
	tween.set_loops() # Fa ripetere l'animazione all'infinito

	# Aggiungi un ritardo iniziale per l'offset, se specificato
	if float_offset > 0.0:
		tween.tween_interval(float_offset)

	# Anima la posizione Y della RichTextLabel
	# Parte dal basso (-amplitude) e va su (+amplitude), poi torna al centro
	# Usiamo EaseInOut per un movimento più naturale (accelera e decelera)
	tween.tween_property(rich_text_label, "position:y", initial_position_y - float_amplitude, float_duration / 2.0)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_SINE) # O TRANS_QUAD, TRANS_CIRC, ecc.

	tween.tween_property(rich_text_label, "position:y", initial_position_y + float_amplitude, float_duration / 2.0)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_SINE)
