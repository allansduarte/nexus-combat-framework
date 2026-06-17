class_name HealthComponent
extends Node
## Componente responsável por gerenciar os pontos de vida (HP) de uma entidade.
##
## Gerencia a vida máxima e atual, aplica dano, cura e notifica outras partes
## do jogo usando sinais quando a vida muda ou a entidade morre.

## Emitido quando a vida da entidade sofre alguma alteração.
signal health_changed(current_health: float, max_health: float)

## Emitido quando a vida atual da entidade chega a zero.
signal died

@export var max_health: float = 100.0

var current_health: float

func _ready() -> void:
	current_health = max_health

## Reduz a vida da entidade com base no valor de dano especificado.
func take_damage(amount: float) -> void:
	if amount <= 0.0:
		return
	
	current_health = clampf(current_health - amount, 0.0, max_health)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0.0:
		died.emit()

## Aumenta a vida da entidade com base no valor de cura especificado.
func heal(amount: float) -> void:
	if amount <= 0.0 or current_health <= 0.0:
		return
	
	current_health = clampf(current_health + amount, 0.0, max_health)
	health_changed.emit(current_health, max_health)

## Redefine a vida atual para o valor máximo, emitindo o sinal correspondente.
func reset_health() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)
