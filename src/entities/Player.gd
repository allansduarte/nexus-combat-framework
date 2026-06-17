extends CharacterBody2D

## Velocidade de movimento do Player.
@export var speed: float = 200.0
## Recurso de ataque contendo os dados de dano e força de knockback.
@export var attack_resource: AttackResource

@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var hitbox_shape: CollisionShape2D = $HitboxComponent/CollisionShape2D

func _ready() -> void:
	# Começa com a hitbox desativada para não registrar colisões fora do ataque
	if hitbox_shape:
		hitbox_shape.disabled = true
	if attack_resource and hitbox:
		hitbox.attack = attack_resource

func _physics_process(_delta: float) -> void:
	# Suporta tanto setas (via ui_*) quanto teclas WASD diretamente por código para evitar problemas de InputMap
	var input_dir: Vector2 = Vector2.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0
	
	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		# Ajusta a direção horizontal da hitbox com base na direção do movimento
		if hitbox:
			if input_dir.x < 0.0:
				hitbox.position.x = -40.0
			elif input_dir.x > 0.0:
				hitbox.position.x = 40.0
	
	velocity = input_dir * speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	# Aciona o ataque ao pressionar Espaço ou Enter (ui_accept), clique esquerdo do mouse ou teclas de atalho (Z ou J)
	var is_attack_key: bool = false
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Z or event.keycode == KEY_J:
			is_attack_key = true
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_attack_key = true
	
	if event.is_action_pressed("ui_accept") or is_attack_key:
		attack()

## Ativa temporariamente a hitbox para aplicar o ataque nas áreas sobrepostas.
func attack() -> void:
	if not hitbox_shape:
		return
	
	hitbox_shape.disabled = false
	
	# Aguarda a física processar colisões
	await get_tree().create_timer(0.15).timeout
	
	hitbox_shape.disabled = true
