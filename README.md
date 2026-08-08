# Online Repair Shop — BA Assignment

BA deliverables for the "FixIt — Online Electronics Repair Shop" activity
(Checkmate IT Training Institute, Session 10 — Database, SQL, ERD).

## What's here

```
online-repair-shop/
├── README.md
├── erd/
│   ├── repair-shop-erd.mmd          Mermaid source (renders natively on GitHub)
│   ├── repair-shop-erd.png          Rendered ERD, crow's-foot notation
│   └── repair-shop-erd-notes.md     Keys, cardinality, and reasoning behind each relationship
└── sql/
    ├── products.sql                 Schema + sample data + SELECT/GROUP BY/JOIN queries
    └── products-queries.md          Each query with its actual result set, plus an AI-twist checklist
```

## Entities (ERD)

Customer → Device → RepairTicket → Technician / Part, with a `TicketPart`
junction table resolving the many-to-many between RepairTicket and Part.

## Tools used

- **ERD:** Mermaid (`erDiagram` syntax) — edit at [mermaid.live](https://mermaid.live) or view directly in this repo
- **SQL:** SQLite-compatible syntax, tested and verified before committing (see `products-queries.md` for real output, not just written queries)

## Status

- [x] ERD (Customer → Device → RepairTicket → Technician / Part)
- [x] Products table, 5 rows, SELECT / GROUP BY / JOIN queries
- [ ] AI-twist comparison (generate the same ERD + queries with AI, diff against the above) — to be done and added
