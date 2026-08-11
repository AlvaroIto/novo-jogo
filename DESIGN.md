# Design do Jogo

> **"Conquiste o tempo. Ou seja devorado por ele."**

Roguelite de ação onde você só anda para os lados, enfrenta centenas de
inimigos e avança por civilizações perdidas em um mundo onde o tempo
entrou em colapso.

## Pilares

- **Movimento apenas horizontal** — direita = progresso, esquerda = recuo
  (com limite na base, de onde o personagem sai).
- **Distância = território conquistado** — o objetivo de cada run é
  completar o mapa.
- **Hordas e evolução** — matar inimigos, coletar XP, subir de nível e
  escolher upgrades durante a run.
- **Meta-progressão** — voltar ao acampamento, gastar moedas, equipar
  itens e voltar mais forte.

## Loop de jogo

1. Anda para os lados
2. Enfrenta hordas
3. Sobe de nível e evolui
4. Empurra a horda
5. Avança e conquista novos territórios
6. Derrota o boss final e volta ao acampamento

## Estrutura de mapas e biomas

- **1 bioma = 1 mapa** com distância fixa (ex: 500 m).
- **Mini-boss no meio do mapa** (~250 m) e **boss no final** (500 m).
- Ao completar o mapa, o jogador volta ao **acampamento**.
- Biomas planejados: Japão Feudal, Egito Antigo, Roma Imperial,
  Pérsia Antiga, Era Viking, China Antiga.
- **Futuro:** modo infinito, onde os biomas vão mudando a cada X metros.

## Classes e armas

### Classes iniciais

| Classe | Arma inicial | Passiva | Arma defensiva | Outras armas |
|---|---|---|---|---|
| **Samurai** | Katana (corte em área) | +10% velocidade de ataque | Postura de Iai (15% de esquiva) | yumi (arco longo), naginata (corte frontal de longo alcance) |
| **Viking** | Grito de Guerra (aura) | **Berserker**: quanto menos vida, mais dano (até +50%) | Sede de Sangue (roubo de vida: cura % do dano causado) | machado pesado (corte lento e forte), escudo orbital |
| **Espartano** | Pílum (projétil) | +1 dano em projéteis | Escudo de Bronze (reduz dano recebido em 20%) | formação de lanças (corte frontal), escudo orbital |

### Regras

- O personagem **inicia com 1 arma** e pode carregar **até 4** na run
  (quantidade em avaliação); armas defensivas contam nesse limite.
- Qualquer classe pode usar qualquer arma, mas armas da própria classe
  recebem **+25% de dano (bônus de afinidade)**.
- **Combinação de armas:** duas armas evoluídas podem ser combinadas
  em uma versão especial.
- Futuro: segunda passiva desbloqueável ao completar o mapa da
  civilização da classe.

### Classes futuras (próximos biomas)

- **Ninja:** shuriken (projéteis rápidos), kunai (perfurante), bomba de
  fumaça — armas furtivas do Japão Feudal
- **Persa:** arco (projéteis velozes)
- **Egípcio:** magia de areia (aura maior)
- **Romano:** gládio + scutum

## Efeitos de status (DoT e debuffs)

- 🩸 **Sangramento:** dano contínuo que acumula (stacks)
- 🧪 **Veneno:** dano contínuo, mais forte em inimigos com muita vida
- 🔥 **Queimadura:** dano contínuo explosivo (mais dano, menos duração)
- ❄️ **Congelamento:** inimigo fica mais lento (ou paralisado)

### Contramedidas

- **Chefes têm resistência a status** — congelamento dura metade e
  DoTs causam dano reduzido (para status não trivializarem chefes).
- **Jogador:** itens/upgrades de purificação (remove debuff),
  resistência elemental em equipamentos e imunidade temporária após
  um debuff terminar.

## Sistema de loot (estilo ARPG / Path of Exile)

- Drops de **itens equipáveis** durante a run.
- Slots de equipamento: armadura, capacete, calça, amuleto (e armas).
- **Sistema de raridade** (comum, incomum, raro, épico, lendário...).
- No acampamento é possível **equipar e gerenciar** os itens.

## Acampamento (meta-progressão)

- Acessado entre runs (ao morrer ou completar um mapa).
- Gastar moedas em **upgrades permanentes** de passivas (vida, dano,
  velocidade...).
- Equipar itens do loot.
- Escolher classe/personagem e o próximo mapa.

## HUD

- Distância percorrida (m)
- Moedas
- Tempo de run (topo, centralizado)
- Nível / barra de XP
- Vida

## Inimigos (bioma Japão Feudal)

| Inimigo | Comportamento |
|---|---|
| Normal | persegue o jogador (2 HP, velocidade 150) |
| Rápido | fraco e veloz (1 HP, velocidade 280) |
| Tanque | lento e resistente (6 HP, velocidade 70) |
| 🦇 Tengu | nasce acima da linha do chão e mergulha no jogador |
| 💣 Bombardeiro | corre e explode ao se aproximar (15 de dano); se explodir, não dá recompensa |
| 🏹 Arqueiro | para a 300px e atira flechas lentas (5 de dano); flechas podem ser destruídas por corte, aura ou projéteis |

**Tabela de spawn por distância:** 0–100 m só normais · 100–200 m +
rápidos, com tengu/bombardeiro/arqueiro raros (5% — gotejamento) ·
200–400 m mistura crescente · 400 m+ mistura total.

**Escala suave de HP:** inimigos comuns ganham +1 HP a cada 200 m
(chefes não são afetados).

**Adiados:** Escudeiro (escudo quebra após golpes frontais — repensar
junto com sinergias de classe).

## Chefes

- Cada bioma tem **chefes únicos** (ex: Shogun Corrompido, Faraó
  Amaldiçoado, General Romano, Rei Persa Imortal, Jötun Gigante).
- Mini-boss na metade do mapa e boss no final.

## Roadmap

1. [x] Distância + moedas na UI
2. [x] Variedade de inimigos + vida dos inimigos
3. [x] Chefes (mini-boss aos 250 m, boss aos 500 m)
4. [x] Condição de vitória do mapa → acampamento
5. [x] Acampamento (upgrades permanentes + equipar loot)
6. [x] Classes com armas, defensivas e passivas diferentes
7. [ ] Sistema de efeitos de status (sangramento, veneno, queimadura,
   congelamento) + contramedidas
8. [ ] Sistema de loot com raridade
9. [ ] Novos biomas/mapas
10. [ ] Modo infinito
11. [ ] Áudio (música, efeitos de tiro, dano)

## Ideias em aberto

- Knockback ao tomar dano (empurrão para a esquerda)
- Movimentação no eixo Y (voar ou plataformas)
- Pressão dinâmica de spawn: se o jogador estiver matando rápido
  demais, o spawn acelera (para o balanceamento futuro)
- Imagem de conceito: `Docs/conceito.png`

## Implementado

- Movimentação lateral com limite de recuo na base
- Spawner de inimigos pela direita com dificuldade progressiva
- Ataque automático com projéteis (mira no inimigo mais próximo)
- Armas automáticas: corte em área (3 de dano a cada 1,5s num raio de
  130px) e aura de dano contínuo (1 de dano a cada 0,5s num raio de 100px)
- Sistema de vida, dano e invencibilidade temporária
- XP com gemas magnéticas e level up com 3 upgrades aleatórios de um
  pool de 6: vida, velocidade, velocidade de ataque, dano do projétil,
  chance de perfurar e chance de tiro duplo
- UI: vida, abates, tempo, nível, distância e moedas
- Variedade de inimigos: normal (2 HP), rápido (1 HP) e tanque (6 HP),
  com recompensas de moedas diferentes
- Tela de game over com estatísticas e reinício
- Mini-boss aos 250 m e boss final aos 500 m; derrotar o boss final
  abre a tela de vitória
- Acampamento: moedas persistem entre runs (autoload GameData) e
  compram upgrades permanentes (vida, dano, velocidade) com custo
  crescente; o jogo inicia no acampamento (equipar loot virá com o
  sistema de loot)
- Armas modulares (cenas próprias): projétil, corte e aura
- 3 classes jogáveis com seleção no acampamento: Samurai (katana/corte,
  +10% velocidade de ataque), Viking (aura, Berserker) e Espartano
  (projétil, +1 dano em projéteis). Armas defensivas e armas extras de
  cada classe virão com os próximos sistemas
- Upgrades especiais adaptáveis por classe: projétil ganha
  perfurar/tiro duplo; corte e aura ganham alcance/ataque duplo
- Sprites de pixel art (pack craftpix): samurai do jogador, arqueiro,
  mini-boss, boss final e flecha dos arqueiros
- Cenário em camadas com parallax (céu fixo, horizonte e chão com
  repetição), gema de XP, efeito de corte e ícone de moeda com arte
