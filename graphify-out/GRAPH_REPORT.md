# Graph Report - workspace  (2026-08-20)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 249 nodes · 521 edges · 10 communities
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 47 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `765a71a5`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- MarginBreakdown
- RayonKind
- .display
- CalculatorView
- LiveFeedService
- View
- Mode
- Components.swift
- HighValueView
- AppTab

## God Nodes (most connected - your core abstractions)
1. `LiveFeedService` - 35 edges
2. `FreshProduct` - 32 edges
3. `RayonKind` - 30 edges
4. `CalculatorView` - 26 edges
5. `VATRate` - 23 edges
6. `MarginBreakdown` - 23 edges
7. `SavedCalculation` - 15 edges
8. `LiveEvent` - 15 edges
9. `UColor` - 14 edges
10. `HighValueView` - 14 edges

## Surprising Connections (you probably didn't know these)
- `.saveBlock` --calls--> `SavedCalculation`  [INFERRED]
  UFrais/UFrais/Views/CalculatorView.swift → UFrais/UFrais/Models/CalculatorEngine.swift
- `.body` --references--> `RayonKind`  [INFERRED]
  UFrais/UFrais/Views/Components.swift → UFrais/UFrais/Models/Domain.swift
- `.body` --calls--> `HomeView`  [INFERRED]
  UFrais/UFrais/ContentView.swift → UFrais/UFrais/Views/HomeView.swift
- `.body` --calls--> `CalculatorView`  [INFERRED]
  UFrais/UFrais/ContentView.swift → UFrais/UFrais/Views/CalculatorView.swift
- `.caJour` --references--> `FreshProduct`  [INFERRED]
  UFrais/UFrais/Services/LiveFeedService.swift → UFrais/UFrais/Models/Domain.swift

## Import Cycles
- None detected.

## Communities (10 total, 0 thin omitted)

### Community 0 - "MarginBreakdown"
Cohesion: 0.06
Nodes (33): Codable, Combine, Foundation, IndexSet, ObservableObject, MarginBreakdown, .coefficient, .grossMargin (+25 more)

### Community 1 - "RayonKind"
Cohesion: 0.07
Nodes (30): Equatable, Identifiable, SwiftUI, Kind, alert, dlc, opportunity, sale (+22 more)

### Community 2 - ".display"
Cohesion: 0.11
Nodes (27): Font, StoreIdentity, CGFloat, UColor, UFont, View, .body, .body (+19 more)

### Community 3 - "CalculatorView"
Cohesion: 0.13
Nodes (24): String, CalculatorEngine, Double, .euros, .eurosCompact, .numberFR, .percentFR, String (+16 more)

### Community 4 - "LiveFeedService"
Cohesion: 0.08
Nodes (26): Hashable, Never, Task, SampleCatalog, Bool, Int, String, FreshProduct (+18 more)

### Community 5 - "View"
Cohesion: 0.20
Nodes (14): MarqueGauge, Sparkline, .body, ProductDetailView, .body, String, UUID, RayonCard (+6 more)

### Community 6 - "Mode"
Cohesion: 0.22
Nodes (9): CaseIterable, Mode, marge, objectif, tva, Ranking, alertes, contribution (+1 more)

### Community 8 - "Components.swift"
Cohesion: 0.19
Nodes (10): Content, DecimalField, KPIStat, Shimmer, CGFloat, Color, String, View (+2 more)

### Community 9 - "HighValueView"
Cohesion: 0.21
Nodes (12): RayonChip, .body, HighValueView, .body, .eventRail, .filtered, .productList, .rankingPicker (+4 more)

### Community 10 - "AppTab"
Cohesion: 0.12
Nodes (16): App, Scene, AppTab, accueil, calcul, .id, rayons, .symbol (+8 more)

## Knowledge Gaps
- **71 isolated node(s):** `StoreIdentity`, `alimentaire`, `.caption`, `.id`, `intermediaire` (+66 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LiveFeedService` connect `LiveFeedService` to `MarginBreakdown`, `RayonKind`, `.display`, `CalculatorView`, `View`, `HighValueView`, `AppTab`?**
  _High betweenness centrality (0.191) - this node is a cross-community bridge._
- **Why does `FreshProduct` connect `LiveFeedService` to `MarginBreakdown`, `RayonKind`, `CalculatorView`, `View`, `HighValueView`?**
  _High betweenness centrality (0.181) - this node is a cross-community bridge._
- **Why does `Double` connect `CalculatorView` to `MarginBreakdown`, `RayonKind`, `.display`, `LiveFeedService`, `View`, `Components.swift`?**
  _High betweenness centrality (0.149) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `LiveFeedService` (e.g. with `UFraisApp` and `.eventRail`) actually correct?**
  _`LiveFeedService` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 6 inferred relationships involving `FreshProduct` (e.g. with `.caJour` and `.margeJour`) actually correct?**
  _`FreshProduct` has 6 INFERRED edges - model-reasoned connections that need verification._
- **What connects `StoreIdentity`, `alimentaire`, `.caption` to the rest of the system?**
  _71 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `MarginBreakdown` be split into smaller, more focused modules?**
  _Cohesion score 0.06423034330011074 - nodes in this community are weakly interconnected._