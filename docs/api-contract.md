# Yarn Marketplace API Contract (MVP)

This is a **Supabase‑ready** contract using PostgREST + SQL. It defines tables, expected queries, and common access patterns for the MVP.

> Assumes `schema.sql` and `rls.sql` already applied.

---

## Entities

### Profile
- `id` (uuid, auth user id)
- `display_name`
- `avatar_url`
- `created_at`

### Yarn Catalog
- `id`
- `brand`
- `name`
- `weight_class` (lace, fingering, dk, worsted, bulky…)
- `grams_per_skein`
- `yards_per_skein`
- `fiber`

### Listing
- `id`
- `seller_id`
- `title`
- `description`
- `condition` (new, like_new, good, used)
- `total_price_cents`
- `is_bundle`
- `total_weight_grams`
- `status` (active, sold, hidden)
- `created_at`

### Listing Item
- `id`
- `listing_id`
- `yarn_id` (nullable)
- `custom_yarn_name` (if not in catalog)
- `qty_skeins`
- `grams_total`

### Listing Image
- `id`
- `listing_id`
- `image_url`
- `sort_order`

### Offer
- `id`
- `listing_id`
- `buyer_id`
- `offer_price_cents`
- `message`
- `status` (pending, accepted, declined, withdrawn)
- `created_at`

---

## PostgREST Query Patterns (Supabase)

### Fetch listings (feed)
```http
GET /rest/v1/listings?status=eq.active&select=*,listing_images(*),listing_items(*,yarn_catalog(*))
```

### Search listings (simple)
```http
GET /rest/v1/listings?or=(title.ilike.*malabrigo*,description.ilike.*malabrigo*)&status=eq.active
```

### Filter by weight class
```http
GET /rest/v1/listings?status=eq.active&select=*,listing_items(*,yarn_catalog(*))&listing_items.yarn_catalog.weight_class=eq.worsted
```

### Create listing
```http
POST /rest/v1/listings
{ "seller_id": "<auth.uid>", "title": "Malabrigo Rios Bundle", "total_price_cents": 9600, "is_bundle": true }
```

### Add listing items
```http
POST /rest/v1/listing_items
{ "listing_id": "<listing_id>", "yarn_id": "<yarn_id>", "qty_skeins": 8, "grams_total": 800 }
```

### Add listing images
```http
POST /rest/v1/listing_images
{ "listing_id": "<listing_id>", "image_url": "https://...", "sort_order": 0 }
```

### Make an offer
```http
POST /rest/v1/offers
{ "listing_id": "<listing_id>", "buyer_id": "<auth.uid>", "offer_price_cents": 9000, "message": "Can you do $90 shipped?" }
```

---

## API Contracts (Frontend)

### Listing Card
```ts
interface ListingCard {
  id: string
  title: string
  total_price_cents: number
  is_bundle: boolean
  condition?: string
  created_at: string
  images: { image_url: string }[]
  items: {
    qty_skeins: number
    grams_total?: number
    yarn?: { brand: string; name: string; weight_class?: string }
    custom_yarn_name?: string
  }[]
}
```

### Listing Details
```ts
interface ListingDetails extends ListingCard {
  description?: string
  seller: { id: string; display_name?: string; avatar_url?: string }
}
```

### Offer
```ts
interface Offer {
  id: string
  listing_id: string
  buyer_id: string
  offer_price_cents: number
  message?: string
  status: 'pending' | 'accepted' | 'declined' | 'withdrawn'
  created_at: string
}
```

---

## Supabase Integration Notes

1. **Auth**
   - Use Supabase Auth email or OAuth.
   - `profiles` table is keyed to `auth.users.id`.

2. **Storage**
   - Use bucket `listing-images` and save public URLs into `listing_images.image_url`.

3. **Security**
   - RLS policies already restrict updates to owners.

4. **Search**
   - MVP uses `ilike` filters.
   - Scale path: add tsvector + GIN or external search (Meilisearch).

---

## Roadmap Extensions
- `messages` table (buyer/seller threads)
- `shipping_quotes` table
- `transactions` table (Stripe Connect)
- `reviews` table
