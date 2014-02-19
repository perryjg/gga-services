BEGIN
  drop table if exists gga.bills;

  create table gga.bills like gga_staging.bills;

  alter table bills
    add column bill_passed tinyint,
    add column predictions double;

  insert into gga.bills
  select a.*, b.bill_passed, b.prediction
  from gga_staging.bills a
  join gga_staging.predictions b
    on a.id = b.bill_id
  where a.session_id = 23;
END
