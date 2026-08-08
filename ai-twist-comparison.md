# AI Twist — Comparison Notes

Per the activity: queries and ERD were built by hand first (see `sql/products.sql`
and `erd/repair-shop-erd.mmd`). This document covers the second half — generating
each artifact fresh from a plain-English prompt only, then diffing against the
hand-built version.

## Part 1 — SQL queries, AI-generated vs hand-written

Prompts used (no SQL shown to the generator, description only):

1. *"Show me products that cost more than $20, cheapest first, with product name, category, and price."*
2. *"Group products by category and show how many products, total stock, and average price per category, sorted by total stock descending."*
3. *"Join products with their suppliers and show product name, category, price, and supplier name, sorted by supplier then product name."*

| Query | Row count (hand-written) | Row count (AI-generated) | Match? |
|---|---|---|---|
| SELECT | 4 | 4 | ✅ |
| GROUP BY | 4 | 4 | ✅ |
| JOIN | 5 | 5 | ✅ |

**Row counts all matched.** But one real difference showed up on closer inspection:

- **GROUP BY — `avg_price` for the Screen category:** hand-written query used
  `ROUND(AVG(price), 2)` → **67.59**. The AI-generated query used plain `AVG(price)`
  with no rounding → **67.595**. Same underlying calculation, different precision —
  this is a subtle bug in a real report (a client-facing dashboard showing
  "$67.595" instead of "$67.59" looks broken). **Verdict: AI version needs a fix,
  not a full rewrite.**
- SELECT and JOIN queries were functionally identical to the hand-written
  versions (different variable naming style — `products.product_name` vs
  `p.product_name` — but same logic, same output).

## Part 2 — ERD, AI-generated vs hand-built

Prompt used: *"Create an ER diagram for an online repair shop: Customer, Device,
RepairTicket, Technician, Part. A customer owns devices, a device has repair
tickets, a technician handles repair tickets, and a repair ticket uses parts."*

See `erd/repair-shop-erd-ai-generated.mmd` / `.png` for the raw output.

**Verified by hand, entity by entity:**

| Check | Hand-built | AI-generated | Issue? |
|---|---|---|---|
| Customer → Device | 1 : 0..N | 1 : 0..N | Same, correct |
| Device → RepairTicket | 1 : 0..N | 1 : 0..N | Same, correct |
| Technician → RepairTicket | 1 : 0..N | 1 : 0..N | Same, correct |
| RepairTicket ↔ Part | M : N via `TICKET_PART` junction table | **1 : 0..N direct** (`Part.ticket_id FK`) | **Wrong** |

**The AI version got the Part relationship wrong.** It modeled `Part` as
belonging to exactly one `RepairTicket` (a `ticket_id` foreign key directly on
`Part`), which means the same part type (e.g. "iPhone 13 Screen") couldn't be
reused across multiple tickets — every repair would need its own duplicate
`Part` row, and stock/pricing for "the same part" would be scattered across
many records instead of tracked once. This is the exact miss flagged as a risk
in `erd/repair-shop-erd-notes.md` before this comparison was even run: *AI
tools sometimes model the ticket–part relationship as a direct one-to-many and
skip the junction table entirely.*

**Fix:** reject the AI version's `Part` table as-is; keep the hand-built
`TICKET_PART` junction table (composite key `ticket_id` + `part_id`) from
`erd/repair-shop-erd.mmd`.

## Takeaway

- Row-count diffing alone would have passed the AI's ERD-adjacent query logic,
  but wouldn't have caught either issue here — the rounding difference and the
  missing junction table are both **structural/precision** issues, not
  **row-count** issues. Worth checking output *values*, not just row counts,
  and worth checking *relationship types* on a generated ERD by hand rather
  than trusting it renders cleanly.
