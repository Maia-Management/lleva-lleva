-- Lleva Lleva Database Schema
-- Run this in Supabase SQL Editor after creating your project

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Profiles table (extends auth.users)
create table public.profiles (
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

-- Listings table
create table public.listings (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  title text not null,
  description text not null,
  price numeric default 0,
  category text not null check (category in ('buy_sell', 'jobs', 'housing', 'services', 'vehicles', 'events', 'community')),
  city text not null default 'Santa Marta',
  whatsapp_number text not null,
  images text[] default '{}',
  status text default 'active' check (status in ('active', 'sold', 'expired', 'flagged')),
  is_bumped boolean default false,
  is_highlighted boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Reports table
create table public.reports (
  id uuid default uuid_generate_v4() primary key,
  listing_id uuid references public.listings(id) on delete cascade not null,
  reporter_id uuid references public.profiles(id) on delete cascade not null,
  reason text not null check (reason in ('scam', 'inappropriate', 'spam', 'other')),
  description text,
  status text default 'pending' check (status in ('pending', 'reviewed', 'resolved')),
  created_at timestamptz default now()
);

-- Favorites table
create table public.favorites (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  listing_id uuid references public.listings(id) on delete cascade not null,
  created_at timestamptz default now(),
  unique(user_id, listing_id)
);

-- Full-text search index on listings
alter table public.listings add column fts tsvector
  generated always as (
    setweight(to_tsvector('spanish', coalesce(title, '')), 'A') ||
    setweight(to_tsvector('spanish', coalesce(description, '')), 'B')
  ) stored;

create index listings_fts_idx on public.listings using gin(fts);
create index listings_category_idx on public.listings(category);
create index listings_city_idx on public.listings(city);
create index listings_status_idx on public.listings(status);
create index listings_created_at_idx on public.listings(created_at desc);
create index listings_user_id_idx on public.listings(user_id);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, phone, whatsapp_number)
  values (new.id, new.phone, new.phone);
  return new;
end;
$$ language plpgsql security definer;

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

create trigger on_profile_updated
  before update on public.profiles
  for each row execute function public.handle_updated_at();

create trigger on_listing_updated
  before update on public.listings
  for each row execute function public.handle_updated_at();

-- Row Level Security
alter table public.profiles enable row level security;
alter table public.listings enable row level security;
alter table public.reports enable row level security;
alter table public.favorites enable row level security;

-- Profiles policies
create policy "Public profiles are viewable by everyone"
  on public.profiles for select using (true);

create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

-- Listings policies
create policy "Active listings are viewable by everyone"
  on public.listings for select using (status = 'active' or user_id = auth.uid());

create policy "Authenticated users can create listings"
  on public.listings for insert with check (auth.uid() = user_id);

create policy "Users can update own listings"
  on public.listings for update using (auth.uid() = user_id);

create policy "Users can delete own listings"
  on public.listings for delete using (auth.uid() = user_id);

-- Reports policies
create policy "Authenticated users can create reports"
  on public.reports for insert with check (auth.uid() = reporter_id);

create policy "Users can view own reports"
  on public.reports for select using (auth.uid() = reporter_id);

-- Favorites policies
create policy "Users can manage own favorites"
  on public.favorites for all using (auth.uid() = user_id);

-- Storage bucket for listing images
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'listing-images',
  'listing-images',
  true,
  5242880, -- 5MB
  array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
);

-- Storage policies
create policy "Anyone can view listing images"
  on storage.objects for select
  using (bucket_id = 'listing-images');

create policy "Authenticated users can upload listing images"
  on storage.objects for insert
  with check (bucket_id = 'listing-images' and auth.role() = 'authenticated');

create policy "Users can delete own listing images"
  on storage.objects for delete
  using (bucket_id = 'listing-images' and auth.uid()::text = (storage.foldername(name))[1]);
