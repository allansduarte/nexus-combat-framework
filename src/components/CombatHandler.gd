class_name CombatHandler
extends Node
## Componente que processa reações físicas de combate de uma entidade.
##
## Este handler escuta o sinal de ataque de um HurtboxComponent e aplica
## uma força de knockback (empurrão) baseada na direção da colisão à velocidade
## do seu nó pai (CharacterBody2D).

@export var hurtbox: Node

@onready var parent: CharacterBody2D = get_parent() as CharacterBody2D

func _ready() -> void:
	if hurtbox:
		hurtbox.received_attack.connect(_on_received_attack)

## Processa o ataque recebido, calculando a força vetorial e aplicando-a à velocidade do pai.
func _on_received_attack(attack: AttackResource, hitbox_global_position: Vector2) -> void:
	if not parent:
		return
	
	# Calcula a direção do knockback (da posição global da Hitbox para o receptor)
	var direction: Vector2 = parent.global_position - hitbox_global_position
	
	if direction == Vector2.ZERO:
		# Se as posições globais coincidirem perfeitamente, empurra para cima por padrão
		direction = Vector2.UP
	else:
		direction = direction.normalized()
	
	# Aplica a força vetorial diretamente na propriedade velocity do CharacterBody2D
	var knockback_velocity: Vector2 = direction * attack.knockback_force
	parent.velocity = knockback_velocity
