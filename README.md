# ⚔️ Nexus Combat System

![Versão](https://img.shields.io/badge/versão-0.1.0-blue)
![Godot](https://img.shields.io/badge/Godot-4.6-478CBF?logo=godotengine&logoColor=white)
![Licença](https://img.shields.io/badge/licença-Comercial%20%2F%20Educacional-orange)
![GDScript](https://img.shields.io/badge/linguagem-GDScript-blue)

> **A espinha dorsal para sistemas de combate escaláveis na Godot 4.**
> Um framework de engenharia baseado em **Desacoplamento Atômico** e **Resource-Driven Design**, desenvolvido para desenvolvedores que precisam de código que sobreviva à escala do lançamento comercial.

---

## 📌 Por que o Nexus Combat System?

Para o desenvolvedor solo, o maior inimigo não é a lógica complexa — é o **acoplamento**. O Nexus resolve isso com uma arquitetura que garante:

- 🧩 **Seu Player não conhece o Inimigo** — a comunicação acontece via sinais e `EventBus`, sem referências diretas entre nós.
- 🖥️ **Sua UI não conhece o Mundo** — ela apenas reage a eventos globais, completamente desacoplada da lógica de jogo.
- 💥 **Seu Combate tem Peso** — integração nativa com a física 2D da Godot para knockback vetorial realista.
- 📂 **Zero valores hardcoded** — todos os dados de combate vivem em `Resource` (arquivos `.tres`), editáveis direto no Inspector.

---

## ⚙️ Pré-requisitos

| Requisito | Versão mínima |
|---|---|
| [Godot Engine](https://godotengine.org/) | **4.6+** |

Nenhuma dependência externa ou plugin adicional é necessário. O framework é 100% GDScript nativo.

---

## 🚀 Como Usar

### 1. Importe o projeto
Clone ou baixe o repositório e abra a pasta como um projeto na Godot:

```
Projeto > Importar > Selecione a pasta do projeto
```

### 2. Explore a cena de demonstração
Abra e execute `Playground.tscn` para ver o sistema funcionando em tempo real:
- O **Player** possui um `HitboxComponent` ativo.
- O **EnemyDummy** possui `HealthComponent`, `HurtboxComponent` e `CombatHandler`.
- A **PlaygroundUI** exibe a barra de vida do inimigo, alimentada pelo `EventBus`.

### 3. Adicione os componentes ao seu personagem
Arraste os scripts de `res://src/components/` como filhos das suas entidades e configure os recursos no Inspector. Siga a estrutura do `EnemyDummy` como referência.

---

## 📦 Arquitetura dos Componentes

### 1. `HealthComponent` — Núcleo de Vida
Um `Node` puro que gerencia a integridade da entidade. Completamente independente de física ou visual — pode ser usado em um Player, um Barril ou um Boss.

| Elemento | Descrição |
|---|---|
| **Sinal** `health_changed(current_health, max_health)` | Emitido sempre que o HP muda. |
| **Sinal** `died` | Emitido quando o HP chega a zero. |
| **Método** `take_damage(amount: float)` | Aplica dano à entidade. |
| **Método** `heal(amount: float)` | Restaura HP à entidade. |
| **Método** `reset_health()` | Restaura o HP ao valor máximo. |

---

### 2. `HitboxComponent` — Origem do Dano
`Area2D` que carrega um `AttackResource`. Define **onde** e **com que força** o dano nasce no mundo. Existe na **Collision Layer 3**.

---

### 3. `HurtboxComponent` — Receptor de Dano
`Area2D` que escaneia a **Collision Layer 3** em busca de Hitboxes. Ao detectar sobreposição, emite o sinal `received_attack(attack, hitbox_global_position)`, sem aplicar lógica diretamente.

---

### 4. `AttackResource` — Dados de Ataque
O fim dos valores hardcoded. Defina seus ataques em arquivos `.tres` editáveis no Inspector.

| Campo | Tipo | Descrição |
|---|---|---|
| `damage` | `float` | Quantidade de dano causado. |
| `knockback_force` | `float` | Intensidade do empurrão. |

> Crie variações de armas, habilidades e projéteis sem tocar em uma linha de código de gameplay.

---

### 5. `CombatHandler` — Resposta Física
`Node` que escuta o sinal da `HurtboxComponent` e traduz o ataque recebido em reação física. Calcula e aplica uma força vetorial de knockback à propriedade `velocity` do `CharacterBody2D` pai, com base na posição global da Hitbox atacante.

---

### 6. `EventBus` — Sistema Nervoso Central
Autoload global que atua como o barramento de comunicação de todo o framework. Permite que sistemas distantes (como a HUD) reajam a eventos de combate sem nenhuma referência direta entre nós.

| Sinal | Descrição |
|---|---|
| `health_changed(entity, current_health, max_health)` | Emitido quando o HP de qualquer entidade muda. |
| `died(entity)` | Emitido quando qualquer entidade morre. |
| `damage_dealt(attacker, target, amount)` | Emitido ao confirmar um dano. |

---

## 📂 Estrutura de Pastas

```
res://
├── Playground.tscn         # Cena de demonstração com Player e EnemyDummy
└── src/
    ├── core/               # Autoloads (EventBus)
    ├── components/         # Nós modulares reutilizáveis
    │   ├── HealthComponent.gd
    │   ├── HitboxComponent.gd
    │   ├── HurtboxComponent.gd
    │   └── CombatHandler.gd
    ├── resources/          # Scripts e arquivos .tres de dados
    │   └── AttackResource.gd
    ├── entities/           # Scripts de entidades de exemplo
    │   ├── Player.gd
    │   └── EnemyDummy.gd
    └── ui/                 # Interface desacoplada via EventBus
        └── PlaygroundUI.gd
```

---

## 📜 Licença de Uso

Este projeto é distribuído como **material educacional de uso comercial restrito**.

- ✅ Uso permitido em projetos pessoais e comerciais derivados do curso.
- ✅ Modificação e extensão do framework para seus próprios jogos.
- ❌ Redistribuição, revenda ou compartilhamento do código-fonte sem autorização.

Para dúvidas sobre licenciamento, entre em contato pelo canal de suporte do curso.

---

## 🤝 Suporte

Encontrou um bug ou tem uma dúvida sobre a arquitetura? Acesse o **canal de suporte exclusivo para alunos** disponível na plataforma do curso.

---

*Desenvolvido com ❤️ e muito GDScript.*