-- REPLACE the previous vote function with this version.
-- It does NOT require a voter code.
-- The ballot is aggregate-only; voter names are not stored with the candidate choice.

create or replace function public.cast_anonymous_vote(p_candidate text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_candidate not in ('LIMBAYA DIEU DONNE (LIMBAX)', 'GEDEON BOBOTO MINGA') then
    return jsonb_build_object('ok',false,'error','Invalid candidate.');
  end if;

  perform 1 from public.election_results where id=1 for update;

  if (select total from public.election_results where id=1) >= 30 then
    return jsonb_build_object('ok',false,'error','Voting is closed. The 30-vote limit has been reached.');
  end if;

  if p_candidate = 'LIMBAYA DIEU DONNE (LIMBAX)' then
    update public.election_results set limbax=limbax+1,total=total+1 where id=1;
  else
    update public.election_results set gedeon=gedeon+1,total=total+1 where id=1;
  end if;

  return jsonb_build_object('ok',true);
end;
$$;

revoke all on function public.cast_anonymous_vote(text) from public;
grant execute on function public.cast_anonymous_vote(text) to anon, authenticated;
