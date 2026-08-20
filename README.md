# U Frais — Super U Ligné

Application iOS de pilotage des **produits frais** pour l’adjoint de direction du Super U de Ligné (44850). Elle sert au quotidien : calcul des marges et de la TVA, et suivi en direct des articles à forte valeur ajoutée par rayon.

## Fonctionnalités

- **Accueil** — CA du jour, marge brute, marque moyenne, alertes stock / DLC, top 3 valeur ajoutée, santé des rayons.
- **Calculateur**
  - Marge : PA HT, PV TTC, TVA → PV HT, marge brute, taux de marge, **taux de marque**, coefficient, TVA collectée / nette.
  - Objectif : prix de vente TTC conseillé pour une marque cible.
  - TVA : conversion HT ↔ TTC (2,1 %, 5,5 %, 10 %, 20 %).
- **Forte VA** — classement live par contribution ou par marque, filtres par rayon, fil d’actualités (ventes, ruptures, DLC, opportunités).
- **Rayons** — Fruits & Légumes, Boucherie, Poissonnerie, Charcuterie, Crèmerie, Traiteur, Boulangerie.

Le flux « temps réel » est **simulé** à partir d’un catalogue frais type Super U Ligné, en attendant une connexion caisse / GPAO.

## Charte

Couleurs de la coopérative U :

| Rôle | Hex |
| --- | --- |
| Rouge historique | `#E22019` |
| Bleu signature | `#007D8F` |
| Bleu ciel | `#64C5E4` |
| Vert d’eau | `#6BBFB6` |

## Formules magasin

- **PV HT** = PV TTC ÷ (1 + TVA)
- **Marge brute** = PV HT − PA HT
- **Taux de marge** = Marge brute ÷ PA HT
- **Taux de marque** = Marge brute ÷ PV HT
- **Coefficient** = PV HT ÷ PA HT
- **PV TTC cible** = [PA HT ÷ (1 − marque visée)] × (1 + TVA)

## Ouvrir dans Xcode

1. Sur un Mac, ouvrir `UFrais/UFrais.xcodeproj`.
2. Sélectionner un iPhone simulateur (iOS 17 ou plus).
3. Choisir votre **Team** de signature dans la cible `UFrais` pour installer sur un iPhone.
4. Lancer avec ⌘R.

Prérequis : Xcode 15+, iOS 17+.

## Structure

```
UFrais/
  UFrais.xcodeproj
  UFrais/
    UFraisApp.swift
    ContentView.swift
    Theme/          couleurs et typo U
    Models/         rayons, produits, moteur de calcul
    Data/           catalogue frais Ligné
    Services/       flux live + historique
    Views/          écrans et composants
```

## Graphify (graphe de connaissances)

Ce dépôt inclut [Graphify](https://github.com/Graphify-Labs/graphify) pour cartographier le code Swift et faciliter la navigation dans Cursor.

**Installation locale** (Mac ou Linux) :

```bash
uv tool install graphifyy
graphify cursor install --project
graphify . --code-only && graphify cluster-only .
```

**Utilisation dans Cursor** : tapez `/graphify .` ou interrogez le graphe :

```bash
graphify query "comment fonctionne le calculateur de marge ?"
graphify path "LiveFeedService" "MarginBreakdown"
graphify explain "VATRate"
```

Artefacts générés dans `graphify-out/` :

- `graph.html` — visualisation interactive
- `GRAPH_REPORT.md` — synthèse architecture
- `graph.json` — graphe complet

Après modification du code : `graphify update .` (AST local, sans clé API).
