BEGIN
  drop table if exists gga.member_votes;

  create table gga.member_votes as
  select mv.id,
         mv.member_id,
         v.id as vote_id,
         mv.voted,
         case mv.voted when 'Yea' then 1 when 'Nay' then -1 else 0 end as vote_code,
         v.vote_date,
         v.caption,
         v.legislation,
         m.name_first,
         m.name_last,
         m.name_middle,
         m.name_nickname,
         m.district_type,
         m.district_number,
         m.party,
         m.title
  from gga_staging.member_votes mv
  join gga.votes v on v.id = mv.vote_id
  join gga.members m on m.id = mv.member_id
  where v.session_id = 24;

  alter table gga.member_votes
    add primary key (id);
END