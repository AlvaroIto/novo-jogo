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

- Classes jogáveis diferentes, cada uma com **arma inicial** e
  **bônus passivos** próprios (ex: Samurai, Viking, Espartano, Romano,
  Persa, Egípcio).
- Armas variadas: espadas, machados, arco e flecha etc.
- Todos os personagens podem usar qualquer arma encontrada durante a
  jornada.
- Armas podem ser combinadas/evoluídas com itens e relíquias durante a
  run (builds).

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

## Chefes

- Cada bioma tem **chefes únicos** (ex: Shogun Corrompido, Faraó
  Amaldiçoado, General Romano, Rei Persa Imortal, Jötun Gigante).
- Mini-boss na metade do mapa e boss no final.

## Roadmap

1. [ ] Distância + moedas na UI
2. [ ] Variedade de inimigos + vida dos inimigos
3. [ ] Chefes (mini-boss aos 250 m, boss aos 500 m)
4. [ ] Condição de vitória do mapa → acampamento
5. [ ] Acampamento (upgrades permanentes + equipar loot)
6. [ ] Classes com armas e passivas diferentes
7. [ ] Sistema de loot com raridade
8. [ ] Novos biomas/mapas
9. [ ] Modo infinito
10. [ ] Áudio (música, efeitos de tiro, dano)

## Ideias em aberto

- Knockback ao tomar dano (empurrão para a esquerda)
- Movimentação no eixo Y (voar ou plataformas)
- Imagem de conceito: `Docs/conceito.png`

## Implementado

- Movimentação lateral com limite de recuo na base
- Spawner de inimigos pela direita com dificuldade progressiva
- Ataque automático com projéteis (mira no inimigo mais próximo)
- Sistema de vida, dano e invencibilidade temporária
- XP com gemas magnéticas e level up com 3 upgrades
- UI: vida, abates, tempo e nível
- Tela de game over com estatísticas e reinício
