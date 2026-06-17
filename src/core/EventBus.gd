extends Node
## Barramento de eventos global (Event Bus) para o sistema de combate.
##
## Este Singleton gerencia a comunicação desacoplada entre diferentes sistemas e entidades,
## permitindo que eventos de dano, morte e alteração de vida sejam transmitidos globalmente.

## Emitido quando a vida de qualquer entidade muda.
signal health_changed(entity: Node, current_health: float, max_health: float)

## Emitido quando qualquer entidade morre.
signal died(entity: Node)

## Emitido quando dano é causado a um alvo por um atacante.
signal damage_dealt(attacker: Node, target: Node, amount: float)
