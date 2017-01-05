DElIMITER //

DROP PROCEDURE IF EXISTS reload_votes//

CREATE PROCEDURE reload_votes ()
BEGIN
  drop table if exists gga.bills_votes;

  create table gga.bills_votes as
    select @id:=@id+1 id, v.*,
           b.document_type,
           b.number
    from gga_staging.bills_votes v
    join gga_staging.bills b on v.bill_id = b.id
    join (select @id:=0) t
    where b.session_id = 24;

  alter table gga.bills_votes
    add primary key (id);

  drop table if exists gga.votes;

  create table gga.votes as
    select a.id,
           a.legislation,
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
    where a.session_id = 24;

  alter table gga.votes
    add primary key (id);
END//

DELIMITER ;