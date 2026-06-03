-- Lleva Lleva Database Schema
-- Run this in Supabase SQL Editor after creating your project.
-- Replayable: every statement is idempotent (if not exists / drop-then-create / on conflict).

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ============================================================================
-- Tables
-- ============================================================================

-- Profiles table (extends auth.users)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  phone text,
  whatsapp_number text,
  city text default 'Santa Marta',
  avatar_url text,
  is_verified boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Categories taxonomy (referenced by listings.category_id)
create table if not exists public.categories (
  id uuid default uuid_generate_v4() primary key,
  parent_id uuid references public.categories(id) on delete set null,
  slug text unique not null,
  slug_path text not null,
  name_es text not null,
  name_en text,
  sort_order int default 0,
  is_active boolean default true,
  created_at timestamptz default now()
);

-- Locations taxonomy (referenced by listings.location_id)
create table if not exists public.locations (
  id uuid default uuid_generate_v4() primary key,
  parent_id uuid references public.locations(id) on delete set null,
  slug text unique not null,
  city text not null,
  department text,
  country text default 'CO' not null,
  is_nationwide boolean default false not null,
  sort_order int default 0,
  is_active boolean default true,
  created_at timestamptz default now()
);

-- Listings table
create table if not exists public.listings (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  title text not null,
  description text not null,
  price numeric default 0,
  category text,
  city text default 'Santa Marta',
  whatsapp_number text,
  images text[] default '{}',
  status text default 'active',
  is_bumped boolean default false,
  is_highlighted boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Reports table
create table if not exists public.reports (
  id uuid default uuid_generate_v4() primary key,
  listing_id uuid references public.listings(id) on delete cascade not null,
  reporter_id uuid references public.profiles(id) on delete cascade not null,
  reason text not null check (reason in ('scam', 'inappropriate', 'spam', 'other')),
  description text,
  status text default 'pending' check (status in ('pending', 'reviewed', 'resolved')),
  created_at timestamptz default now()
);

-- Favorites table
create table if not exists public.favorites (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  listing_id uuid references public.listings(id) on delete cascade not null,
  created_at timestamptz default now(),
  unique(user_id, listing_id)
);

-- ============================================================================
-- Schema evolution
-- Profiles and listings have grown beyond their original shape. These ALTERs
-- bring an existing DB in line with what the frontend (src/lib/listing-data.ts
-- LISTING_SELECT, src/components/listings/ListingForm.tsx, src/lib/types.ts)
-- actually reads and writes. All statements are idempotent.
-- ============================================================================

-- profiles: add columns the frontend reads from LISTING_SELECT.profiles join
alter table public.profiles add column if not exists username text unique;
alter table public.profiles add column if not exists display_name text;
alter table public.profiles add column if not exists user_type text default 'regular';
alter table public.profiles add column if not exists bio text;
alter table public.profiles add column if not exists department text;
alter table public.profiles add column if not exists rating_avg numeric default 0 not null;
alter table public.profiles add column if not exists rating_count int default 0 not null;

-- Enforce allowed user_type values
alter table public.profiles drop constraint if exists profiles_user_type_check;
alter table public.profiles
  add constraint profiles_user_type_check
  check (user_type in ('regular', 'business', 'bot'));

-- listings: rename user_id -> seller_id to match frontend (LISTING_SELECT,
-- ListingForm insert, profile queries .eq("seller_id", ...)).
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'listings' and column_name = 'user_id'
  ) and not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'listings' and column_name = 'seller_id'
  ) then
    alter table public.listings rename column user_id to seller_id;
  end if;
end $$;

-- listings: rename the FK constraint too. PostgREST embeds in LISTING_SELECT
-- use `profiles:profiles!listings_seller_id_fkey` and resolve by exact name,
-- so the constraint must match the column.
do $$
begin
  if exists (
    select 1 from information_schema.table_constraints
    where table_schema = 'public' and table_name = 'listings'
      and constraint_name = 'listings_user_id_fkey'
  ) and not exists (
    select 1 from information_schema.table_constraints
    where table_schema = 'public' and table_name = 'listings'
      and constraint_name = 'listings_seller_id_fkey'
  ) then
    alter table public.listings rename constraint listings_user_id_fkey to listings_seller_id_fkey;
  end if;
end $$;

-- listings: add new columns the frontend reads/writes
alter table public.listings add column if not exists category_id uuid references public.categories(id) on delete set null;
alter table public.listings add column if not exists location_id uuid references public.locations(id) on delete set null;
alter table public.listings add column if not exists is_nationwide boolean default false not null;
alter table public.listings add column if not exists slug text;
alter table public.listings add column if not exists price_type text default 'fixed';
alter table public.listings add column if not exists currency text default 'COP' not null;
alter table public.listings add column if not exists condition text;
alter table public.listings add column if not exists attributes jsonb default '{}'::jsonb not null;
alter table public.listings add column if not exists tags text[] default '{}'::text[] not null;
alter table public.listings add column if not exists view_count int default 0 not null;
alter table public.listings add column if not exists message_count int default 0 not null;
alter table public.listings add column if not exists favorite_count int default 0 not null;
alter table public.listings add column if not exists published_at timestamptz;

-- listings.slug must be unique
create unique index if not exists listings_slug_key on public.listings(slug);

-- Allow new price_type / status values used by the frontend type unions and
-- relax checks that the new flow no longer satisfies. Drop legacy NOT NULL on
-- columns whose data now lives on related tables.
alter table public.listings drop constraint if exists listings_price_type_check;
alter table public.listings
  add constraint listings_price_type_check
  check (price_type in ('fixed', 'negotiable', 'free', 'contact'));

alter table public.listings drop constraint if exists listings_status_check;
alter table public.listings
  add constraint listings_status_check
  check (status in ('draft', 'active', 'paused', 'sold', 'expired', 'removed', 'flagged'));

alter table public.listings drop constraint if exists listings_category_check;
alter table public.listings alter column category drop not null;
alter table public.listings alter column city drop not null;
alter table public.listings alter column whatsapp_number drop not null;

-- listings.images: legacy text[] -> jsonb. The frontend writes objects
-- ({url, alt, order}); mapListing already reads both shapes.
do $$
begin
  if (
    select data_type from information_schema.columns
    where table_schema = 'public' and table_name = 'listings' and column_name = 'images'
  ) = 'ARRAY' then
    alter table public.listings alter column images drop default;
    alter table public.listings alter column images type jsonb using to_jsonb(images);
    alter table public.listings alter column images set default '[]'::jsonb;
    alter table public.listings alter column images set not null;
  end if;
end $$;

-- ============================================================================
-- Indexes
-- ============================================================================

-- Full-text search index on listings (generated column + GIN)
do $$
begin
  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'listings' and column_name = 'fts'
  ) then
    alter table public.listings add column fts tsvector
      generated always as (
        setweight(to_tsvector('spanish', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('spanish', coalesce(description, '')), 'B')
      ) stored;
  end if;
end $$;

create index if not exists listings_fts_idx on public.listings using gin(fts);
create index if not exists listings_category_idx on public.listings(category);
create index if not exists listings_category_id_idx on public.listings(category_id);
create index if not exists listings_location_id_idx on public.listings(location_id);
create index if not exists listings_city_idx on public.listings(city);
create index if not exists listings_status_idx on public.listings(status);
create index if not exists listings_published_at_idx on public.listings(published_at desc);
create index if not exists listings_created_at_idx on public.listings(created_at desc);

-- After rename, the old index name (listings_user_id_idx) still references the
-- new column under its old name. Create the seller_id index idempotently and
-- drop the legacy one.
create index if not exists listings_seller_id_idx on public.listings(seller_id);
drop index if exists public.listings_user_id_idx;

create index if not exists categories_slug_idx on public.categories(slug);
create index if not exists categories_parent_id_idx on public.categories(parent_id);
create index if not exists categories_slug_path_idx on public.categories(slug_path);

create index if not exists locations_slug_idx on public.locations(slug);
create index if not exists locations_parent_id_idx on public.locations(parent_id);
create index if not exists locations_country_idx on public.locations(country);

-- ============================================================================
-- Triggers
-- ============================================================================

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, phone, whatsapp_number)
  values (new.id, new.phone, new.phone)
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Auto-update updated_at
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists on_profile_updated on public.profiles;
create trigger on_profile_updated
  before update on public.profiles
  for each row execute function public.handle_updated_at();

drop trigger if exists on_listing_updated on public.listings;
create trigger on_listing_updated
  before update on public.listings
  for each row execute function public.handle_updated_at();

-- ============================================================================
-- Row Level Security
-- ============================================================================

alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.locations enable row level security;
alter table public.listings enable row level security;
alter table public.reports enable row level security;
alter table public.favorites enable row level security;

-- Profiles policies
drop policy if exists "Public profiles are viewable by everyone" on public.profiles;
create policy "Public profiles are viewable by everyone"
  on public.profiles for select using (true);

drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

-- Categories policies (read-only to clients; writes go through service role)
drop policy if exists "Categories are publicly readable" on public.categories;
create policy "Categories are publicly readable"
  on public.categories for select using (true);

-- Locations policies (read-only to clients; writes go through service role)
drop policy if exists "Locations are publicly readable" on public.locations;
create policy "Locations are publicly readable"
  on public.locations for select using (true);

-- Listings policies (keyed on seller_id, not legacy user_id)
drop policy if exists "Active listings are viewable by everyone" on public.listings;
create policy "Active listings are viewable by everyone"
  on public.listings for select using (status = 'active' or seller_id = auth.uid());

drop policy if exists "Authenticated users can create listings" on public.listings;
create policy "Authenticated users can create listings"
  on public.listings for insert with check (auth.uid() = seller_id);

drop policy if exists "Users can update own listings" on public.listings;
create policy "Users can update own listings"
  on public.listings for update using (auth.uid() = seller_id);

drop policy if exists "Users can delete own listings" on public.listings;
create policy "Users can delete own listings"
  on public.listings for delete using (auth.uid() = seller_id);

-- Reports policies
drop policy if exists "Authenticated users can create reports" on public.reports;
create policy "Authenticated users can create reports"
  on public.reports for insert with check (auth.uid() = reporter_id);

drop policy if exists "Users can view own reports" on public.reports;
create policy "Users can view own reports"
  on public.reports for select using (auth.uid() = reporter_id);

-- Favorites policies
drop policy if exists "Users can manage own favorites" on public.favorites;
create policy "Users can manage own favorites"
  on public.favorites for all using (auth.uid() = user_id);

-- ============================================================================
-- Storage
-- ============================================================================

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'listing-images',
  'listing-images',
  true,
  5242880, -- 5MB
  array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
on conflict (id) do nothing;

-- Read: keep public (listings are public).
drop policy if exists "Anyone can view listing images" on storage.objects;
create policy "Anyone can view listing images"
  on storage.objects for select
  using (bucket_id = 'listing-images');

-- Write: restrict each authenticated user to their own auth.uid() folder.
-- (Previously any authenticated user could write anywhere in the bucket.)
drop policy if exists "Authenticated users can upload listing images" on storage.objects;
create policy "Authenticated users can upload listing images"
  on storage.objects for insert
  with check (
    bucket_id = 'listing-images'
    and auth.role() = 'authenticated'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

drop policy if exists "Users can update own listing images" on storage.objects;
create policy "Users can update own listing images"
  on storage.objects for update
  using (
    bucket_id = 'listing-images'
    and auth.uid()::text = (storage.foldername(name))[1]
  )
  with check (
    bucket_id = 'listing-images'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

drop policy if exists "Users can delete own listing images" on storage.objects;
create policy "Users can delete own listing images"
  on storage.objects for delete
  using (
    bucket_id = 'listing-images'
    and auth.uid()::text = (storage.foldername(name))[1]
  );
