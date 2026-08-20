# Graph Report - workspace  (2026-08-20)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 272 nodes · 465 edges · 21 communities (16 shown, 5 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 21 edges (avg confidence: 0.82)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `dd076973`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SavedCalculation
- RayonKind
- .display
- CalculatorView
- VATRate
- What You Must Do When Invoked
- TrendFeedService
- graphify reference: extra exports and benchmark
- Components.swift
- MarginBreakdown
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
1. `CalculatorView` - 26 edges
2. `RayonKind` - 23 edges
3. `TrendFeedService` - 23 edges
4. `MarginBreakdown` - 21 edges
5. `VATRate` - 20 edges
6. `TrendingProduct` - 18 edges
7. `SavedCalculation` - 14 edges
8. `HistoryStore` - 12 edges
9. `TrendHeat` - 12 edges
10. `UColor` - 12 edges

## Surprising Connections (you probably didn't know these)
- `.product` --references--> `TrendFeedService`  [INFERRED]
  UFrais/UFrais/Views/TendancesView.swift → UFrais/UFrais/Services/TrendFeedService.swift
- `.saveBlock` --calls--> `SavedCalculation`  [INFERRED]
  UFrais/UFrais/Views/CalculatorView.swift → UFrais/UFrais/Models/CalculatorEngine.swift
- `UFraisApp` --calls--> `HistoryStore`  [INFERRED]
  UFrais/UFrais/UFraisApp.swift → UFrais/UFrais/Services/HistoryStore.swift
- `.body` --references--> `RayonKind`  [INFERRED]
  UFrais/UFrais/Views/Components.swift → UFrais/UFrais/Models/Domain.swift
- `.list` --references--> `TrendingProduct`  [INFERRED]
  UFrais/UFrais/Views/TendancesView.swift → UFrais/UFrais/Models/Domain.swift

## Import Cycles
- None detected.

## Communities (21 total, 5 thin omitted)

### Community 0 - "SavedCalculation"
Cohesion: 0.15
Nodes (11): Combine, Equatable, Foundation, IndexSet, ObservableObject, SavedCalculation, Date, String (+3 more)

### Community 1 - "RayonKind"
Cohesion: 0.08
Nodes (34): CaseIterable, Codable, Hashable, Identifiable, RayonKind, boucherie, boulangerie, charcuterie (+26 more)

### Community 2 - ".display"
Cohesion: 0.13
Nodes (23): Font, CGFloat, UColor, UFont, View, .body, .body, .body (+15 more)

### Community 3 - "CalculatorView"
Cohesion: 0.20
Nodes (18): String, CalculatorView, .body, .breakdown, .fields, .header, .margeResults, .modePicker (+10 more)

### Community 4 - "VATRate"
Cohesion: 0.15
Nodes (15): CalculatorEngine, VATRate, alimentaire, .caption, .id, intermediaire, .label, normal (+7 more)

### Community 5 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 6 - "TrendFeedService"
Cohesion: 0.19
Nodes (10): Data, JSONDecoder, JSONEncoder, Date, TrendsPayload, Date, String, TrendFeedService (+2 more)

### Community 7 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 8 - "Components.swift"
Cohesion: 0.13
Nodes (18): Content, DecimalField, KPIStat, LiveBadge, .body, RayonChip, .body, Shimmer (+10 more)

### Community 9 - "MarginBreakdown"
Cohesion: 0.14
Nodes (14): MarginBreakdown, .coefficient, .grossMargin, .isLoss, .isValid, .marginRate, .marqueRate, .paTTC (+6 more)

### Community 10 - "AppTab"
Cohesion: 0.13
Nodes (15): App, Scene, SwiftUI, AppTab, calcul, .id, .symbol, tendances (+7 more)

### Community 11 - "U Frais — Super U Ligné"
Cohesion: 0.25
Nodes (7): Calculateur, Charte, Formules, Graphify, Ouvrir dans Xcode, Tendances (web), U Frais — Super U Ligné

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
- **103 isolated node(s):** `StoreIdentity`, `.coefficient`, `.grossMargin`, `.isLoss`, `.isValid` (+98 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `CalculatorView` connect `CalculatorView` to `SavedCalculation`, `RayonKind`, `VATRate`, `MarginBreakdown`, `AppTab`?**
  _High betweenness centrality (0.110) - this node is a cross-community bridge._
- **Why does `VATRate` connect `VATRate` to `SavedCalculation`, `MarginBreakdown`, `CalculatorView`, `RayonKind`?**
  _High betweenness centrality (0.080) - this node is a cross-community bridge._
- **Why does `TrendFeedService` connect `TrendFeedService` to `SavedCalculation`, `RayonKind`, `AppTab`, `.display`?**
  _High betweenness centrality (0.080) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `TrendFeedService` (e.g. with `UFraisApp` and `.product`) actually correct?**
  _`TrendFeedService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `StoreIdentity`, `.coefficient`, `.grossMargin` to the rest of the system?**
  _103 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `RayonKind` be split into smaller, more focused modules?**
  _Cohesion score 0.0761904761904762 - nodes in this community are weakly interconnected._
- **Should `.display` be split into smaller, more focused modules?**
  _Cohesion score 0.12873563218390804 - nodes in this community are weakly interconnected._