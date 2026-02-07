# Implementation Plan (MVP)

## Phase 0 — Planning (done/ongoing)
- Define MVP scope
- Confirm stack (Supabase + Next.js)
- Document schema + API contract

## Phase 1 — Backend scaffold
- Create Supabase project
- Apply `schema.sql`, `rls.sql`, `seed.sql`
- Create storage bucket `listing-images`

## Phase 2 — Frontend MVP
- Auth (email login)
- Listing feed + listing detail
- Create listing + upload images
- Add listing items (bundle builder)

## Phase 3 — Offers + basic messaging
- Offer creation + status updates
- Seller dashboard (view offers, edit listings)

## Phase 4 — Search + filters
- Keyword + brand + weight filters
- Sort by price/newest

## Phase 5 — Shipping estimate (heuristic)
- Calculate total weight from items
- Map weight to shipping ranges

## Tech stack
- Frontend: Next.js (App Router)
- Backend: Supabase (Postgres/Auth/Storage)
- Deployment: Vercel + Supabase

## Milestones
- **M1**: Listings live with mock data
- **M2**: Auth + create listing
- **M3**: Offers + seller dashboard
