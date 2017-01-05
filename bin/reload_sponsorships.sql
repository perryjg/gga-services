BEGIN
  drop table if exists gga.sponsorships;

  create table gga.sponsorships as
  select s.id AS id,
         s.member_id AS member_id,
         s.bill_id AS bill_id,
         s.sequence AS sequence,
         s.sponsorship_type AS sponsorship_type,
         m.name_first,
         m.name_last,
         m.name_middle,
         m.name_nickname,
         left(m.party, 1) as party,
         m.title,
       m.district_type,
         m.district_number,
         m.district_address_city as hometown,
         b.document_type,
         b.number,
         b.status_description,
         b.status_date,
         b.caption,
         b.summary,
         b.bill_passed,
       b.predictions,
         b.passed_over
  from gga_staging.sponsorships s
  join gga.bills b
    on b.id = s.bill_id
  join gga.members m
    on s.member_id = m.id;

  alter table gga.sponsorships
    add primary key (id);

  update gga.sponsorships
    set bill_passed = 0
  where bill_passed is NULL;

  update gga.sponsorships, gga.passed
    set bill_passed = 1
  where gga.sponsorships.bill_id = gga.passed.id;
END