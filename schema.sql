-- GOLDEN starter database schema for Supabase
-- Run this in Supabase Dashboard > SQL Editor > New query.
-- These policies are a starter baseline; review/test them before a public launch.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'GOLDEN member' check (char_length(display_name) <= 40),
  photo_url text,
  bio text not null default '' check (char_length(bio) <= 240),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  body text not null default '' check (char_length(body) <= 2000),
  image_url text,
  created_at timestamptz not null default now(),
  constraint post_has_content check (char_length(trim(body)) > 0 or image_url is not null)
);

create table if not exists public.likes (
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(trim(body)) > 0 and char_length(body) <= 500),
  created_at timestamptz not null default now()
);

create table if not exists public.follows (
  follower_id uuid not null references public.profiles(id) on delete cascade,
  following_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (follower_id, following_id),
  check (follower_id <> following_id)
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid not null references public.profiles(id) on delete cascade,
  recipient_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(trim(body)) > 0 and char_length(body) <= 3000),
  created_at timestamptz not null default now(),
  check (sender_id <> recipient_id)
);

create index if not exists posts_created_at_idx on public.posts(created_at desc);
create index if not exists comments_post_created_idx on public.comments(post_id, created_at);
create index if not exists messages_pair_created_idx on public.messages(sender_id, recipient_id, created_at);

alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.likes enable row level security;
alter table public.comments enable row level security;
alter table public.follows enable row level security;
alter table public.messages enable row level security;

-- Profiles: public read for discover; each user updates only their own profile.
create policy "Profiles readable by signed-in users" on public.profiles for select to authenticated using (true);
create policy "Users create own profile" on public.profiles for insert to authenticated with check (auth.uid() = id);
create policy "Users update own profile" on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

-- Posts: signed-in users can read; authors control create/update/delete.
create policy "Posts readable by signed-in users" on public.posts for select to authenticated using (true);
create policy "Users create own posts" on public.posts for insert to authenticated with check (auth.uid() = user_id);
create policy "Authors update own posts" on public.posts for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Authors delete own posts" on public.posts for delete to authenticated using (auth.uid() = user_id);

-- Likes: visible to signed-in users; users manage only their own likes.
create policy "Likes readable by signed-in users" on public.likes for select to authenticated using (true);
create policy "Users like as themselves" on public.likes for insert to authenticated with check (auth.uid() = user_id);
create policy "Users remove own likes" on public.likes for delete to authenticated using (auth.uid() = user_id);

-- Comments: signed-in users can read, create, and delete their own.
create policy "Comments readable by signed-in users" on public.comments for select to authenticated using (true);
create policy "Users create own comments" on public.comments for insert to authenticated with check (auth.uid() = user_id);
create policy "Users delete own comments" on public.comments for delete to authenticated using (auth.uid() = user_id);

-- Follows: users can see relationships; can only create/remove their own follows.
create policy "Follows readable by signed-in users" on public.follows for select to authenticated using (true);
create policy "Users follow as themselves" on public.follows for insert to authenticated with check (auth.uid() = follower_id);
create policy "Users unfollow as themselves" on public.follows for delete to authenticated using (auth.uid() = follower_id);

-- Messages: only sender or recipient may read a conversation; sender may send as self.
create policy "Participants read their messages" on public.messages for select to authenticated using (auth.uid() = sender_id or auth.uid() = recipient_id);
create policy "Sender sends as self" on public.messages for insert to authenticated with check (auth.uid() = sender_id);
create policy "Sender can delete own messages" on public.messages for delete to authenticated using (auth.uid() = sender_id);

-- IMPORTANT:
-- Account deletion, block/report, notifications, private accounts, image storage uploads,
-- and moderation are NOT fully implemented in this starter. Add secure server-side
-- functions and more policies before inviting the public. Do not expose a service-role key.
