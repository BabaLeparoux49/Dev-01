#!/usr/bin/env python3
"""Met à jour trends.json pour le jour civil (Europe/Paris).

- Bumpe updatedAt + headline datée
- Injecte 1–2 titres presse (RSS) dans sourceNote
- Applique une légère variation journalière des buzzScore (classement du jour)
"""

from __future__ import annotations

import hashlib
import json
import re
import urllib.request
from datetime import datetime, timezone
from pathlib import Path
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]
TRENDS_PATH = ROOT / "UFrais" / "UFrais" / "Data" / "trends.json"
PARIS = ZoneInfo("Europe/Paris")
USER_AGENT = "UFrais-DailyTrends/1.0 (+https://github.com/BabaLeparoux49/Dev-01)"

RSS_FEEDS = [
    "https://www.lineaires.com/rss.xml",
    "https://www.lsa-conso.fr/rss",
]
KEYWORDS = (
    "frais",
    "fruit",
    "légume",
    "legume",
    "boucher",
    "poisson",
    "fromage",
    "traiteur",
    "viral",
    "tiktok",
    "tendance",
    "crème",
    "creme",
    "yaourt",
)


def fetch_text(url: str, timeout: int = 20) -> str | None:
    try:
        req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
        with urllib.request.urlopen(req, timeout=timeout) as response:
            return response.read().decode("utf-8", errors="replace")
    except Exception as exc:  # noqa: BLE001 — best-effort daily job
        print(f"RSS skip {url}: {exc}")
        return None


def extract_rss_titles(xml: str) -> list[str]:
    titles: list[str] = []
    for match in re.finditer(r"<title>(.*?)</title>", xml, flags=re.IGNORECASE | re.DOTALL):
        raw = match.group(1)
        raw = raw.replace("<![CDATA[", "").replace("]]>", "")
        raw = re.sub(r"<[^>]+>", "", raw).strip()
        if raw:
            titles.append(raw)
    return titles[1:]  # skip channel title


def press_hits(limit: int = 2) -> list[str]:
    collected: list[str] = []
    for feed in RSS_FEEDS:
        xml = fetch_text(feed)
        if not xml:
            continue
        for title in extract_rss_titles(xml):
            lower = title.lower()
            if any(k in lower for k in KEYWORDS):
                if title not in collected:
                    collected.append(title)
            if len(collected) >= limit:
                return collected
    return collected[:limit]


def day_seed(day_key: str) -> int:
    digest = hashlib.sha256(day_key.encode("utf-8")).hexdigest()
    return int(digest[:8], 16)


def nudge_buzz(items: list[dict], day_key: str) -> None:
    """Petite variation journalière (±3) pour faire bouger le classement."""
    seed = day_seed(day_key)
    for index, item in enumerate(items):
        base = int(item.get("buzzScore") or 70)
        delta = ((seed >> (index % 16)) & 7) - 3  # -3…+3
        item["buzzScore"] = max(55, min(99, base + delta))


def main() -> None:
    now_paris = datetime.now(PARIS)
    day_key = now_paris.strftime("%Y-%m-%d")
    french_date = now_paris.strftime("%d/%m/%Y")

    payload = json.loads(TRENDS_PATH.read_text(encoding="utf-8"))
    items = payload.get("items") or []
    nudge_buzz(items, day_key)

    hits = press_hits()
    base_note = (
        "Signaux web, réseaux sociaux, presse food et sorties marques nationales "
        "— pas les ventes magasin. Actualisation quotidienne."
    )
    if hits:
        base_note += " Signaux presse du jour : " + " · ".join(hits) + "."

    payload["updatedAt"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    payload["headline"] = f"Ce qui cartonne aujourd'hui en frais · {french_date}"
    payload["sourceNote"] = base_note
    payload["items"] = items

    TRENDS_PATH.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Updated {TRENDS_PATH} for {day_key} ({len(items)} items, press={len(hits)})")


if __name__ == "__main__":
    main()
