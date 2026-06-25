create extension if not exists pgcrypto;

create table if not exists public.nordby_entries (
  id text primary key,
  player text not null,
  activity text not null,
  minutes integer not null check (minutes >= 0),
  meters integer not null default 0 check (meters >= 0),
  notes text not null default '',
  media_path text,
  media_type text,
  challenge_done boolean not null default false,
  cheer_count integer not null default 0 check (cheer_count >= 0),
  fire_count integer not null default 0 check (fire_count >= 0),
  clap_count integer not null default 0 check (clap_count >= 0),
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.nordby_comments (
  id uuid primary key default gen_random_uuid(),
  post_id text not null references public.nordby_entries(id) on delete cascade,
  author text not null,
  text text not null,
  created_at timestamptz not null default timezone('utc', now())
);

alter table public.nordby_entries enable row level security;
alter table public.nordby_comments enable row level security;

drop policy if exists "entries_select_authenticated" on public.nordby_entries;
create policy "entries_select_authenticated"
  on public.nordby_entries
  for select
  to authenticated
  using (true);

drop policy if exists "entries_insert_authenticated" on public.nordby_entries;
create policy "entries_insert_authenticated"
  on public.nordby_entries
  for insert
  to authenticated
  with check (true);

drop policy if exists "comments_select_authenticated" on public.nordby_comments;
create policy "comments_select_authenticated"
  on public.nordby_comments
  for select
  to authenticated
  using (true);

drop policy if exists "comments_insert_authenticated" on public.nordby_comments;
create policy "comments_insert_authenticated"
  on public.nordby_comments
  for insert
  to authenticated
  with check (true);

create or replace function public.increment_nordby_reaction(p_post_id text, p_reaction text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_reaction = 'cheer' then
    update public.nordby_entries
    set cheer_count = cheer_count + 1
    where id = p_post_id;
  elsif p_reaction = 'fire' then
    update public.nordby_entries
    set fire_count = fire_count + 1
    where id = p_post_id;
  elsif p_reaction = 'clap' then
    update public.nordby_entries
    set clap_count = clap_count + 1
    where id = p_post_id;
  else
    raise exception 'Unsupported reaction type: %', p_reaction;
  end if;
end;
$$;

revoke all on function public.increment_nordby_reaction(text, text) from public;
grant execute on function public.increment_nordby_reaction(text, text) to authenticated;

insert into storage.buckets (id, name, public)
values ('nordby-il-2014-media', 'nordby-il-2014-media', true)
on conflict (id) do update
set public = excluded.public;

drop policy if exists "media_select_public" on storage.objects;
create policy "media_select_public"
  on storage.objects
  for select
  using (bucket_id = 'nordby-il-2014-media');

drop policy if exists "media_insert_authenticated" on storage.objects;
create policy "media_insert_authenticated"
  on storage.objects
  for insert
  to authenticated
  with check (bucket_id = 'nordby-il-2014-media');

drop policy if exists "media_update_authenticated" on storage.objects;
create policy "media_update_authenticated"
  on storage.objects
  for update
  to authenticated
  using (bucket_id = 'nordby-il-2014-media')
  with check (bucket_id = 'nordby-il-2014-media');
