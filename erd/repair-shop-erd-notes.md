# Online Repair Shop — Entity Relationship Diagram

**Scenario:** FixIt — Online Electronics Repair Shop (phones, laptops, tablets, smartwatches)
**Notation:** Crow's-foot
**Source:** `repair-shop-erd.mmd` (Mermaid) — paste into [mermaid.live](https://mermaid.live)
or view directly on GitHub, which renders `.mmd`/Mermaid code blocks natively.

## Entities, keys, and cardinality (verified by hand)

| Relationship | Cardinality | Read as |
|---|---|---|
| CUSTOMER → DEVICE | 1 : 0..N | One customer owns zero or more devices. A device belongs to exactly one customer. |
| DEVICE → REPAIR_TICKET | 1 : 0..N | One device can have zero or more repair tickets over its lifetime. A ticket belongs to exactly one device. |
| TECHNICIAN → REPAIR_TICKET | 1 : 0..N | One technician handles zero or more tickets. A ticket is assigned to exactly one technician. |
| REPAIR_TICKET ↔ PART | M : N (via TICKET_PART) | One ticket can use many parts; one part type can be used across many tickets. Resolved with a junction table since a plain ERD can't express many-to-many directly. |

## Keys

- **Primary keys (PK):** `customer_id`, `device_id`, `technician_id`, `ticket_id`, `part_id` — each single-column, auto-generated identifiers.
- **Foreign keys (FK):** `DEVICE.customer_id` → `CUSTOMER.customer_id`; `REPAIR_TICKET.device_id` → `DEVICE.device_id`; `REPAIR_TICKET.technician_id` → `TECHNICIAN.technician_id`; `TICKET_PART.ticket_id` → `REPAIR_TICKET.ticket_id`; `TICKET_PART.part_id` → `PART.part_id`.
- **Composite key:** `TICKET_PART` has a composite primary key of (`ticket_id`, `part_id`) — together they uniquely identify "this many of this part were used on this ticket."

## Why the junction table

A `RepairTicket` often needs more than one `Part` (e.g. a phone screen repair might need both a new screen and new adhesive). And the same `Part` (e.g. "iPhone 13 battery") gets used across many different tickets. That's a many-to-many relationship, which crow's-foot notation — and relational databases generally — can't represent as a direct line between two tables. `TICKET_PART` resolves it: each row says "ticket X used N units of part Y."

## Not modeled (kept out of scope)

- Payment/invoicing — would be a natural extension (`REPAIR_TICKET` → `INVOICE`) but wasn't part of the assigned entity list.
- Technician availability/scheduling — out of scope for this ERD.
