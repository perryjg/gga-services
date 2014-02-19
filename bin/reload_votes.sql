BEGIN
  drop table if exists gga.votes;

  create table gga.votes as
  select v.*
  from gga_staging.votes v
  join gga.bills b
    on b.id = v.bill_id;

  alter table gga.votes
    add primary key (id);
END
