BEGIN
  drop table if exists gga.bill_status_listings;

  create table gga.bill_status_listings like gga_staging.bill_status_listings;

  insert into gga.bill_status_listings
  select a.*
  from gga_staging.bill_status_listings a
  join gga.bills b
    on a.bill_id = b.id;

  alter table bills
    add column passed_over tinyint DEFAULT 0;

/*
  update bills
  set passed_over = -1
  where (( document_type in ('HB','SB') and legislation_type = 'GEN')
     or legislation_type = 'CA');

  update bills
  set passed_over = 1
  where id in (
    select distinct bill_id
    from bill_status_listings
    where (( document_type in ('HB','SB') and legislation_type = 'GEN')
     or legislation_type = 'CA')
    and code in ('HPA','SPA')
  );
*/
END