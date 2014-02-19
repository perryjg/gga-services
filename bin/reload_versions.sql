BEGIN
  drop table if exists gga.versions;

  create table gga.versions as
  select v.*
  from gga_staging.versions v
  join gga.bills b
    on b.id = v.bill_id;

  alter table gga.versions
    add primary key (id);
END
