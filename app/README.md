# app/

Sample document-processing application. **Node.js + Express + PostgreSQL.**

## Domain

Modeled on eDiscovery workflows: accepts document uploads, stores them in S3, persists metadata (filename, size, hash, upload time) to PostgreSQL, and exposes a simple search/list API.

**Why this matters:** Demonstrates the same architectural pattern as commercial eDiscovery platforms (Relativity, NUIX, Venio) at a small scale — object storage + relational metadata + a thin API — but built entirely on self-hosted open-source primitives.

## Status

Lands in Phase 3 — see [the roadmap](../README.md#roadmap).

## Planned Layout

```
app/
├── src/
│   ├── index.js          Express entrypoint
│   ├── routes/           Upload, list, get endpoints
│   ├── lib/db.js         PostgreSQL client
│   └── lib/storage.js    S3 client (IRSA-authenticated)
├── package.json
├── Dockerfile            Multi-stage; distroless final image
└── .dockerignore
```
