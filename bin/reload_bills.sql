BEGIN
  drop table if exists gga.bills;

  create table gga.bills like gga_staging.bills;

  alter table gga.bills
    add column bill_passed tinyint DEFAULT 0,
    add column predictions double;

  insert into gga.bills
  select a.*, b.bill_passed, b.prediction
  from gga_staging.bills a
  left join gga_staging.predictions b
    on a.id = b.bill_id
  where a.session_id = 24;
END