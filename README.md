# PokéTeam 🎮

Planejador de equipes Pokémon com dados da [PokéAPI](https://pokeapi.co).

---

## 📁 Estrutura de Pastas

```
poketeam/
├── pubspec.yaml
└── lib/
    ├── main.dart                          # Entry point, rotas, Provider
    │
    ├── core/
    │   ├── constants/
    │   │   └── app_constants.dart         # URLs base, tamanho do time, rotas
    │   ├── theme/
    │   │   └── app_theme.dart             # Cores, tipografia, ThemeData
    │   └── pokeapi_service.dart           # Chamadas HTTP à PokéAPI
    │
    ├── features/
    │   ├── teams/
    │   │   ├── models/
    │   │   │   ├── team_model.dart        # Entidade PokemonTeam
    │   │   │   └── teams_provider.dart    # State management (ChangeNotifier)
    │   │   ├── screens/
    │   │   │   ├── home_screen.dart       # Tela principal + BottomNav
    │   │   │   ├── teams_screen.dart      # Lista de times
    │   │   │   └── team_detail_screen.dart# Detalhe + slots do time
    │   │   └── widgets/
    │   │       ├── team_card.dart         # Card de um time na lista
    │   │       └── empty_teams_state.dart # Empty state com Pokébola
    │   │
    │   └── search/
    │       ├── models/
    │       │   └── pokemon_model.dart     # Entidade Pokemon + PokemonType
    │       └── screens/
    │           ├── search_screen.dart     # Busca livre (aba Buscar)
    │           └── search_to_add_screen.dart # Busca para adicionar ao time
    │
    └── shared/
        └── widgets/
            ├── pixel_button.dart          # Botão pixel art com sombra
            └── type_badge.dart            # Badge colorido de tipo Pokémon
```

---

## 🚀 Como Rodar

### Pré-requisitos
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0

### Passos

```bash
# 1. Clone ou copie o projeto
cd poketeam

# 2. Instale as dependências
flutter pub get

# 3. Rode no emulador ou dispositivo
flutter run
```

---

## 📦 Dependências

| Pacote | Uso |
|---|---|
| `google_fonts` | Fontes Press Start 2P + VT323 (pixel art) |
| `http` | Requisições à PokéAPI |
| `provider` | Gerenciamento de estado |
| `cached_network_image` | Cache de sprites Pokémon |

---

## 🗺️ Rotas

| Rota | Tela | Argumento |
|---|---|---|
| `/` | HomeScreen (Times + Buscar) | — |
| `/team-detail` | Detalhe do time + slots | `String teamId` |
| `/search-to-add` | Busca para adicionar ao time | `String teamId` |

---

## 🔮 Próximos Passos

- [ ] Tela de detalhes do Pokémon (stats, moves)
- [ ] Persistência local com `shared_preferences` ou `hive`
- [ ] Análise de cobertura de tipos do time
- [ ] Paginação na listagem de Pokémon
- [ ] Animações de transição estilo Game Boy
