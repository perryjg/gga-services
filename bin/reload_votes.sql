BEGIN
  drop table if exists gga.bills_votes;

  create table gga.bills_votes as
    select * from gga_staging.bills_votes
    where vote_id in (
      select distinct vote_id
      from gga_staging.votes
      where session_id = 23
  );

  alter table gga.bills_votes
    add primary key (bill_id, vote_id);

  drop table if exists gga.new_votes;

  create table gga.new_votes as
    select a.id as vote_id,
           a.legislation,
           b.bill_id,
           c.caption as title,
           a.branch,
           a.session_id,
           a.caption,
           a.vote_date,
           a.description,
           a.number,
           a.not_voting,
           a.excused,
           a.nays,
           a.yeas
    from gga_staging.votes a
    join gga_staging.bills_votes b on a.id = b.vote_id
    join gga_staging.bills c on b.bill_id = c.id
    where a.session_id = 23;

  alter table gga.new_votes
    add column id int primary key auto_increment first;
END
