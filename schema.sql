-- Run this entire SQL script in a NEW Supabase project.
-- The ballots are aggregate-only. No voter name is stored with a vote.

create table if not exists public.voter_tokens (
  code text primary key,
  used_at timestamptz null
);

create table if not exists public.election_results (
  id integer primary key check (id = 1),
  limbax integer not null default 0 check (limbax >= 0),
  gedeon integer not null default 0 check (gedeon >= 0),
  total integer not null default 0 check (total >= 0 and total <= 30)
);

insert into public.election_results (id) values (1)
on conflict (id) do nothing;

-- Replace the placeholder tokens with the 30 codes in TOKENS.txt before running.
-- Each code must be inserted exactly once.
insert into public.voter_tokens(code) values ('0CI3ABAH') on conflict do nothing;
insert into public.voter_tokens(code) values ('2TSMCBZO') on conflict do nothing;
insert into public.voter_tokens(code) values ('SSICXZZ') on conflict do nothing;
insert into public.voter_tokens(code) values ('HDBOSVJ') on conflict do nothing;
insert into public.voter_tokens(code) values ('OTWSRMEH') on conflict do nothing;
insert into public.voter_tokens(code) values ('E2WV2R1') on conflict do nothing;
insert into public.voter_tokens(code) values ('O9YQFZ7L') on conflict do nothing;
insert into public.voter_tokens(code) values ('8NVWWGW2') on conflict do nothing;
insert into public.voter_tokens(code) values ('HXYED4AV') on conflict do nothing;
insert into public.voter_tokens(code) values ('NGMLYZUH') on conflict do nothing;
insert into public.voter_tokens(code) values ('W5TDOUEX') on conflict do nothing;
insert into public.voter_tokens(code) values ('7EKZOUZ') on conflict do nothing;
insert into public.voter_tokens(code) values ('UTVY03WQ') on conflict do nothing;
insert into public.voter_tokens(code) values ('NMGHNYC9') on conflict do nothing;
insert into public.voter_tokens(code) values ('N0RJUFKW') on conflict do nothing;
insert into public.voter_tokens(code) values ('GGJLBXZM') on conflict do nothing;
insert into public.voter_tokens(code) values ('0J5GWVZK') on conflict do nothing;
insert into public.voter_tokens(code) values ('PY6VGZUD') on conflict do nothing;
insert into public.voter_tokens(code) values ('O2WIP5M') on conflict do nothing;
insert into public.voter_tokens(code) values ('ZK27IY5A') on conflict do nothing;
insert into public.voter_tokens(code) values ('DA6AJUB') on conflict do nothing;
insert into public.voter_tokens(code) values ('65A6CKLQ') on conflict do nothing;
insert into public.voter_tokens(code) values ('WA98MWN') on conflict do nothing;
insert into public.voter_tokens(code) values ('VXTM7EAZ') on conflict do nothing;
insert into public.voter_tokens(code) values ('L2LBNLGG') on conflict do nothing;
insert into public.voter_tokens(code) values ('GVJY8CMW') on conflict do nothing;
insert into public.voter_tokens(code) values ('RP3FECN') on conflict do nothing;
insert into public.voter_tokens(code) values ('ZGAN0CZS') on conflict do nothing;
insert into public.voter_tokens(code) values ('BO6VBJLH') on conflict do nothing;
insert into public.voter_tokens(code) values ('EIASDZJ0') on conflict do nothing;

create or replace function public.cast_anonymous_vote(
  p_code text,
  p_candidate text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  claimed_code text;
begin
  if p_candidate not in ('LIMBAYA DIEU DONNE (LIMBAX)', 'GEDEON BOBOTO MINGA') then
    return jsonb_build_object('ok',false,'error','Invalid candidate.');
  end if;

  -- Lock the token row. This makes the one-time check atomic.
  select code into claimed_code
  from voter_tokens
  where code = upper(trim(p_code)) and used_at is null
  for update;

  if claimed_code is null then
    return jsonb_build_object('ok',false,'error','This voting code is invalid or has already been used.');
  end if;

  -- Lock the single result row so two simultaneous voters cannot exceed 30.
  perform 1 from election_results where id=1 for update;

  if (select total from election_results where id=1) >= 30 then
    return jsonb_build_object('ok',false,'error','Voting is closed. The 30-vote limit has been reached.');
  end if;

  update voter_tokens set used_at=now() where code=claimed_code;

  if p_candidate = 'LIMBAYA DIEU DONNE (LIMBAX)' then
    update election_results
    set limbax=limbax+1, total=total+1
    where id=1;
  else
    update election_results
    set gedeon=gedeon+1, total=total+1
    where id=1;
  end if;

  return jsonb_build_object('ok',true);
end;
$$;

-- The public site does not need direct table access.
revoke all on table public.voter_tokens from anon, authenticated;
revoke all on table public.election_results from anon, authenticated;
revoke all on function public.cast_anonymous_vote(text,text) from public;
grant execute on function public.cast_anonymous_vote(text,text) to anon, authenticated;
