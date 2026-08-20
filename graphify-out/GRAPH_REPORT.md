# Graph Report - workspace  (2026-08-20)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 321 nodes · 581 edges · 21 communities (16 shown, 5 thin omitted)
- Extraction: 92% EXTRACTED · 8% INFERRED · 0% AMBIGUOUS · INFERRED: 47 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `4b9551d9`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- MarginBreakdown
- RayonKind
- View
- CalculatorView
- LiveFeedService
- What You Must Do When Invoked
- HistoryStore
- graphify reference: extra exports and benchmark
- Components.swift
- HighValueView
- AppTab
- U Frais — Super U Ligné
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md

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
- `.product` --references--> `LiveFeedService`  [INFERRED]
  UFrais/UFrais/Views/ProductDetailView.swift → UFrais/UFrais/Services/LiveFeedService.swift
- `.saveBlock` --calls--> `SavedCalculation`  [INFERRED]
  UFrais/UFrais/Views/CalculatorView.swift → UFrais/UFrais/Models/CalculatorEngine.swift
- `.body` --references--> `RayonKind`  [INFERRED]
  UFrais/UFrais/Views/Components.swift → UFrais/UFrais/Models/Domain.swift
- `UFraisApp` --calls--> `LiveFeedService`  [INFERRED]
  UFrais/UFrais/UFraisApp.swift → UFrais/UFrais/Services/LiveFeedService.swift
- `.body` --calls--> `ContentView`  [INFERRED]
  UFrais/UFrais/UFraisApp.swift → UFrais/UFrais/ContentView.swift

## Import Cycles
- None detected.

## Communities (21 total, 5 thin omitted)

### Community 0 - "MarginBreakdown"
Cohesion: 0.06
Nodes (34): Codable, Combine, Foundation, SampleCatalog, Bool, Int, String, MarginBreakdown (+26 more)

### Community 1 - "RayonKind"
Cohesion: 0.07
Nodes (30): Equatable, Identifiable, SwiftUI, Kind, alert, dlc, opportunity, sale (+22 more)

### Community 2 - "View"
Cohesion: 0.08
Nodes (42): Font, StoreIdentity, CGFloat, UColor, UFont, View, .body, .body (+34 more)

### Community 3 - "CalculatorView"
Cohesion: 0.13
Nodes (23): String, CalculatorEngine, Double, .euros, .eurosCompact, .numberFR, .percentFR, String (+15 more)

### Community 4 - "LiveFeedService"
Cohesion: 0.11
Nodes (21): Hashable, Never, Task, FreshProduct, .contributionToday, .dlcAlert, .opportunityScore, .stockAlert (+13 more)

### Community 5 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 6 - "HistoryStore"
Cohesion: 0.20
Nodes (7): App, IndexSet, ObservableObject, Scene, HistoryStore, UFraisApp, .historyBlock

### Community 7 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 8 - "Components.swift"
Cohesion: 0.17
Nodes (12): Content, DecimalField, KPIStat, Shimmer, Sparkline, .body, CGFloat, Color (+4 more)

### Community 9 - "HighValueView"
Cohesion: 0.21
Nodes (12): RayonChip, .body, HighValueView, .body, .eventRail, .filtered, .productList, .rankingPicker (+4 more)

### Community 10 - "AppTab"
Cohesion: 0.10
Nodes (20): CaseIterable, AppTab, accueil, calcul, .id, rayons, .symbol, .title (+12 more)

### Community 11 - "U Frais — Super U Ligné"
Cohesion: 0.25
Nodes (7): Charte, Fonctionnalités, Formules magasin, Graphify (graphe de connaissances), Ouvrir dans Xcode, Structure, U Frais — Super U Ligné

### Community 12 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 14 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 15 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 16 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

## Knowledge Gaps
- **120 isolated node(s):** `StoreIdentity`, `alimentaire`, `.caption`, `.id`, `intermediaire` (+115 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LiveFeedService` connect `LiveFeedService` to `MarginBreakdown`, `RayonKind`, `View`, `CalculatorView`, `HistoryStore`, `HighValueView`?**
  _High betweenness centrality (0.115) - this node is a cross-community bridge._
- **Why does `FreshProduct` connect `LiveFeedService` to `MarginBreakdown`, `RayonKind`, `View`, `CalculatorView`, `HighValueView`?**
  _High betweenness centrality (0.109) - this node is a cross-community bridge._
- **Why does `Double` connect `CalculatorView` to `MarginBreakdown`, `RayonKind`, `View`, `LiveFeedService`, `Components.swift`?**
  _High betweenness centrality (0.090) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `LiveFeedService` (e.g. with `UFraisApp` and `.eventRail`) actually correct?**
  _`LiveFeedService` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 6 inferred relationships involving `FreshProduct` (e.g. with `.caJour` and `.margeJour`) actually correct?**
  _`FreshProduct` has 6 INFERRED edges - model-reasoned connections that need verification._
- **What connects `StoreIdentity`, `alimentaire`, `.caption` to the rest of the system?**
  _120 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `MarginBreakdown` be split into smaller, more focused modules?**
  _Cohesion score 0.06282051282051282 - nodes in this community are weakly interconnected._