-- =====================================================
-- Kontrakanku: skema database lengkap (Supabase / PostgreSQL)
-- Jalankan di Supabase SQL Editor, lalu jalankan seed.sql
-- =====================================================

create table tenants (
  id bigint primary key generated always as identity,
  name text not null,
  full_name text not null,
  room int not null unique
);

create table expenses (
  id bigint primary key generated always as identity,
  title text not null,
  category text not null default 'lainnya',
  amount bigint not null check (amount > 0),
  expense_date date not null,
  note text,
  created_at timestamptz not null default now()
);

create table payments (
  id bigint primary key generated always as identity,
  tenant_id bigint not null references tenants (id) on delete cascade,
  amount bigint not null check (amount > 0),
  method text not null default 'tunai',
  paid_at date not null,
  note text,
  created_at timestamptz not null default now()
);

-- Row Level Security: aplikasi tanpa login memakai peran "anon"
alter table tenants enable row level security;
alter table expenses enable row level security;
alter table payments enable row level security;

create policy "anon full access tenants" on tenants
  for all to anon using (true) with check (true);

create policy "anon full access expenses" on expenses
  for all to anon using (true) with check (true);

create policy "anon full access payments" on payments
  for all to anon using (true) with check (true);

-- Hak akses tingkat tabel untuk peran anon
grant select, insert, update, delete on public.tenants to anon;
grant select, insert, update, delete on public.expenses to anon;
grant select, insert, update, delete on public.payments to anon;
grant usage, select on all sequences in schema public to anon;