BEGIN
  DROP TABLE IF EXISTS passed;

  CREATE TABLE passed AS
    SELECT id, document_type, number, legislation_type, status_description
    FROM bills
    WHERE id in (
      SELECT b.id
      FROM bills b
      JOIN (
        SELECT bill_id as id, GROUP_CONCAT(
          DISTINCT code
          ORDER BY status_date ASC
          SEPARATOR ' '
        ) AS status_list
        FROM bill_status_listings
        GROUP BY bill_id
      ) t
        USING(id)
      WHERE ((document_type in ('HB','SB') OR legislation_type in ('GEN','CA'))
              AND (status_list REGEXP 'HSG' OR status_list REGEXP 'SSG'))
         OR (legislation_type in ('PRIV','NP')
             AND status_list REGEXP 'HPA|HRA|SPA|SRA')
  );

  ALTER TABLE passed
    ADD PRIMARY KEY(id);

  INSERT IGNORE INTO passed
    SELECT id, document_type, number, legislation_type, status_description
    FROM bills
    WHERE id IN (
      SELECT DISTINCT bill_id AS id
      FROM bill_status_listings
      WHERE
        ( ( document_type = 'HB'
             OR
          (document_type = 'HR' AND legislation_type IN ('GEN','CA'))
        ) AND code = 'SPA' AND am_sub IS NULL)
      OR
        ( ( document_type = 'SB'
             OR
          (document_type = 'SR' AND legislation_type IN ('GEN','CA'))
        ) and code = 'HPA' and am_sub is null )
      OR
        ( ( document_type = 'HB'
             OR
          (document_type = 'HR' AND legislation_type IN('GEN','CA'))
        ) AND code = 'HASAS' )
      OR
        ( ( document_type = 'SB'
             OR
          (document_type = 'SR' and legislation_type IN ('GEN','CA'))
        ) AND code = 'SAHAS' )
  );

  INSERT IGNORE INTO passed
    SELECT id, document_type, number, legislation_type, status_description
    FROM bills
    WHERE id IN (
      SELECT bill_id
      FROM bill_status_listings
      GROUP BY bill_id
      HAVING group_concat(
          code
          ORDER BY status_date ASC
          SEPARATOR ' '
        ) REGEXP '[[:<:]]HCA[[:>:]]'
      AND group_concat(
          code
          ORDER BY status_date ASC
          SEPARATOR ' '
        ) REGEXP '[[:<:]]SCRA[[:>:]]'
  );

  UPDATE bills
    SET bill_passed = 0
  WHERE bill_passed IS NULL;

  UPDATE bills, passed
    SET bill_passed = 1
  WHERE bills.id = passed.id;

  UPDATE watched_bills
    SET bill_passed = 0
  WHERE bill_passed IS NULL;

  UPDATE watched_bills, passed
    SET bill_passed = 1
  WHERE watched_bills.bill_id = passed.id;
END