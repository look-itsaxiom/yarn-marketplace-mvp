# Yarn Marketplace Data Model (MVP)

## Core relationships

```
profiles (1) ── (∞) listings
listings (1) ── (∞) listing_items
listings (1) ── (∞) listing_images
listings (1) ── (∞) offers
listing_items (∞) ── (1) yarn_catalog (optional)
```

## Table definitions (summary)

### profiles
- **id**: uuid (auth.users.id)
- display_name
- avatar_url
- created_at

### yarn_catalog
- **id**: uuid
- brand
- name
- weight_class
- grams_per_skein
- yards_per_skein
- fiber

### listings
- **id**: uuid
- seller_id (profiles.id)
- title
- description
- condition
- total_price_cents
- is_bundle
- total_weight_grams
- status
- created_at

### listing_items
- **id**: uuid
- listing_id
- yarn_id (nullable)
- custom_yarn_name (nullable)
- qty_skeins
- grams_total

### listing_images
- **id**: uuid
- listing_id
- image_url
- sort_order

### offers
- **id**: uuid
- listing_id
- buyer_id
- offer_price_cents
- message
- status
- created_at

## Suggested indexes (later)
- listings(status, created_at)
- listings(total_price_cents)
- yarn_catalog(brand, name)
- listing_items(listing_id)
- offers(listing_id, status)

## Notes
- `yarn_id` is optional so sellers can still list custom yarns.
- Bundles are indicated by `is_bundle` plus multiple `listing_items`.
