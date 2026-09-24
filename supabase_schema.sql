-- Cha-Joy Bonosree A Block ledger schema
-- Run this once in Supabase Dashboard -> SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.ledger_entries (
    id uuid primary key default gen_random_uuid(),
    type text not null check (type in ('income', 'expense')),
    amount numeric(14, 2) not null check (amount > 0),
    category text not null,
    account text not null,
    date date not null default current_date,
    notes text not null default 'No description',
    created_at timestamptz not null default now()
);

create table if not exists public.ledger_sources (
    id uuid primary key default gen_random_uuid(),
    name text not null unique,
    created_at timestamptz not null default now()
);

create table if not exists public.ledger_categories (
    id uuid primary key default gen_random_uuid(),
    name text not null unique,
    created_at timestamptz not null default now()
);

create table if not exists public.ledger_accounts (
    id uuid primary key default gen_random_uuid(),
    name text not null unique,
    created_at timestamptz not null default now()
);

alter table public.ledger_entries enable row level security;
alter table public.ledger_sources enable row level security;
alter table public.ledger_categories enable row level security;
alter table public.ledger_accounts enable row level security;

create policy "Authenticated users can read ledger entries"
on public.ledger_entries for select to authenticated using (true);
create policy "Authenticated users can add ledger entries"
on public.ledger_entries for insert to authenticated with check (true);
create policy "Authenticated users can update ledger entries"
on public.ledger_entries for update to authenticated using (true) with check (true);
create policy "Authenticated users can delete ledger entries"
on public.ledger_entries for delete to authenticated using (true);

create policy "Authenticated users can read ledger sources"
on public.ledger_sources for select to authenticated using (true);
create policy "Authenticated users can add ledger sources"
on public.ledger_sources for insert to authenticated with check (true);
create policy "Authenticated users can delete ledger sources"
on public.ledger_sources for delete to authenticated using (true);

create policy "Authenticated users can read ledger categories"
on public.ledger_categories for select to authenticated using (true);
create policy "Authenticated users can add ledger categories"
on public.ledger_categories for insert to authenticated with check (true);
create policy "Authenticated users can delete ledger categories"
on public.ledger_categories for delete to authenticated using (true);

create policy "Authenticated users can read ledger accounts"
on public.ledger_accounts for select to authenticated using (true);
create policy "Authenticated users can add ledger accounts"
on public.ledger_accounts for insert to authenticated with check (true);
create policy "Authenticated users can delete ledger accounts"
on public.ledger_accounts for delete to authenticated using (true);
