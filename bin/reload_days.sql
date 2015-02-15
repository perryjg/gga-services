BEGIN
  drop table if exists days;

  create table days as
  select @i:=@i+1 id, t.* from (
    select a.legislative_day_date,
           b.id as legislative_day
    from (select distinct date(status_date) as legislative_day_date from bill_status_listings order by 1) a
    left join gga_staging.legislative_days b
           on a.legislative_day_date = b.legislative_day_date
    order by 1
  ) t
  join (select @i:=0) r;

  alter table days
  add primary key (id);
END
