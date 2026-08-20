# Graph Report - workspace  (2026-08-20)

## Corpus Check
- 31 files · ~79,235 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 344 nodes · 615 edges · 22 communities (17 shown, 5 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 25 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e07a197f`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- String
- RayonKind
- .display
- CalculatorView
- MarginBreakdown
- What You Must Do When Invoked
- TrendFeedService
- graphify reference: extra exports and benchmark
- Components.swift
- ConcurrentView
- AppTab
- U Frais — Super U Ligné
- graphify reference: query, path, explain
- Coordinator
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
2. `MarginBreakdown` - 24 edges
3. `RayonKind` - 23 edges
4. `TrendFeedService` - 23 edges
5. `ConcurrentView` - 23 edges
6. `VATRate` - 21 edges
7. `TrendingProduct` - 18 edges
8. `SavedCalculation` - 14 edges
9. `CompetitorGap` - 14 edges
10. `TrendHeat` - 12 edges

## Surprising Connections (you probably didn't know these)
- `.product` --references--> `TrendFeedService`  [INFERRED]
  UFrais/UFrais/Views/TendancesView.swift → UFrais/UFrais/Services/TrendFeedService.swift
- `.body` --calls--> `CalculatorView`  [INFERRED]
  UFrais/UFrais/ContentView.swift → UFrais/UFrais/Views/CalculatorView.swift
- `.body` --calls--> `ConcurrentView`  [INFERRED]
  UFrais/UFrais/ContentView.swift → UFrais/UFrais/Views/ConcurrentView.swift
- `.body` --calls--> `TendancesView`  [INFERRED]
  UFrais/UFrais/ContentView.swift → UFrais/UFrais/Views/TendancesView.swift
- `.saveBlock` --calls--> `SavedCalculation`  [INFERRED]
  UFrais/UFrais/Views/CalculatorView.swift → UFrais/UFrais/Models/CalculatorEngine.swift

## Import Cycles
- None detected.

## Communities (22 total, 5 thin omitted)

### Community 0 - "String"
Cohesion: 0.09
Nodes (28): CodingKey, Decodable, Equatable, LocalizedError, SavedCalculation, Date, CodingKeys, brands (+20 more)

### Community 1 - "RayonKind"
Cohesion: 0.08
Nodes (34): CaseIterable, Codable, Hashable, Identifiable, RayonKind, boucherie, boulangerie, charcuterie (+26 more)

### Community 2 - ".display"
Cohesion: 0.13
Nodes (22): Font, CGFloat, UColor, UFont, View, .body, .body, .body (+14 more)

### Community 3 - "CalculatorView"
Cohesion: 0.14
Nodes (19): IndexSet, ObservableObject, HistoryStore, CalculatorView, .body, .breakdown, .fields, .header (+11 more)

### Community 4 - "MarginBreakdown"
Cohesion: 0.07
Nodes (30): Combine, Foundation, CalculatorEngine, MarginBreakdown, .coefficient, .grossMargin, .isLoss, .isValid (+22 more)

### Community 5 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 6 - "TrendFeedService"
Cohesion: 0.20
Nodes (9): Data, JSONDecoder, JSONEncoder, Date, TrendsPayload, Date, URL, TrendFeedService (+1 more)

### Community 7 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 8 - "Components.swift"
Cohesion: 0.12
Nodes (18): Content, DecimalField, KPIStat, LiveBadge, .body, MarqueGauge, RayonChip, .body (+10 more)

### Community 9 - "ConcurrentView"
Cohesion: 0.11
Nodes (24): CompetitorGap, .absDifference, .difference, .iAmMoreExpensive, .isAligned, .percentVsCompetitor, .verdict, Bool (+16 more)

### Community 10 - "AppTab"
Cohesion: 0.10
Nodes (17): App, Scene, SwiftUI, AppTab, calcul, concurrent, .id, .symbol (+9 more)

### Community 11 - "U Frais — Super U Ligné"
Cohesion: 0.22
Nodes (8): Calculateur, Charte, Concurrent (scan), Formules, Graphify, Ouvrir dans Xcode, Tendances (web), U Frais — Super U Ligné

### Community 12 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 13 - "Coordinator"
Cohesion: 0.20
Nodes (10): Context, DataScannerViewController, DataScannerViewControllerDelegate, NSObject, RecognizedItem, .body, Coordinator, DataScannerRepresentable (+2 more)

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
- **127 isolated node(s):** `calcul`, `concurrent`, `tendances`, `.id`, `.title` (+122 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `RayonKind`, `.display`, `CalculatorView`, `MarginBreakdown`, `TrendFeedService`, `Components.swift`, `ConcurrentView`, `AppTab`, `Coordinator`?**
  _High betweenness centrality (0.301) - this node is a cross-community bridge._
- **Why does `ConcurrentView` connect `ConcurrentView` to `String`, `AppTab`, `MarginBreakdown`?**
  _High betweenness centrality (0.070) - this node is a cross-community bridge._
- **Why does `TrendFeedService` connect `TrendFeedService` to `String`, `RayonKind`, `.display`, `CalculatorView`, `MarginBreakdown`, `AppTab`?**
  _High betweenness centrality (0.069) - this node is a cross-community bridge._
- **What connects `calcul`, `concurrent`, `tendances` to the rest of the system?**
  _127 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.09462365591397849 - nodes in this community are weakly interconnected._
- **Should `RayonKind` be split into smaller, more focused modules?**
  _Cohesion score 0.0761904761904762 - nodes in this community are weakly interconnected._
- **Should `.display` be split into smaller, more focused modules?**
  _Cohesion score 0.1330049261083744 - nodes in this community are weakly interconnected._