extends Control
## Controlador da interface gráfica (UI) do Playground.
##
## Conecta-se ao EventBus global para atualizar dinamicamente a barra de vida (ProgressBar)
## correspondente ao boneco de testes (EnemyDummy) alvo sem acoplamento direto de referências.

## Referência para o Dummy cujos dados queremos exibir na tela.
@export var dummy: Node

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	if progress_bar:
		progress_bar.max_value = 100.0
		progress_bar.value = 100.0
	
	# Conecta-se ao sinal global do EventBus
	EventBus.health_changed.connect(_on_health_changed)

## Atualiza o valor exibido na ProgressBar caso o sinal recebido seja da entidade Dummy configurada.
func _on_health_changed(entity: Node, current_health: float, max_health: float) -> void:
	if entity == dummy and progress_bar:
		progress_bar.max_value = max_health
		progress_bar.value = current_health
