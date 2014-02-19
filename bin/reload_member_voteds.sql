BEGIN
  drop table if exists gga.member_votes;

  create table gga.member_votes as
  select mv.*,
         case mv.voted when 'Yea' then 1 when 'Nay' then -1 else 0 end as vote_code,
         v.vote_date,
         v.caption,
         v.bill_id,
         b.caption as bill_caption,
         b.document_type,
         b.number,
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
  join gga.bills b on b.id = v.bill_id
  join gga.members m on m.id = mv.member_id;

  alter table gga.member_votes
    add primary key (id);
END
