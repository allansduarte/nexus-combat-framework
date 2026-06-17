class_name HitboxComponent
extends Area2D
## Componente que define a área física de impacto de um ataque (Hitbox).
##
## Carrega um AttackResource que especifica as propriedades de força do ataque
## (como dano e força de knockback) que serão transferidas ao atingir uma Hurtbox.

@export var attack: AttackResource
