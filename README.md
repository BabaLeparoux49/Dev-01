# U Frais — Super U Ligné

Application iOS pour l’adjoint de direction **produits frais** du Super U de Ligné (44850).

Deux outils, zéro chiffre magasin :

1. **Calculateur** — marges, taux de marque, coefficient, TVA
2. **Tendances** — produits en vogue (web / réseaux), mis à jour chaque jour

## Calculateur

- **Marge** : PA HT + PV TTC + TVA → PV HT, marge brute, taux de marge, **taux de marque**, coefficient, TVA collectée / nette
- **Objectif** : prix de vente TTC pour une marque cible
- **TVA** : 2,1 % / 5,5 % / 10 % / 20 %

## Tendances (web)

L’onglet Tendances charge `UFrais/UFrais/Data/trends.json` :

- en local (packagé dans l’app)
- puis depuis le web (GitHub raw) pour rester à jour **sans republier l’app**
- signaux presse optionnels (RSS food)

Pour rafraîchir le contenu du jour : édite `trends.json`, commit, push. L’app récupère la nouvelle version au prochain refresh / pull-to-refresh.

## Charte

| Rôle | Hex |
| --- | --- |
| Rouge historique | `#E22019` |
| Bleu signature | `#007D8F` |
| Bleu ciel | `#64C5E4` |
| Vert d’eau | `#6BBFB6` |

## Formules

- **PV HT** = PV TTC ÷ (1 + TVA)
- **Marge brute** = PV HT − PA HT
- **Taux de marge** = Marge brute ÷ PA HT
- **Taux de marque** = Marge brute ÷ PV HT
- **Coefficient** = PV HT ÷ PA HT

## Ouvrir dans Xcode

1. Ouvrir `UFrais/UFrais.xcodeproj` (Xcode 15+, iOS 17+)
2. Signing → choisir ta **Team**
3. Brancher l’iPhone → ▶ Run
4. Sur iPhone : Réglages → Général → VPN et gestion de l’appareil → Faire confiance

## Graphify

```bash
uv tool install graphifyy
graphify cursor install --project
graphify update .
```
