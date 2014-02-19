BEGIN
  drop table if exists gga.bill_status_listings;

  create table gga.bill_status_listings like gga_staging.bill_status_listings;

  insert into gga.bill_status_listings
  select a.*
  from gga_staging.bill_status_listings a
  join gga.bills b
    on a.bill_id = b.id;
END
