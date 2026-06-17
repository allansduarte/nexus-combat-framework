class_name EnemyDummy
extends CharacterBody2D
## Script que controla o boneco de testes (EnemyDummy) na física e no combate.
##
## Gerencia o acoplamento local entre Hurtbox, Health e CombatHandler por meio de
## sinais, reduz gradualmente a velocidade de knockback recebida e reporta ao EventBus global.

## Força de atrito aplicada para desacelerar o Dummy após receber knockback.
@export var friction: float = 600.0

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var combat_handler: CombatHandler = $CombatHandler

func _ready() -> void:
	# Encaminha o ataque detectado pela Hurtbox diretamente ao HealthComponent para processar o dano.
	# O nó pai atua como o mediador que realiza chamadas descendentes para seus filhos diretos.
	if hurtbox_component and health_component:
		hurtbox_component.received_attack.connect(func(attack: AttackResource, _pos: Vector2) -> void:
			health_component.take_damage(attack.damage)
		)
	
	# Conecta os sinais locais do HealthComponent ao EventBus global.
	if health_component:
		health_component.health_changed.connect(func(current_health: float, max_health: float) -> void:
			EventBus.health_changed.emit(self, current_health, max_health)
		)
		
		health_component.died.connect(func() -> void:
			EventBus.died.emit(self)
			# Para facilitar os testes contínuos no playground, reseta a vida do boneco ao morrer.
			health_component.reset_health()
			print("Dummy morreu! Vida restaurada para novos testes.")
		)

func _physics_process(delta: float) -> void:
	# Desacelera progressivamente o impacto do knockback usando atrito linear
	if velocity != Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()
