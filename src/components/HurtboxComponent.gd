class_name HurtboxComponent
extends Area2D
## Componente que detecta colisões com áreas de ataque (HitboxComponent).
##
## Este componente monitora a entrada de áreas e, ao identificar uma hitbox válida
## contendo um AttackResource, valida e emite o sinal received_attack.
##
## NOTA DE DESACOPLAMENTO: Conforme as regras do projeto, nós de mesma hierarquia (irmãos/siblings)
## não devem chamar métodos diretamente uns dos outros. Portanto, a entidade pai deve
## conectar o sinal received_attack deste componente ao método take_damage do HealthComponent.

## Emitido quando um ataque válido é detectado.
signal received_attack(attack: AttackResource, hitbox_global_position: Vector2)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	# Verifica dinamicamente se a área que entrou possui a propriedade 'attack' do tipo AttackResource
	if "attack" in area:
		var attack: AttackResource = area.get("attack") as AttackResource
		if attack:
			received_attack.emit(attack, area.global_position)

