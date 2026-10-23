create extension if not exists "pgcrypto";
create type public.user_role as enum ('customer','restaurant_owner','delivery_partner','admin');
create type public.order_status as enum ('placed','accepted','preparing','ready','picked_up','out_for_delivery','delivered','cancelled');
create table public.profiles(id uuid primary key references auth.users(id) on delete cascade, name text, phone text, role public.user_role default 'customer', avatar_url text, created_at timestamptz default now(), updated_at timestamptz default now());
create table public.restaurants(id uuid primary key default gen_random_uuid(), name text not null, cuisine text, description text, address text, image_url text, rating numeric(2,1) default 0, delivery_fee numeric(10,2) default 0, delivery_minutes int default 30, is_open boolean default true, owner_id uuid references public.profiles(id), created_at timestamptz default now());
create table public.categories(id uuid primary key default gen_random_uuid(), name text unique not null);
create table public.foods(id uuid primary key default gen_random_uuid(), restaurant_id uuid references public.restaurants(id) on delete cascade, category_id uuid references public.categories(id), name text not null, description text, price numeric(10,2) not null check(price>=0), image_url text, is_veg boolean default true, available boolean default true, created_at timestamptz default now());
create table public.addresses(id uuid primary key default gen_random_uuid(), user_id uuid references public.profiles(id) on delete cascade, label text, address text not null, created_at timestamptz default now());
create table public.orders(id uuid primary key default gen_random_uuid(), user_id uuid references public.profiles(id), restaurant_id uuid references public.restaurants(id), address_id uuid references public.addresses(id), status public.order_status default 'placed', subtotal numeric(10,2) not null, delivery_fee numeric(10,2) default 0, tax numeric(10,2) default 0, discount numeric(10,2) default 0, total numeric(10,2) not null, created_at timestamptz default now(), updated_at timestamptz default now());
create table public.order_items(id uuid primary key default gen_random_uuid(), order_id uuid references public.orders(id) on delete cascade, food_id uuid references public.foods(id), name_snapshot text not null, price_snapshot numeric(10,2) not null, quantity int not null check(quantity>0));
create table public.reviews(id uuid primary key default gen_random_uuid(), user_id uuid references public.profiles(id), restaurant_id uuid references public.restaurants(id), order_id uuid unique references public.orders(id), rating int check(rating between 1 and 5), comment text, created_at timestamptz default now());
create table public.favorites(user_id uuid references public.profiles(id) on delete cascade, restaurant_id uuid references public.restaurants(id) on delete cascade, primary key(user_id,restaurant_id));
create table public.notifications(id uuid primary key default gen_random_uuid(), user_id uuid references public.profiles(id) on delete cascade, title text not null, body text, read boolean default false, created_at timestamptz default now());
create table public.deliveries(id uuid primary key default gen_random_uuid(), order_id uuid unique references public.orders(id) on delete cascade, partner_id uuid references public.profiles(id), status public.order_status default 'placed', assigned_at timestamptz);
alter table public.profiles enable row level security;
alter table public.addresses enable row level security;
alter ta
create extension if not exists pgcrypto;

-- Create enum types only if they don't already exist.
do $$
begin
  create type public.user_role as enum (
    'customer', 'restaurant_owner', 'delivery_partner', 'admin'
  );
exception when duplicate_object then null;
end $$;

do $$
begin
  create type public.order_status as enum (
    'placed', 'accepted', 'preparing', 'ready',
    'picked_up', 'out_for_delivery', 'delivered', 'cancelled'
  );
exception when duplicate_object then null;
end $$;

-- Create tables if they do not already exist.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text,
  phone text,
  role public.user_role default 'customer',
  avatar_url text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.restaurants (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  cuisine text,
  description text,
  address text,
  image_url text,
  rating numeric(2,1) default 0,
  delivery_fee numeric(10,2) default 0,
  delivery_minutes int default 30,
  is_open boolean default true,
  owner_id uuid references public.profiles(id),
  created_at timestamptz default now()
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text unique not null
);

create table if not exists public.foods (
  id uuid primary key default gen_random_uuid(),
  restaurant_id uuid references public.restaurants(id) on delete cascade,
  category_id uuid references public.categories(id),
  name text not null,
  description text,
  price numeric(10,2) not null check (price >= 0),
  image_url text,
  is_veg boolean default true,
  available boolean default true,
  created_at timestamptz default now()
);

create table if not exists public.addresses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  label text,
  address text not null,
  created_at timestamptz default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id),
  restaurant_id uuid references public.restaurants(id),
  address_id uuid references public.addresses(id),
  status public.order_status default 'placed',
  subtotal numeric(10,2) not null,
  delivery_fee numeric(10,2) default 0,
  tax numeric(10,2) default 0,
  discount numeric(10,2) default 0,
  total numeric(10,2) not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.orders(id) on delete cascade,
  food_id uuid references public.foods(id),
  name_snapshot text not null,
  price_snapshot numeric(10,2) not null,
  quantity int not null check (quantity > 0)
);

create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id),
  restaurant_id uuid references public.restaurants(id),
  order_id uuid unique references public.orders(id),
  rating int check (rating between 1 and 5),
  comment text,
  created_at timestamptz default now()
);

create table if not exists public.favorites (
  user_id uuid references public.profiles(id) on delete cascade,
  restaurant_id uuid references public.restaurants(id) on delete cascade,
  primary key (user_id, restaurant_id)
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  title text not null,
  body text,
  read boolean default false,
  created_at timestamptz default now()
);

create table if not exists public.deliveries (
  id uuid primary key default gen_random_uuid(),
  order_id uuid unique references public.orders(id) on delete cascade,
  partner_id uuid references public.profiles(id),
  status public.order_status default 'placed',
  assigned_at timestamptz
);

-- Enable row-level security.
alter table public.profiles enable row level security;
alter table public.addresses enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.reviews enable row level security;
alter table public.favorites enable row level security;
alter table public.notifications enable row level security;

-- Create policies only if missing.
do $$
begin
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='profiles' and policyname='own profile') then
    create policy "own profile" on public.profiles for all
      using (auth.uid() = id) with check (auth.uid() = id);
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='addresses' and policyname='own addresses') then
    create policy "own addresses" on public.addresses for all
      using (auth.uid() = user_id) with check (auth.uid() = user_id);
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='orders' and policyname='own orders') then
    create policy "own orders" on public.orders for select
      using (auth.uid() = user_id);
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='order_items' and policyname='own order items') then
    create policy "own order items" on public.order_items for select
      using (exists (
        select 1 from public.orders o
        where o.id = order_id and o.user_id = auth.uid()
      ));
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='favorites' and policyname='own favorites') then
    create policy "own favorites" on public.favorites for all
      using (auth.uid() = user_id) with check (auth.uid() = user_id);
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='notifications' and policyname='own notifications') then
    create policy "own notifications" on public.notifications for select
      using (auth.uid() = user_id);
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='restaurants' and policyname='public restaurants') then
    create policy "public restaurants" on public.restaurants for select using (true);
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='categories' and policyname='public categories') then
    create policy "public categories" on public.categories for select using (true);
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='foods' and policyname='public foods') then
    create policy "public foods" on public.foods for select using (true);
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='reviews' and policyname='reviews readable') then
    create policy "reviews readable" on public.reviews for select using (true);
  end if;

  if not exists (select 1 from pg_policies where schemaname='public' and tablename='reviews' and policyname='reviews own insert') then
    create policy "reviews own insert" on public.reviews for insert
      with check (auth.uid() = user_id);
  end if;
end $$;

-- Add realtime tables only if they are not already published.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public' and tablename = 'orders'
  ) then
    alter publication supabase_realtime add table public.orders;
  end if;

  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public' and tablename = 'notifications'
  ) then
    alter publication supabase_realtime add table public.notifications;
  end if;
end $$;
ble public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.reviews enable row level security;
alter table public.favorites enable row level security;
alter table public.notifications enable row level security;
create policy "own profile" on public.profiles for all using(auth.uid()=id) with check(auth.uid()=id);
create policy "own addresses" on public.addresses for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own orders" on public.orders for select using(auth.uid()=user_id);
create policy "own order items" on public.order_items for select using(exists(select 1 from public.orders o where o.id=order_id and o.user_id=auth.uid()));
create policy "own favorites" on public.favorites for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own notifications" on public.notifications for select using(auth.uid()=user_id);
create policy "public restaurants" on public.restaurants for select using(true);
create policy "public categories" on public.categories for select using(true);
create policy "public foods" on public.foods for select using(true);
create policy "reviews readable" on public.reviews for select using(true);
create policy "reviews own insert" on public.reviews for insert with check(auth.uid()=user_id);
alter publication supabase_realtime add table public.orders;
alter publication supabase_realtime add table public.notifications;
