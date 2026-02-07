-- Yarn Marketplace MVP schema (Supabase/Postgres)

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  avatar_url text,
  created_at timestamptz default now()
);

create table if not exists yarn_catalog (
  id uuid primary key default gen_random_uuid(),
  brand text not null,
  name text not null,
  weight_class text, -- e.g. lace, fingering, dk, worsted
  grams_per_skein int,
  yards_per_skein int,
  fiber text,
  created_at timestamptz default now(),
  unique (brand, name)
);

create table if not exists listings (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid references profiles(id) on delete set null,
  title text not null,
  description text,
  condition text, -- new, like_new, good, used
  total_price_cents int not null,
  is_bundle boolean default false,
  total_weight_grams int,
  status text default 'active', -- active, sold, hidden
  created_at timestamptz default now()
);

create table if not exists listing_items (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid references listings(id) on delete cascade,
  yarn_id uuid references yarn_catalog(id) on delete set null,
  custom_yarn_name text,
  qty_skeins int not null,
  grams_total int,
  created_at timestamptz default now()
);

create table if not exists listing_images (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid references listings(id) on delete cascade,
  image_url text not null,
  sort_order int default 0,
  created_at timestamptz default now()
);

create table if not exists offers (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid references listings(id) on delete cascade,
  buyer_id uuid references profiles(id) on delete set null,
  offer_price_cents int not null,
  message text,
  status text default 'pending', -- pending, accepted, declined, withdrawn
  created_at timestamptz default now()
);
