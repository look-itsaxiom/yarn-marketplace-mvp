-- Basic RLS starter (adjust as needed)

alter table profiles enable row level security;
create policy "Profiles are viewable by everyone" on profiles
  for select using (true);
create policy "Users can update own profile" on profiles
  for update using (auth.uid() = id);

alter table listings enable row level security;
create policy "Listings are viewable by everyone" on listings
  for select using (status = 'active');
create policy "Sellers can insert own listings" on listings
  for insert with check (auth.uid() = seller_id);
create policy "Sellers can update own listings" on listings
  for update using (auth.uid() = seller_id);

alter table listing_items enable row level security;
create policy "Listing items readable" on listing_items
  for select using (true);
create policy "Sellers manage listing items" on listing_items
  for all using (
    exists (select 1 from listings l where l.id = listing_items.listing_id and l.seller_id = auth.uid())
  );

alter table listing_images enable row level security;
create policy "Listing images readable" on listing_images
  for select using (true);
create policy "Sellers manage listing images" on listing_images
  for all using (
    exists (select 1 from listings l where l.id = listing_images.listing_id and l.seller_id = auth.uid())
  );

alter table offers enable row level security;
create policy "Buyers can read own offers" on offers
  for select using (auth.uid() = buyer_id);
create policy "Buyers can create offers" on offers
  for insert with check (auth.uid() = buyer_id);
create policy "Sellers can read offers on their listings" on offers
  for select using (
    exists (select 1 from listings l where l.id = offers.listing_id and l.seller_id = auth.uid())
  );
