# Graph Report - workspace  (2026-08-20)

## Corpus Check
- 32 files · ~79,235 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 312 nodes · 603 edges · 12 communities
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 35 edges (avg confidence: 0.84)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- App Tabs Navigation
- SwiftUI Shell Theme
- VAT Calculator Engine
- Competitor Price Scan
- Graphify Skill Docs
- Barcode Camera Scanner
- Open Food Facts API
- UI Components
- Calculation History
- Web Trends Feed
- Margin Breakdown Math
- U Frais App Icon

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
- `Graphify setup` --semantically_similar_to--> `graphify`  [INFERRED] [semantically similar]
  README.md → .claude/skills/graphify/SKILL.md
- `graphify update after code changes` --semantically_similar_to--> `Incremental --update`  [INFERRED] [semantically similar]
  CLAUDE.md → .claude/skills/graphify/references/update.md
- `.product` --references--> `TrendFeedService`  [INFERRED]
  UFrais/UFrais/Views/TendancesView.swift → UFrais/UFrais/Services/TrendFeedService.swift
- `Consult graph before code exploration` --rationale_for--> `graphify query`  [INFERRED]
  CLAUDE.md → .claude/skills/graphify/SKILL.md
- `graphify claude install` --conceptually_related_to--> `Consult graph before code exploration`  [INFERRED]
  .claude/skills/graphify/references/hooks.md → CLAUDE.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **U Frais product tools** — readme_calculateur, readme_tendances, readme_scan_concurrent [EXTRACTED 1.00]
- **Graphify query toolkit** — claude_skills_graphify_skill_query, claude_skills_graphify_skill_path, claude_skills_graphify_skill_explain [EXTRACTED 1.00]
- **Keep graph current mechanisms** — claude_skills_graphify_skill_update, claude_skills_graphify_references_add_watch_watch, claude_skills_graphify_references_hooks_commit_hook [INFERRED 0.85]

## Communities (12 total, 0 thin omitted)

### Community 0 - "App Tabs Navigation"
Cohesion: 0.06
Nodes (41): CaseIterable, Codable, Hashable, Identifiable, AppTab, calcul, concurrent, .id (+33 more)

### Community 1 - "SwiftUI Shell Theme"
Cohesion: 0.08
Nodes (31): App, Font, Scene, SwiftUI, ContentView, .body, .customTabBar, CGFloat (+23 more)

### Community 2 - "VAT Calculator Engine"
Cohesion: 0.10
Nodes (29): CalculatorEngine, VATRate, alimentaire, .caption, .id, intermediaire, .label, normal (+21 more)

### Community 3 - "Competitor Price Scan"
Cohesion: 0.10
Nodes (27): Equatable, CompetitorGap, .absDifference, .difference, .iAmMoreExpensive, .isAligned, .percentVsCompetitor, .verdict (+19 more)

### Community 4 - "Graphify Skill Docs"
Cohesion: 0.07
Nodes (33): /graphify skill trigger, graphify update after code changes, Consult graph before code exploration, graphify add URL, graphify --watch, Extra exports (wiki, Neo4j, FalkorDB, MCP), Semantic extraction subagent, GitHub clone and cross-repo merge (+25 more)

### Community 5 - "Barcode Camera Scanner"
Cohesion: 0.16
Nodes (14): Context, DataScannerViewController, DataScannerViewControllerDelegate, NSObject, RecognizedItem, String, .nilIfEmpty, BarcodeScannerSheet (+6 more)

### Community 6 - "Open Food Facts API"
Cohesion: 0.11
Nodes (19): CodingKey, Decodable, LocalizedError, CodingKeys, brands, categories, imageFrontSmallURL, productName (+11 more)

### Community 7 - "UI Components"
Cohesion: 0.12
Nodes (18): Content, DecimalField, KPIStat, LiveBadge, .body, MarqueGauge, RayonChip, .body (+10 more)

### Community 8 - "Calculation History"
Cohesion: 0.17
Nodes (9): Combine, Foundation, IndexSet, ObservableObject, SavedCalculation, Date, HistoryStore, .historyBlock (+1 more)

### Community 9 - "Web Trends Feed"
Cohesion: 0.20
Nodes (9): Data, JSONDecoder, JSONEncoder, Date, TrendsPayload, Date, URL, TrendFeedService (+1 more)

### Community 10 - "Margin Breakdown Math"
Cohesion: 0.14
Nodes (14): MarginBreakdown, .coefficient, .grossMargin, .isLoss, .isValid, .marginRate, .marqueRate, .paTTC (+6 more)

### Community 11 - "U Frais App Icon"
Cohesion: 0.36
Nodes (8): UFrais iOS App Icon, UFrais brand identity, Red, white, and mint-green color palette, Fresh food or grocery app domain, Freshness / frais thematic symbolism, Mint-green leaf accent motif, White uppercase letter U monogram, Vibrant red radial-gradient background

## Knowledge Gaps
- **90 isolated node(s):** `calcul`, `concurrent`, `tendances`, `.id`, `.title` (+85 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `Barcode Camera Scanner` to `App Tabs Navigation`, `SwiftUI Shell Theme`, `VAT Calculator Engine`, `Competitor Price Scan`, `Open Food Facts API`, `UI Components`, `Calculation History`, `Web Trends Feed`?**
  _High betweenness centrality (0.366) - this node is a cross-community bridge._
- **Why does `ConcurrentView` connect `Competitor Price Scan` to `SwiftUI Shell Theme`, `Margin Breakdown Math`, `VAT Calculator Engine`, `Barcode Camera Scanner`?**
  _High betweenness centrality (0.085) - this node is a cross-community bridge._
- **Why does `TrendFeedService` connect `Web Trends Feed` to `Calculation History`, `App Tabs Navigation`, `Barcode Camera Scanner`, `SwiftUI Shell Theme`?**
  _High betweenness centrality (0.084) - this node is a cross-community bridge._
- **What connects `calcul`, `concurrent`, `tendances` to the rest of the system?**
  _90 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `App Tabs Navigation` be split into smaller, more focused modules?**
  _Cohesion score 0.06201550387596899 - nodes in this community are weakly interconnected._
- **Should `SwiftUI Shell Theme` be split into smaller, more focused modules?**
  _Cohesion score 0.08478513356562137 - nodes in this community are weakly interconnected._
- **Should `VAT Calculator Engine` be split into smaller, more focused modules?**
  _Cohesion score 0.1036036036036036 - nodes in this community are weakly interconnected._