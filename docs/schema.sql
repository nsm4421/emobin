-- 감정 쓰레기통 앱 스키마 (PostgreSQL)

create extension if not exists pgcrypto;

-- 감정 타입
DO $$
BEGIN
  CREATE TYPE public.emotion_enum AS ENUM (
    '화남',
    '불안',
    '슬픔',
    '기쁨',
    '짜증',
    '두려움',
    '피곤',
    '무기력'
  );
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- 감정 기록
create table if not exists public.entries (
  id uuid primary key default gen_random_uuid(),
  event_text text not null,
  emotion public.emotion_enum not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  resolved_at timestamptz
);

create index if not exists entries_created_at_idx on public.entries (created_at);
create index if not exists entries_resolved_at_idx on public.entries (resolved_at);

-- updated_at 자동 갱신
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger set_entries_updated_at
before update on public.entries
for each row
execute function public.set_updated_at();
