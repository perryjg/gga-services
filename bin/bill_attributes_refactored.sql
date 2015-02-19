SET default_storage_engine=MYISAM;

/*append new legislative days into historical table*/
INSERT INTO legislative_days_historical 
SELECT YEAR(legislative_day_date) AS leg_year_submitted,legislative_day_date AS status_date,'1' AS on_calendar,id AS leg_day,40-id AS leg_day_remaining
FROM legislative_days ld
LEFT JOIN legislative_days_historical ldj
ON ld.legislative_day_date=ldj.status_date
WHERE ldj.status_date IS NULL;

  
  
/*replace bills_attributes table*/
  DROP TABLE IF EXISTS bills_attributes;


  CREATE TABLE bills_attributes AS
  SELECT a.id, a.session_id, a.document_type, a.number,
         IF(SUBSTRING_INDEX(summary,' ',12)='A bill to be entitled an Act to provide a homestead exemption','1','0') AS summary_homestead,
         IF(SUBSTRING_INDEX(summary,' ',11)='A bill to be entitled an Act to amend an Act' OR SUBSTRING_INDEX(summary,' ',6)='A bill to amend an Act','1','0') AS summary_amend_act,
         IF(SUBSTRING_INDEX(summary,' ',10)='A bill to be entitled an Act to amend title' OR SUBSTRING_INDEX(summary,' ',5)='A bill to amend title','1','0') AS summary_amend_title,
         IF(SUBSTRING_INDEX(summary,' ',10)='A bill to be entitled an Act to amend chapter' OR SUBSTRING_INDEX(summary,' ',5)='A bill to amend chapter','1','0') AS summary_amend_chapter,
         IF(SUBSTRING_INDEX(summary,' ',10)='A bill to be entitled an Act to amend article' OR SUBSTRING_INDEX(summary,' ',5)='A bill to amend article','1','0') AS summary_amend_article,
         IF(SUBSTRING_INDEX(summary,' ',11)='A bill to be entitled an Act to amend code section' OR SUBSTRING_INDEX(summary,' ',6)='A bill to amend code section','1','0') AS summary_amend_code,
         IF(SUBSTRING_INDEX(summary,' ',10)='A bill to be entitled an Act to amend part' OR SUBSTRING_INDEX(summary,' ',5)='A bill to amend part','1','0') AS summary_amend_part,
         IF(SUBSTRING_INDEX(summary,' ',9)='A bill to be entitled an Act to amend' OR SUBSTRING_INDEX(summary,' ',4)='A bill to amend','1','0') AS summary_amend_any,
         IF(summary LIKE '%new charter%',1,0) AS summary_new_charter,
         IF(SUBSTRING_INDEX(summary,' ',15) LIKE '%to authorize the city%' OR SUBSTRING_INDEX(summary,' ',15) LIKE '%to authorize the governing authority%',1,0) AS summary_to_authorize,
         IF(summary LIKE '%48-%' OR summary LIKE '% 48 %',1,0) AS summary_tax,
         IF(summary LIKE '%county%',1,0) AS summary_county,
       IF((a.summary LIKE '% Appling %' OR a.summary LIKE '% Athens-Clarke %' OR a.summary LIKE '% Atkinson %' OR a.summary LIKE '% Augusta-Richmond %' OR a.summary LIKE '% Bacon %' OR a.summary LIKE '% Baker %' OR a.summary LIKE '% Baldwin %' OR a.summary LIKE '% Banks %' OR a.summary LIKE '% Barrow %' OR a.summary LIKE '% Bartow %' OR a.summary LIKE '% Ben Hill %' OR a.summary LIKE '% Berrien %' OR a.summary LIKE '% Bibb %' OR a.summary LIKE '% Bleckley %' OR a.summary LIKE '% Brantley %' OR a.summary LIKE '% Brooks %' OR a.summary LIKE '% Bryan %' OR a.summary LIKE '% Bulloch %' OR a.summary LIKE '% Burke %' OR a.summary LIKE '% Butts %' OR a.summary LIKE '% Calhoun %' OR a.summary LIKE '% Camden %' OR a.summary LIKE '% Candler %' OR a.summary LIKE '% Carroll %' OR a.summary LIKE '% Catoosa %' OR a.summary LIKE '% Charlton %' OR a.summary LIKE '% Chatham %' OR a.summary LIKE '% Chattooga %' OR a.summary LIKE '% Cherokee %' OR a.summary LIKE '% Clay %' OR a.summary LIKE '% Clayton %' OR a.summary LIKE '% Clinch %' OR a.summary LIKE '% Cobb %' OR a.summary LIKE '% Coffee %' OR a.summary LIKE '% Colquitt %' OR a.summary LIKE '% Columbia %' OR a.summary LIKE '% Columbus-Muscogee %' OR a.summary LIKE '% Cook %' OR a.summary LIKE '% Coweta %' OR a.summary LIKE '% Crawford %' OR a.summary LIKE '% Crisp %' OR a.summary LIKE '% Cusseta-Chattahoochee %' OR a.summary LIKE '% Dade %' OR a.summary LIKE '% Dawson %' OR a.summary LIKE '% Decatur %' OR a.summary LIKE '% DeKalb %' OR a.summary LIKE '% Dodge %' OR a.summary LIKE '% Dooly %' OR a.summary LIKE '% Dougherty %' OR a.summary LIKE '% Douglas %' OR a.summary LIKE '% Early %' OR a.summary LIKE '% Echols %' OR a.summary LIKE '% Effingham %' OR a.summary LIKE '% Elbert %' OR a.summary LIKE '% Emanuel %' OR a.summary LIKE '% Evans %' OR a.summary LIKE '% Fannin %' OR a.summary LIKE '% Fayette %' OR a.summary LIKE '% Floyd %' OR a.summary LIKE '% Forsyth %' OR a.summary LIKE '% Franklin %' OR a.summary LIKE '% Fulton %' OR a.summary LIKE '% Georgetown-Quitman %' OR a.summary LIKE '% Gilmer %' OR a.summary LIKE '% Glascock %' OR a.summary LIKE '% Glynn %' OR a.summary LIKE '% Gordon %' OR a.summary LIKE '% Grady %' OR a.summary LIKE '% Greene %' OR a.summary LIKE '% Gwinnett %' OR a.summary LIKE '% Habersham %' OR a.summary LIKE '% Hall %' OR a.summary LIKE '% Hancock %' OR a.summary LIKE '% Haralson %' OR a.summary LIKE '% Harris %' OR a.summary LIKE '% Hart %' OR a.summary LIKE '% Heard %' OR a.summary LIKE '% Henry %' OR a.summary LIKE '% Houston %' OR a.summary LIKE '% Irwin %' OR a.summary LIKE '% Jackson %' OR a.summary LIKE '% Jasper %' OR a.summary LIKE '% Jeff Davis %' OR a.summary LIKE '% Jefferson %' OR a.summary LIKE '% Jenkins %' OR a.summary LIKE '% Johnson %' OR a.summary LIKE '% Jones %' OR a.summary LIKE '% Lamar %' OR a.summary LIKE '% Lanier %' OR a.summary LIKE '% Laurens %' OR a.summary LIKE '% Lee %' OR a.summary LIKE '% Liberty %' OR a.summary LIKE '% Lincoln %' OR a.summary LIKE '% Long %' OR a.summary LIKE '% Lowndes %' OR a.summary LIKE '% Lumpkin %' OR a.summary LIKE '% Macon %' OR a.summary LIKE '% Madison %' OR a.summary LIKE '% Marion %' OR a.summary LIKE '% McDuffie %' OR a.summary LIKE '% McIntosh %' OR a.summary LIKE '% Meriwether %' OR a.summary LIKE '% Miller %' OR a.summary LIKE '% Mitchell %' OR a.summary LIKE '% Monroe %' OR a.summary LIKE '% Montgomery %' OR a.summary LIKE '% Morgan %' OR a.summary LIKE '% Murray %' OR a.summary LIKE '% Newton %' OR a.summary LIKE '% Oconee %' OR a.summary LIKE '% Oglethorpe %' OR a.summary LIKE '% Paulding %' OR a.summary LIKE '% Peach %' OR a.summary LIKE '% Pickens %' OR a.summary LIKE '% Pierce %' OR a.summary LIKE '% Pike %' OR a.summary LIKE '% Polk %' OR a.summary LIKE '% Pulaski %' OR a.summary LIKE '% Putnam %' OR a.summary LIKE '% Rabun %' OR a.summary LIKE '% Randolph %' OR a.summary LIKE '% Rockdale %' OR a.summary LIKE '% Schley %' OR a.summary LIKE '% Screven %' OR a.summary LIKE '% Seminole %' OR a.summary LIKE '% Spalding %' OR a.summary LIKE '% Stephens %' OR a.summary LIKE '% Stewart %' OR a.summary LIKE '% Sumter %' OR a.summary LIKE '% Talbot %' OR a.summary LIKE '% Taliaferro %' OR a.summary LIKE '% Tattnall %' OR a.summary LIKE '% Taylor %' OR a.summary LIKE '% Telfair %' OR a.summary LIKE '% Terrell %' OR a.summary LIKE '% Thomas %' OR a.summary LIKE '% Tift %' OR a.summary LIKE '% Toombs %' OR a.summary LIKE '% Towns %' OR a.summary LIKE '% Treutlen %' OR a.summary LIKE '% Troup %' OR a.summary LIKE '% Turner %' OR a.summary LIKE '% Twiggs %' OR a.summary LIKE '% Union %' OR a.summary LIKE '% Upson %' OR a.summary LIKE '% Walker %' OR a.summary LIKE '% Walton %' OR a.summary LIKE '% Ware %' OR a.summary LIKE '% Warren %' OR a.summary LIKE '% Washington %' OR a.summary LIKE '% Wayne %' OR a.summary LIKE '% Webster %' OR a.summary LIKE '% Wheeler %' OR a.summary LIKE '% White %' OR a.summary LIKE '% Whitfield %' OR a.summary LIKE '% Wilcox %' OR a.summary LIKE '% Wilkes %' OR a.summary LIKE '% Wilkinson %' OR a.summary LIKE '% Worth %') AND (a.summary LIKE '%county%' OR a.summary LIKE '%consolidated%'),1,0) AS summary_county_names,
         IF(summary LIKE '%city%',1,0) AS summary_city,
         IF((summary LIKE '%city of%' OR summary LIKE '%town of%' OR summary LIKE '%consolidated government of%' OR summary LIKE '%metropolitan%' OR summary LIKE '%municipality of%') AND summary NOT LIKE "%city of this state%" AND summary NOT LIKE "%town of this state%",1,0)
     AS summary_city_of,
         IF(summary LIKE '%regulat%',1,0) AS summary_regulate,
         IF(summary LIKE '%office %',1,0) AS summary_office,
         IF(summary LIKE '%election %',1,0) AS summary_election,
         IF(summary LIKE '% health %',1,0) AS summary_health,
         IF(summary LIKE '%firearm%' OR summary LIKE '% gun%' OR summary LIKE '% abort%' OR summary LIKE '%marriage%'
  OR summary LIKE '% pray%' OR summary LIKE '%alcohol%' OR summary LIKE '%controlled substance%',1,0) AS summary_social,
         IF(SUM(IF(b.code IN ('HSG','SSG'),1,0))>0,1,0) AS passed_old,
         MAX(b.status_date) AS max_action_date,
         MIN(b.status_date) AS date_submitted
  FROM bills a
  LEFT JOIN bill_status_listings b
        ON a.id = bill_id

  WHERE a.document_type IN ('HB','SB')
    AND b.code <> 'EFF'
    AND a.session_id IN (1,11,14,18,20,21,23,24)/* Regular sessions */

  GROUP BY a.id, a.session_id, a.document_type, a.number;


  ALTER TABLE bills_attributes
  ADD COLUMN author_party INT,
  ADD COLUMN majority_party INT,
  ADD COLUMN majority_party_house INT,
  ADD COLUMN majority_party_senate INT,
  ADD COLUMN gov_party INT,
  ADD COLUMN chamber_leader_sponsor INT,
  ADD COLUMN chamber_leader_author INT,
  ADD COLUMN leadership_author_republican INT,
  ADD COLUMN leadership_sponsors_republican INT,
  ADD COLUMN leadership_author_democrat INT,
  ADD COLUMN leadership_sponsors_democrat INT,
  ADD COLUMN other_sponsors_democrat INT,
  ADD COLUMN other_sponsors_republican INT,
  ADD COLUMN other_minority_sponsors INT,
  ADD COLUMN other_majority_sponsors INT,
  ADD COLUMN floor_leader_author INT,
  ADD COLUMN floor_leader_sponsors INT,
  ADD COLUMN other_leadership_sponsors_republican INT,
  ADD COLUMN other_leadership_sponsors_democrat INT,
  ADD COLUMN other_majority_leadership_sponsors INT,
  ADD COLUMN other_minority_leadership_sponsors INT,
  ADD COLUMN majority_leadership_author INT,
  ADD COLUMN majority_leadership_sponsors INT,
  ADD COLUMN minority_leadership_author INT,
  ADD COLUMN minority_leadership_sponsors INT,
  ADD COLUMN majority_sponsors INT,
  ADD COLUMN minority_sponsors INT,
  ADD COLUMN sponsors INT,
  ADD COLUMN sponsors_republican INT,
  ADD COLUMN sponsors_democrat INT,
  ADD COLUMN sponsors_house INT,
  ADD COLUMN sponsors_senate INT,
  ADD COLUMN author_independent INT,
  ADD COLUMN sponsors_independent INT,
  ADD COLUMN majority_party_author INT,
  ADD COLUMN gov_election_year INT,
  ADD COLUMN leg_election_year INT,
  ADD COLUMN gov_reelection_year INT,
  ADD COLUMN leg_year_submitted YEAR(4),
  ADD COLUMN majority_edge_percent_house FLOAT,
  ADD COLUMN majority_edge_percent_senate FLOAT,
  ADD COLUMN majority_edge_house INT,
  ADD COLUMN majority_edge_senate INT,
  ADD COLUMN majority_edge INT,
  ADD COLUMN majority_edge_percent INT,
  ADD COLUMN majority_members_house INT,
  ADD COLUMN majority_members_senate INT,
  ADD COLUMN minority_members_house INT,
  ADD COLUMN minority_members_senate INT,
  ADD COLUMN single_party_rule INT,
  ADD COLUMN bi_partisan_sponsorship INT,
  ADD COLUMN movement_second_year INT,
  ADD COLUMN house_date_passed DATE,
  ADD COLUMN senate_date_passed DATE,
  ADD COLUMN rules_chair_author INT,
  ADD COLUMN rules_chair_sponsor INT,
  ADD COLUMN minority_leader_sponsor INT,
  ADD COLUMN minority_leader_author INT,
  ADD COLUMN democrat_chairman_sponsors INT,
  ADD COLUMN republican_chairman_sponsors INT,
  ADD COLUMN independent_chairman_sponsors INT,
  ADD COLUMN majority_chairman_sponsors INT,
  ADD COLUMN minority_chairman_sponsors INT,
  ADD COLUMN democrat_chairman_author INT,
  ADD COLUMN republican_chairman_author INT,
  ADD COLUMN independent_chairman_author INT,
  ADD COLUMN majority_chairman_author INT,
  ADD COLUMN minority_chairman_author INT,
  ADD COLUMN days_from_may_submitted INT;



  /* Assign majority_party information */
  UPDATE bills_attributes
  SET gov_party = '0'
  WHERE session_id IN (1);

  UPDATE bills_attributes
  SET gov_party = '1'
  WHERE session_id NOT IN (1);

  UPDATE bills_attributes
  SET majority_party= '0'
  WHERE document_type = 'HB'
    AND session_id IN (1,11);

  UPDATE bills_attributes
  SET majority_party = '1'
  WHERE document_type = 'HB'
    AND session_id IN (14,18,20,21,23,24);

  UPDATE bills_attributes
  SET majority_party = '0'
  WHERE document_type = 'SB'
    AND session_id IN (1);

  UPDATE bills_attributes
  SET  majority_party = '1'
  WHERE document_type = 'SB'
    AND session_id IN (11,14,18,20,21,23,24);

  UPDATE bills_attributes
  SET majority_party_house = IF(session_id IN (1,11),'0','1'),
      majority_party_senate = IF(session_id IN (1),'0','1');


  /*get dem/rep, leadership figures */
  UPDATE bills_attributes a, (
  SELECT bill_id,
          COUNT(*) AS sponsors,
          SUM(IF(l.party = 'Republican' AND sequence=1, 1,IF(l.party = 'Democrat' AND sequence = 1,0,IF(l.party NOT IN ('Democrat','Republican') AND sequence = 1,2,0)))) AS author_party,
          SUM(IF(l.party = 'Republican' AND sequence<>1,1,0)) AS sponsors_republican,
    SUM(IF(l.party = 'Democrat' AND sequence<>1,1,0)) AS sponsors_democrat,
    SUM(IF(l.district_type = 'House' AND sequence<>1,1,0)) AS sponsors_house,
    SUM(IF(l.district_type = 'Senate' AND sequence<>1,1,0)) AS sponsors_senate,
    SUM(IF(l.title IN ('President Pro Tempore','Speaker House of Representatives') AND sequence = 1, 1, 0 )) AS chamber_leader_author,
    SUM(IF(l.title IN ('President Pro Tempore','Speaker House of Representatives') AND sequence <>1, 1, 0 )) AS chamber_leader_sponsor,
    SUM(IF(l.title IS NOT NULL AND sequence = '1' AND party='Republican' AND l.title NOT LIKE '%floor%',1,0)) AS leadership_author_republican,
    SUM(IF(l.title IS NOT NULL AND sequence = '1' AND party='Democrat' AND l.title NOT LIKE '%floor%',1,0)) AS leadership_author_democrat,
          SUM(IF(sequence = '1' AND party NOT IN ('Democrat','Republican'),1,0)) AS author_independent,
    SUM(IF(l.title LIKE '% floor %' AND sequence = 1,1,0)) AS floor_leader_author,
    SUM(IF(l.title LIKE '% floor %' AND sequence <>1,1,0)) AS floor_leader_sponsors,
          SUM(IF(l.title IS NOT NULL AND party = 'Republican' AND sequence <> 1,1,0)) AS leadership_sponsors_republican,
          SUM(IF(l.title IS NOT NULL AND party = 'Democrat' AND sequence <> 1,1,0)) AS leadership_sponsors_democrat,
    SUM(IF(l.title IS NOT NULL AND l.title NOT IN ('President Pro Tempore','Speaker House of Representatives') AND l.title NOT LIKE '% floor %' AND sequence<>1 AND party = 'Republican',1,0)) AS other_leadership_sponsors_republican,
    SUM(IF(l.title IS NOT NULL AND l.title NOT IN ('President Pro Tempore','Speaker House of Representatives') AND l.title NOT LIKE '% floor %' AND sequence<>1 AND party = 'Democrat',1,0)) AS other_leadership_sponsors_democrat,
    SUM(IF(l.title IS NULL AND sequence<>'1' AND party = 'Republican',1,0)) AS other_sponsors_republican,
    SUM(IF(l.title IS NULL AND sequence<>'1' AND party = 'Democrat',1,0)) AS other_sponsors_democrat,
          SUM(IF(sequence<>'1' AND party NOT IN ('Democrat','Republican'),1,0)) AS sponsors_independent
          FROM legislative_services AS l
      JOIN
      (
      SELECT a.bill_id,a.member_id,a.sequence,b.`session_id`
      FROM sponsorships a
      JOIN bills b ON a.bill_id = b.id
      JOIN members m ON a.member_id = m.id
      WHERE b.document_type IN ('HB','SB') AND b.`session_id` IN (1,11,14,18,20,21,23,24)
      GROUP BY a.bill_id,a.`member_id`,a.sequence,b.`session_id`
  ) AS r
  ON r.member_id=l.`member_id`
  AND r.session_id = l.`session_id`
  GROUP BY bill_id
  ) t
  SET a.author_party=t.author_party,
      a.chamber_leader_sponsor = t.chamber_leader_sponsor,
      a.chamber_leader_author = t.chamber_leader_author,
      a.leadership_author_republican=t.leadership_author_republican,
      a.leadership_sponsors_republican=t.leadership_sponsors_republican,
      a.leadership_author_democrat=t.leadership_author_democrat,
      a.leadership_sponsors_democrat=t.leadership_sponsors_democrat,
      a.sponsors = t.sponsors,
      a.sponsors_republican = t.sponsors_republican,
      a.sponsors_democrat = t.sponsors_democrat,
      a.sponsors_house = t.sponsors_house,
      a.sponsors_senate = t.sponsors_senate,
      a.floor_leader_author=t.floor_leader_author,
      a.floor_leader_sponsors=t.floor_leader_sponsors,
      a.other_leadership_sponsors_democrat=t.other_leadership_sponsors_democrat,
      a.other_leadership_sponsors_republican=t.other_leadership_sponsors_republican,
      a.other_sponsors_democrat=t.other_sponsors_democrat,
      a.other_sponsors_republican=t.other_sponsors_republican,
      a.author_independent=t.author_independent,
      a.sponsors_independent=t.sponsors_independent
  WHERE a.`id` = t.bill_id;

  /*convert dem/rep to min/maj */
  UPDATE bills_attributes a, (
  SELECT id,
      DATEDIFF(MAKEDATE((IF(MONTH(date_submitted)>6,YEAR(date_submitted)+1,YEAR(date_submitted))),121),date_submitted) AS days_from_may_submitted,
      IF(IF(MONTH(date_submitted)>6,YEAR(date_submitted)+1,YEAR(date_submitted)) IN ('2000','2004','2008','2012'),1,0) AS leg_election_year,
      IF(IF(MONTH(date_submitted)>6,YEAR(date_submitted)+1,YEAR(date_submitted)) IN ('2002','2006','2010','2014'),1,0) AS gov_election_year,
      IF(MONTH(date_submitted)>6,YEAR(date_submitted)+1,YEAR(date_submitted)) AS leg_year_submitted,
      IF(IF(MONTH(date_submitted)>6,YEAR(date_submitted)+1,YEAR(date_submitted)) IN ('2002','2006','2014'),1,0) AS gov_reelection_year,
      IF(YEAR(max_action_date)>IF(MONTH(date_submitted)>6,YEAR(date_submitted)+1,YEAR(date_submitted)),1,0) AS movement_second_year,
      IF(sponsors_republican>0 AND sponsors_democrat>0,1,0) AS bi_partisan_sponsorship,
      IF(majority_party_senate=majority_party_house AND majority_party_senate=gov_party,1,0) AS single_party_rule,
      IF(author_party=majority_party,1,0) AS majority_party_author,
      IF(majority_party=1,leadership_author_republican,leadership_author_democrat) AS majority_leadership_author,
      IF(majority_party=1,leadership_sponsors_republican,leadership_sponsors_democrat) AS majority_leadership_sponsors,
      IF(majority_party=0,leadership_author_republican,leadership_author_democrat) AS minority_leadership_author,
      IF(majority_party=0,leadership_sponsors_republican,leadership_sponsors_democrat) AS minority_leadership_sponsors,
      IF(majority_party=1,other_leadership_sponsors_republican,other_leadership_sponsors_democrat) AS other_majority_leadership_sponsors,
      IF(majority_party=0,other_leadership_sponsors_republican,other_leadership_sponsors_democrat) AS other_minority_leadership_sponsors,
      IF(majority_party=1,other_sponsors_republican,other_sponsors_democrat) AS other_majority_sponsors,
      IF(majority_party=0,other_sponsors_republican,other_sponsors_democrat) AS other_minority_sponsors,
      IF(majority_party=1,sponsors_republican,sponsors_democrat) AS majority_sponsors,
      IF(majority_party=0,sponsors_republican,sponsors_democrat) AS minority_sponsors
  FROM bills_attributes
  GROUP BY id) t

  SET a.`leg_election_year`=t.leg_election_year,
      a.`gov_election_year`=t.gov_election_year,
      a.days_from_may_submitted=t.days_from_may_submitted,
      a.leg_year_submitted=t.leg_year_submitted,
      a.gov_reelection_year=t.gov_reelection_year,
      a.movement_second_year = t.movement_second_year,
      a.bi_partisan_sponsorship=t.bi_partisan_sponsorship,
      a.single_party_rule=t.single_party_rule,
      a.majority_party_author=t.majority_party_author,
      a.majority_leadership_author=t.majority_leadership_author,
      a.minority_leadership_author=t.minority_leadership_author,
      a.majority_leadership_sponsors=t.majority_leadership_sponsors,
      a.minority_leadership_sponsors=t.minority_leadership_sponsors,
      a.other_majority_leadership_sponsors=t.other_majority_leadership_sponsors,
      a.other_minority_leadership_sponsors=t.other_minority_leadership_sponsors,
      a.other_majority_sponsors=t.other_majority_sponsors,
      a.other_minority_sponsors=t.other_minority_sponsors,
      a.majority_sponsors=t.majority_sponsors,
      a.minority_sponsors=t.minority_sponsors


  WHERE a.id=t.id;


  /*add key leadership author and sponsorship*/
  UPDATE bills_attributes a, (
  SELECT b.id AS id,
  SUM(IF(sl.sequence=1 AND sl.body IN ('house','senate'),1,0)) AS chamber_leader_author,
  SUM(IF(sl.sequence=1 AND sl.body IN ('rules'),1,0)) AS rules_chair_author,
  SUM(IF(sl.sequence<>1 AND sl.body IN ('house','senate'),1,0)) AS chamber_leader_sponsor,
  SUM(IF(sl.sequence<>1 AND sl.body IN ('rules'),1,0)) AS rules_chair_sponsor,
  SUM(IF(sl.sequence=1 AND sl.body IN ('minority'),1,0)) AS minority_leader_author,
  SUM(IF(sl.sequence<>1 AND sl.body IN ('minority'),1,0)) AS minority_leader_sponsor,
  SUM(IF(sl.sequence=1 AND sl.body IN ('floor'),1,0)) AS floor_leader_author,
  SUM(IF(sl.sequence<>1 AND sl.body IN ('floor'),1,0)) AS floor_leader_sponsors
  FROM bills_attributes AS b
  LEFT JOIN
  (SELECT l.leg_year_submitted, l.body, s.*
  FROM sponsorships s
  JOIN leadership_roles_by_year l
  ON s.member_id=l.member_id) AS sl
  ON sl.bill_id=b.id
  AND b.leg_year_submitted=sl.leg_year_submitted
  GROUP BY b.id) t

  SET a.chamber_leader_sponsor=t.chamber_leader_sponsor,
    a.chamber_leader_author=t.chamber_leader_author,
    a.rules_chair_sponsor=t.rules_chair_sponsor,
    a.rules_chair_author=t.rules_chair_author,
    a.minority_leader_author=t.minority_leader_author,
    a.minority_leader_sponsor=t.minority_leader_sponsor,
    a.floor_leader_author=t.floor_leader_author,
    a.floor_leader_sponsors=t.floor_leader_sponsors

  WHERE a.id=t.id;

  /*add other chairman sponsorship information*/

  UPDATE bills_attributes a, (
  SELECT bs.id, SUM(IF(lm.party='Democrat' AND bs.sequence<>1,1,0)) AS democrat_chairman_sponsors,
  SUM(IF(lm.party='Republican' AND bs.sequence<>1,1,0)) AS republican_chairman_sponsors,
  SUM(IF(lm.party NOT IN ('Republican','Democrat') AND bs.sequence<>1,1,0)) AS independent_chairman_sponsors,
  SUM(IF(lm.party='Democrat' AND bs.sequence=1,1,0)) AS democrat_chairman_author,
  SUM(IF(lm.party='Republican' AND bs.sequence=1,1,0)) AS republican_chairman_author,
  SUM(IF(lm.party NOT IN ('Republican','Democrat') AND bs.sequence=1,1,0)) AS independent_chairman_author
  FROM
  (SELECT l.member_id, l.`party`, l.session_id
  FROM member_committees AS m
  JOIN legislative_services AS l
  ON l.`member_id`=m.`member_id`
  AND l.`session_id`=m.session_id
  WHERE m.committee_name NOT IN ('Rules','Administrative Affairs','Assignments')
  AND m.role='Chairman'
  GROUP BY l.member_id, l.party, l.session_id) AS lm
  RIGHT JOIN
  (SELECT b.id, s.sequence, b.session_id, s.member_id
  FROM bills_attributes AS b
  JOIN sponsorships AS s
  ON b.id=s.bill_id) AS bs
  ON bs.session_id=lm.session_id
  AND bs.member_id=lm.member_id
  GROUP BY bs.id
  ) t

  SET a.democrat_chairman_sponsors=t.democrat_chairman_sponsors,
    a.republican_chairman_sponsors=t.republican_chairman_sponsors,
    a.independent_chairman_sponsors=t.independent_chairman_sponsors,
    a.democrat_chairman_author=t.democrat_chairman_author,
    a.republican_chairman_author=t.republican_chairman_author,
    a.independent_chairman_author=t.independent_chairman_author

  WHERE a.id=t.id;

  UPDATE bills_attributes a, (
  SELECT id,
      IF(majority_party=1,republican_chairman_author,democrat_chairman_author) AS majority_chairman_author,
      IF(majority_party=1,republican_chairman_sponsors,democrat_chairman_sponsors) AS majority_chairman_sponsors,
      IF(majority_party=0,republican_chairman_author,democrat_chairman_author) AS minority_chairman_author,
      IF(majority_party=0,republican_chairman_sponsors,democrat_chairman_sponsors) AS minority_chairman_sponsors
      FROM bills_attributes
    GROUP BY id) t

  SET a.majority_chairman_author=t.majority_chairman_author,
    a.majority_chairman_sponsors=t.majority_chairman_sponsors,
    a.minority_chairman_author=t.minority_chairman_author,
    a.minority_chairman_sponsors=t.minority_chairman_sponsors

  WHERE a.id=t.id;


  /* Added more variables for new model */

  ALTER TABLE bills_attributes
  ADD COLUMN min_movement_date_second_year DATETIME,
  ADD COLUMN max_movement_date_second_year DATETIME,
  ADD COLUMN date_out_comm1 DATETIME,
  ADD COLUMN date_out_comm2 DATETIME,
  ADD COLUMN date_pass1 DATETIME,
  ADD COLUMN date_amend DATETIME,
  ADD COLUMN date_pass2 DATETIME,
  ADD COLUMN date_sent_gov DATETIME,
  ADD COLUMN leg_date_submitted DATE,
  ADD COLUMN leg_date_out_comm1 DATE,
  ADD COLUMN leg_date_out_comm2 DATE,
  ADD COLUMN leg_date_pass1 DATE,
  ADD COLUMN leg_date_amend DATE,
  ADD COLUMN leg_date_pass2 DATE,
  ADD COLUMN leg_date_sent_gov DATE,
  ADD COLUMN leg_days_remaining_submitted INT,
  ADD COLUMN leg_days_remaining_out_comm1 INT,
  ADD COLUMN leg_days_remaining_out_comm2 INT,
  ADD COLUMN leg_days_remaining_pass1 INT,
  ADD COLUMN leg_days_remaining_amend INT,
  ADD COLUMN leg_days_remaining_pass2 INT,
  ADD COLUMN leg_days_remaining_sent_gov INT,
  ADD COLUMN leg_day_submitted INT,
  ADD COLUMN leg_day_out_comm1 INT,
  ADD COLUMN leg_day_out_comm2 INT,
  ADD COLUMN leg_day_pass1 INT,
  ADD COLUMN leg_day_amend INT,
  ADD COLUMN leg_day_pass2 INT,
  ADD COLUMN leg_day_sent_gov INT,
  ADD COLUMN passed INT,
  ADD COLUMN passed_year_submitted INT,
  ADD COLUMN crossover_date_first DATE,
  ADD COLUMN crossover_date_second DATE,
  ADD COLUMN chamber_passes INT,
  ADD COLUMN chamber_passes_pre_crossover INT,
  ADD COLUMN local_label INT,
  ADD COLUMN days_from_may_passed_first INT,
  ADD COLUMN days_from_crossover_last_moved INT,
  ADD COLUMN last_moved_pre_crossover DATETIME,
  ADD COLUMN last_precross_move_withdrawn_tabled INT,
  ADD COLUMN last_precross_move_code VARCHAR(50),
  ADD COLUMN committee_1 VARCHAR(255),
  ADD COLUMN committee_2 VARCHAR(255),
  ADD COLUMN category VARCHAR(255),
  ADD COLUMN comm_1_sub INT,
  ADD COLUMN comm_2_sub INT,
  ADD COLUMN yeas_pass1 INT,
  ADD COLUMN nays_pass1 INT,
  ADD COLUMN excused_pass1 INT,
  ADD COLUMN not_voting_pass1 INT,
  ADD COLUMN yeas_amend INT,
  ADD COLUMN nays_amend INT,
  ADD COLUMN excused_amend INT,
  ADD COLUMN not_voting_amend INT,
  ADD COLUMN yeas_pass1_percent DECIMAL(10,9),
  ADD COLUMN nays_pass1_percent DECIMAL(10,9),
  ADD COLUMN excused_pass1_percent DECIMAL(10,9),
  ADD COLUMN not_voting_pass1_percent DECIMAL(10,9),
  ADD COLUMN yeas_amend_percent DECIMAL(10,9),
  ADD COLUMN nays_amend_percent DECIMAL(10,9),
  ADD COLUMN excused_amend_percent DECIMAL(10,9),
  ADD COLUMN not_voting_amend_percent DECIMAL(10,9);


/*creates variable for local_label*/
  UPDATE bills_attributes a, (
  SELECT b.id, IF(b.`legislation_type`='LOC',1,0) AS local_label
  FROM bills b
  JOIN bills_attributes ba
  ON ba.id=b.`id`
  ) t

  SET a.local_label=t.local_label

  WHERE a.id=t.id;


/*OLD VARIABLE: MIGHT DELETE*/

  UPDATE bills_attributes a, (
  SELECT ba.id, MIN(c.date_year_submitted) AS crossover_date_first, MAX(c.date_year_submitted) AS crossover_date_second
  FROM bills_attributes ba
  JOIN crossover_day c
  ON c.session_id=ba.`session_id`
  GROUP BY ba.id) t

  SET a.crossover_date_first=t.crossover_date_first,
      a.crossover_date_second=t.crossover_date_second

  WHERE a.id=t.id;



/*OLD VARIABLE: MIGHT DELETE*/

  UPDATE bills_attributes a, (
  SELECT ba.id,
    MIN(status_date) AS min_movement_date_second_year,
    MAX(status_date) AS max_movement_date_second_year
  FROM bill_status_listings bsl
  JOIN bills_attributes ba
  ON ba.id=bsl.`bill_id`
  WHERE DATE(status_date)<=ba.crossover_date_second
  AND CODE NOT IN ('HSG','SSG','Signed Gov','EFF')
  AND YEAR(status_date)>leg_year_submitted
  GROUP BY ba.id) t

  SET a.min_movement_date_second_year=t.min_movement_date_second_year,
      a.max_movement_date_second_year=t.max_movement_date_second_year

  WHERE a.id=t.id;


/*KEY VARIABLES: Dates for major bill stages*/

 UPDATE bills_attributes a, (
 SELECT id,
        IF(IF(pass_non_amend_date IS NOT NULL,pass_non_amend_date,IF(approve_non_amend_date IS NOT NULL,approve_non_amend_date,
	    IF(conference_date IS NOT NULL AND conference>1,conference_date,IF(recedes_date IS NOT NULL,recedes_date,NULL)))) IS NOT NULL,1,0) AS passed,
        IF(YEAR(IF(pass_non_amend_date IS NOT NULL,pass_non_amend_date,IF(approve_non_amend_date IS NOT NULL,approve_non_amend_date,
	    IF(conference_date IS NOT NULL AND conference>1,conference_date,IF(recedes_date IS NOT NULL,recedes_date,NULL))))) = leg_year_submitted,1,0) AS passed_year_submitted,    
	date_submitted,
	date_out_comm1,
	date_pass1,
	date_out_comm2,
	IF(date_amend IS NOT NULL,date_amend,NULL) AS date_amend,
	IF(pass_non_amend_date IS NOT NULL,pass_non_amend_date,IF(approve_non_amend_date IS NOT NULL,approve_non_amend_date,
	    IF(conference_date IS NOT NULL AND conference>1,conference_date,IF(recedes_date IS NOT NULL,recedes_date,NULL)))) AS date_pass2,
	date_sent_gov

FROM
(SELECT b.id,ba.`leg_year_submitted`,ba.`document_type`,ba.`number`,ba.`passed`,
SUM(IF(bsl.code IN ('HCFR','SCFR') AND LEFT(bsl.document_type,1)=LEFT(bsl.code,1),1,0)) AS out_comm1,
SUM(IF(bsl.code IN ('HCFR','SCFR') AND LEFT(bsl.document_type,1)<>LEFT(bsl.code,1),1,0)) AS out_comm2,
SUM(IF(bsl.code IN ('HPA','SPA','HRECP','SRECP') AND LEFT(bsl.document_type,1)=LEFT(bsl.code,1),1,0)) AS pass_non_amend_first_chamber,
SUM(IF(bsl.code IN ('HPA','SPA','HRECP','SRECP') AND LEFT(bsl.document_type,1)<>LEFT(bsl.code,1) AND bsl.am_sub IS NULL,1,0)) AS pass_non_amend,
SUM(IF(bsl.code IN ('HPA','SPA','HRECP','SRECP') AND (bsl.`description` NOT LIKE '%as amend%' AND bsl.`description` NOT LIKE '%by sub%') AND bsl.am_sub IS NOT NULL,1,0)) AS pass_non_amend_desc,
SUM(IF(bsl.code IN ('HASAS','SAHAS') AND bsl.am_sub IS NULL,1,0)) AS approve_non_amend,
SUM(IF(bsl.code IN ('HASAS','SAHAS') AND (bsl.`description` NOT LIKE '%as amend%' AND bsl.`description` NOT LIKE '%by sub%'),1,0)) AS approve_non_amend_desc,
SUM(IF(bsl.code IN ('HCA','SCRA'),1,0)) AS conference,
SUM(IF(bsl.code IN ('HRP','SREC'),1,0)) AS recedes,
MAX(IF(bsl.code IN ('HCFR','SCFR') AND LEFT(bsl.document_type,1)=LEFT(bsl.code,1),bsl.`status_date`,NULL)) AS date_out_comm1,
MAX(IF(bsl.code IN ('HCFR','SCFR') AND LEFT(bsl.document_type,1)<>LEFT(bsl.code,1),bsl.`status_date`,NULL)) AS date_out_comm2,
MAX(IF(bsl.code IN ('HPA','SPA','HRECP','SRECP') AND LEFT(bsl.document_type,1)=LEFT(bsl.code,1),bsl.`status_date`,NULL)) AS date_pass1,
MAX(IF(bsl.code IN ('HPA','SPA','HRECP','SRECP') AND LEFT(bsl.document_type,1)<>LEFT(bsl.code,1) AND bsl.am_sub IS NULL,bsl.`status_date`,NULL)) AS pass_non_amend_date,
MAX(IF(bsl.code IN ('HPA','SPA','HRECP','SRECP') AND LEFT(bsl.document_type,1)<>LEFT(bsl.code,1) AND bsl.am_sub IS NOT NULL,bsl.`status_date`,NULL)) AS date_amend,
MAX(IF(bsl.code IN ('HASAS','SAHAS') AND bsl.am_sub IS NULL,bsl.status_date,NULL)) AS approve_non_amend_date,
MAX(IF(bsl.code IN ('HCA','SCRA'),bsl.status_date,NULL)) AS conference_date,
MAX(IF(bsl.code IN ('HRP','SREC'),bsl.status_date,NULL)) AS recedes_date,
MIN(IF(bsl.code IN ('SSG','HSG','HDSG','SDSG'),bsl.status_date,NULL)) AS date_sent_gov,
MIN(bsl.status_date) AS date_submitted
FROM bills_attributes ba
JOIN bills b
ON ba.id=b.`id`
JOIN bill_status_listings bsl
ON bsl.`bill_id`=ba.`id`
WHERE leg_year_submitted
GROUP BY b.id,ba.`leg_year_submitted`,ba.`document_type`,ba.`number`,ba.`passed`) pass_status_dates) t

  SET a.passed=t.passed,
      a.passed_year_submitted=t.passed_year_submitted,
      a.date_submitted=t.date_submitted,
      a.date_out_comm1=t.date_out_comm1,
      a.date_out_comm2=t.date_out_comm2,
      a.date_pass1=t.date_pass1,
      a.date_pass2=t.date_pass2,
      a.date_amend=t.date_amend,
      a.date_sent_gov=t.date_sent_gov


  WHERE a.id=t.id;


/*OLD VARIABLE: MIGHT DELETE*/

  UPDATE bills_attributes
  SET chamber_passes=0
  WHERE chamber_passes IS NULL;

/*OLD VARIABLES: MIGHT DELETE*/

  UPDATE bills_attributes a, (
  SELECT id,
      DATEDIFF(MAKEDATE(YEAR(date_pass1),121),date_pass1) AS days_from_may_passed_first


  FROM bills_attributes
  GROUP BY id) t

  SET a.days_from_may_passed_first=t.days_from_may_passed_first

  WHERE a.id=t.id;

  UPDATE bills_attributes a, (
  SELECT ba.id,
    COUNT(*) AS chamber_passes_pre_crossover
  FROM bill_status_listings bsl
  JOIN bills_attributes ba
  ON ba.id=bsl.`bill_id`
  WHERE CODE IN ('HPA','SPA','HRECP','SRECP')
  AND DATE(bsl.status_date)<=DATE(ba.crossover_date_second)
  GROUP BY ba.id) t

  SET a.chamber_passes_pre_crossover=t.chamber_passes_pre_crossover


  WHERE a.id=t.id;

  UPDATE bills_attributes
  SET chamber_passes_pre_crossover=0
  WHERE chamber_passes_pre_crossover IS NULL;


  UPDATE bills_attributes a, (
  SELECT ba.id,
    MAX(status_date) AS last_moved_pre_crossover

  FROM bill_status_listings bsl
  JOIN bills_attributes ba
  ON ba.id=bsl.`bill_id`
  WHERE  DATE(bsl.status_date)<=DATE(ba.crossover_date_second)
  GROUP BY ba.id) t

  SET a.last_moved_pre_crossover=t.last_moved_pre_crossover

  WHERE a.id=t.id;



  UPDATE bills_attributes a, (
  SELECT id,
      DATEDIFF(crossover_date_second,last_moved_pre_crossover) AS days_from_crossover_last_moved


  FROM bills_attributes
  GROUP BY id) t

  SET a.days_from_crossover_last_moved=t.days_from_crossover_last_moved

  WHERE a.id=t.id;


  UPDATE bills_attributes a, (
  SELECT t.id, CODE AS last_precross_move_code,
  IF(description LIKE '%withdraw%' OR description LIKE '%table%',1,0) AS last_precross_move_withdrawn_tabled
  FROM bill_status_listings bsl
  JOIN
  (SELECT ba.id, passed, ba.`session_id`,
    MAX(status_date) AS last_moved_pre_crossover

  FROM bill_status_listings bsl
  JOIN bills_attributes ba
  ON ba.id=bsl.`bill_id`
  WHERE  DATE(bsl.status_date)<=DATE(ba.crossover_date_second)
  GROUP BY ba.id) t
  ON t.id=bsl.`bill_id`
  AND t.last_moved_pre_crossover=bsl.`status_date`
  WHERE CODE NOT IN ('Signed Gov','HSG','SSG')) t

  SET a.last_precross_move_withdrawn_tabled=t.last_precross_move_withdrawn_tabled,
      a.last_precross_move_code=t.last_precross_move_code

  WHERE a.id=t.id;
  


/*KEY VARIABLES: DAYS FOR MAJOR STATUS CHANGES*/


UPDATE bills_attributes a, (
SELECT id,ld.`status_date`,ld.`leg_days_remaining`,ld.`leg_day`
FROM bills_attributes ba
LEFT JOIN legislative_days_historical ld
ON DATE(ba.date_submitted)=ld.`status_date`
AND ld.on_calendar<>2) t

SET a.leg_date_submitted=t.status_date,
    a.leg_days_remaining_submitted=t.leg_days_remaining,
    a.leg_day_submitted=t.leg_day
    
WHERE a.id=t.id;

UPDATE bills_attributes a, (
SELECT id,ld.`status_date`,ld.`leg_days_remaining`,ld.`leg_day`
FROM bills_attributes ba
LEFT JOIN legislative_days_historical ld
ON DATE(ba.date_out_comm1)=ld.`status_date`
AND ld.on_calendar<>2) t

SET a.leg_date_out_comm1=t.status_date,
    a.leg_days_remaining_out_comm1=t.leg_days_remaining,
    a.leg_day_out_comm1=t.leg_day
    
WHERE a.id=t.id;


UPDATE bills_attributes a, (
SELECT id,ld.`status_date`,ld.`leg_days_remaining`,ld.`leg_day`
FROM bills_attributes ba
LEFT JOIN legislative_days_historical ld
ON DATE(ba.date_out_comm2)=ld.`status_date`
AND ld.on_calendar<>2) t

SET a.leg_date_out_comm2=t.status_date,
    a.leg_days_remaining_out_comm2=t.leg_days_remaining,
    a.leg_day_out_comm2=t.leg_day
    
WHERE a.id=t.id;

UPDATE bills_attributes a, (
SELECT id,ld.`status_date`,ld.`leg_days_remaining`,ld.`leg_day`
FROM bills_attributes ba
LEFT JOIN legislative_days_historical ld
ON DATE(ba.date_pass1)=ld.`status_date`
AND ld.on_calendar<>2) t

SET a.leg_date_pass1=t.status_date,
    a.leg_days_remaining_pass1=t.leg_days_remaining,
    a.leg_day_pass1=t.leg_day
    
WHERE a.id=t.id;


UPDATE bills_attributes a, (
SELECT id,ld.`status_date`,ld.`leg_days_remaining`,ld.`leg_day`
FROM bills_attributes ba
LEFT JOIN legislative_days_historical ld
ON DATE(ba.date_pass2)=ld.`status_date`
AND ld.on_calendar<>2) t

SET a.leg_date_pass2=t.status_date,
    a.leg_days_remaining_pass2=t.leg_days_remaining,
    a.leg_day_pass2=t.leg_day
    
WHERE a.id=t.id;


UPDATE bills_attributes a, (
SELECT id,ld.`status_date`,ld.`leg_days_remaining`,ld.`leg_day`
FROM bills_attributes ba
LEFT JOIN legislative_days_historical ld
ON DATE(ba.date_amend)=ld.`status_date`
AND ld.on_calendar<>2) t

SET a.leg_date_amend=t.status_date,
    a.leg_days_remaining_amend=t.leg_days_remaining,
    a.leg_day_amend=t.leg_day
    
WHERE a.id=t.id;


UPDATE bills_attributes a, (
SELECT id,ld.`status_date`,ld.`leg_days_remaining`,ld.`leg_day`
FROM bills_attributes ba
LEFT JOIN legislative_days_historical ld
ON DATE(ba.date_sent_gov)=ld.`status_date`
AND ld.on_calendar<>2) t

SET a.leg_date_sent_gov=t.status_date,
    a.leg_days_remaining_sent_gov=t.leg_days_remaining,
    a.leg_day_sent_gov=t.leg_day
    
WHERE a.id=t.id;



UPDATE bills_attributes a, (
SELECT id,IF(pre_file_correction>0,leg_days_remaining+1,leg_days_remaining) AS leg_days_remaining_submitted,leg_day-pre_file_correction AS leg_day_submitted, set_date_submitted AS leg_date_submitted
FROM
(
SELECT ba.id,ba.date_submitted,

IF(ba.`date_submitted`<MIN(ld.status_date),MIN(ld.status_date),MAX(IF(ld.status_date<ba.date_submitted,ld.status_date,NULL))) AS set_date_submitted,
IF(ba.`date_submitted`<MIN(ld.status_date) and ba.leg_year_submitted=2005,2,IF(ba.`date_submitted`<MIN(ld.status_date),1,0)) as pre_file_correction
FROM bills_attributes ba
JOIN legislative_days_historical ld
ON ld.`leg_year_submitted`=ba.`leg_year_submitted`
WHERE ba.`date_submitted` IS NOT NULL
AND ba.`leg_date_submitted` IS NULL
AND session_id>11
AND ld.on_calendar <> 2
GROUP BY ba.id,ba.`date_submitted`) date_fix
JOIN legislative_days_historical ld
ON ld.`status_date`=date_fix.set_date_submitted
where ld.on_calendar <> 2) t

SET a.leg_date_submitted=t.leg_date_submitted,
    a.leg_days_remaining_submitted=t.leg_days_remaining_submitted,
    a.leg_day_submitted=t.leg_day_submitted
    
WHERE a.id=t.id;



UPDATE bills_attributes a, (
SELECT id,IF(pre_file_correction>0,leg_days_remaining+1,leg_days_remaining) AS leg_days_remaining_out_comm1,leg_day-pre_file_correction AS leg_day_out_comm1, set_date_out_comm1 AS leg_date_out_comm1
FROM
(
SELECT ba.id,ba.date_out_comm1,

IF(ba.`date_out_comm1`<MIN(ld.status_date),MIN(ld.status_date),MAX(IF(ld.status_date<ba.date_out_comm1,ld.status_date,NULL))) AS set_date_out_comm1,
IF(ba.`date_out_comm1`<MIN(ld.status_date) and ba.leg_year_submitted=2005,2,IF(ba.`date_out_comm1`<MIN(ld.status_date),1,0)) as pre_file_correction
FROM bills_attributes ba
JOIN legislative_days_historical ld
ON ld.`leg_year_submitted`=ba.`leg_year_submitted`
WHERE ba.`date_out_comm1` IS NOT NULL
AND ba.`leg_date_out_comm1` IS NULL
AND session_id>11
AND ld.on_calendar <> 2
GROUP BY ba.id,ba.`date_out_comm1`) date_fix
JOIN legislative_days_historical ld
ON ld.`status_date`=date_fix.set_date_out_comm1
where ld.on_calendar <> 2) t

SET a.leg_date_out_comm1=t.leg_date_out_comm1,
    a.leg_days_remaining_out_comm1=t.leg_days_remaining_out_comm1,
    a.leg_day_out_comm1=t.leg_day_out_comm1
    
WHERE a.id=t.id;


UPDATE bills_attributes a, (
SELECT id,IF(pre_file_correction>0,leg_days_remaining+1,leg_days_remaining) AS leg_days_remaining_out_comm2,leg_day-pre_file_correction AS leg_day_out_comm2, set_date_out_comm2 AS leg_date_out_comm2
FROM
(
SELECT ba.id,ba.date_out_comm2,

IF(ba.`date_out_comm2`<MIN(ld.status_date),MIN(ld.status_date),MAX(IF(ld.status_date<ba.date_out_comm2,ld.status_date,NULL))) AS set_date_out_comm2,
IF(ba.`date_out_comm2`<MIN(ld.status_date) and ba.leg_year_submitted=2005,2,IF(ba.`date_out_comm2`<MIN(ld.status_date),1,0)) as pre_file_correction
FROM bills_attributes ba
JOIN legislative_days_historical ld
ON ld.`leg_year_submitted`=ba.`leg_year_submitted`
WHERE ba.`date_out_comm2` IS NOT NULL
AND ba.`leg_date_out_comm2` IS NULL
AND session_id>11
AND ld.on_calendar <> 2
GROUP BY ba.id,ba.`date_out_comm2`) date_fix
JOIN legislative_days_historical ld
ON ld.`status_date`=date_fix.set_date_out_comm2
where ld.on_calendar <> 2) t

SET a.leg_date_out_comm2=t.leg_date_out_comm2,
    a.leg_days_remaining_out_comm2=t.leg_days_remaining_out_comm2,
    a.leg_day_out_comm2=t.leg_day_out_comm2
    
WHERE a.id=t.id;




/*NOT CURRENTLY USED VARIABLES: COMMITTEES*/

UPDATE bills_attributes a, (
SELECT b.id,
LOWER(MAX(IF(committee_type='House' AND b.`document_type`='HB',NAME,IF(committee_type='Senate' AND b.`document_type`='SB',NAME,NULL)))) AS committee_1,
LOWER(MAX(IF(committee_type='House' AND b.`document_type`='SB',NAME,IF(committee_type='Senate' AND b.`document_type`='HB',NAME,NULL)))) AS committee_2
FROM refined_bills_committees bc
JOIN bills b
ON b.id=bc.`bill_id`
WHERE document_type IN ('HB','SB')
GROUP BY b.id
) t

  SET a.committee_1=t.committee_1,
      a.committee_2=t.committee_2
  WHERE a.id=t.id;




UPDATE bills_attributes a, (  
SELECT ba.`id`,SUM(IF(LEFT(bsl.`code`,1)=LEFT(ba.`document_type`,1) AND am_sub IS NOT NULL,1,0)) AS comm_1_sub,
SUM(IF(LEFT(bsl.`code`,1)<>LEFT(ba.`document_type`,1) AND am_sub IS NOT NULL,1,0)) AS comm_2_sub
FROM bills_attributes ba
JOIN bill_status_listings bsl
ON ba.id=bsl.`bill_id`
WHERE bsl.`code` IN ('HCFR','SCFR')
GROUP BY 1) t

  SET a.comm_1_sub=t.comm_1_sub,
      a.comm_2_sub=t.comm_2_sub
  WHERE a.id=t.id;
  
  
/*CATEGORIES: POSSIBLY USEFUL LATER*/
  
-- UPDATE bills_attributes a, (
-- SELECT ba.id,c.category
-- FROM bills_attributes ba
-- JOIN categories c
-- ON REPLACE(c.`bill_id`,'\n',"")=ba.`id`
-- WHERE session_id>=14) t
-- 
-- SET a.category=t.category
-- 
-- WHERE a.id=t.id;



/*KEY VARIABLES: VOTES*/

UPDATE bills_attributes a, (
SELECT ba.bill_id,ba.`document_type`,ba.`number`,
SUM(IF(vote='pass1',v.yeas,0)) AS yeas_pass1,
SUM(IF(vote='pass1',v.nays,0)) AS nays_pass1,
SUM(IF(vote='pass1',v.excused,0)) AS excused_pass1,
SUM(IF(vote='pass1',v.not_voting,0)) AS not_voting_pass1,
SUM(IF(vote='amend',v.yeas,0)) AS yeas_amend,
SUM(IF(vote='amend',v.nays,0)) AS nays_amend,
SUM(IF(vote='amend',v.excused,0)) AS excused_amend,
SUM(IF(vote='amend',v.not_voting,0)) AS not_voting_amend,
COUNT(*)
FROM votes v
JOIN bills_votes bv
ON v.`id`=bv.`vote_id`
JOIN
(SELECT bv.`bill_id`,ba.`document_type`,ba.`number`,ba.`date_pass1`,ba.`date_amend`,ba.`date_pass2`,v.`branch`, 'pass1' AS vote, MAX(v.vote_date) AS vote_timing
FROM bills_votes bv
JOIN bills_attributes ba
ON bv.`bill_id`=ba.`id`
JOIN votes v
ON bv.`vote_id`=v.`id`
AND DATE(v.`vote_date`)=DATE(ba.`date_pass1`)
WHERE ba.session_id >=14
AND (v.caption IS NULL OR
    (LOWER(v.`caption`) NOT LIKE '%table%'
    AND LOWER(v.`caption`) NOT LIKE '%adopt%'
    AND LOWER(v.`caption`) NOT LIKE '%recom%'
    AND LOWER(v.`caption`) NOT LIKE '%agree%'
    AND LOWER(v.caption) NOT LIKE '%recon%'
    AND LOWER(v.caption) NOT LIKE '%trans%'
    AND LOWER(v.caption) NOT LIKE '%suspend%'))
AND LEFT(ba.`document_type`,1)=LEFT(v.`branch`,1)
GROUP BY bv.`bill_id`,ba.`document_type`,ba.`number`,ba.`date_pass1`,ba.`date_amend`,ba.`date_pass2`,v.`branch`

UNION ALL

SELECT bv.`bill_id`,ba.`document_type`,ba.`number`,ba.`date_pass1`,ba.`date_amend`,ba.`date_pass2`,v.`branch`, 'amend' AS vote, MAX(v.vote_date) AS vote_timing
FROM bills_votes bv
JOIN bills_attributes ba
ON bv.`bill_id`=ba.`id`
JOIN votes v
ON bv.`vote_id`=v.`id`
AND DATE(v.`vote_date`)=DATE(ba.`date_amend`)
AND ba.session_id >=14
AND (v.caption IS NULL OR
    (LOWER(v.`caption`) NOT LIKE '%table%'
    AND LOWER(v.`caption`) NOT LIKE '%adopt%'
    AND LOWER(v.`caption`) NOT LIKE '%recom%'
    AND LOWER(v.`caption`) NOT LIKE '%agree%'
    AND LOWER(v.caption) NOT LIKE '%recon%'
    AND LOWER(v.caption) NOT LIKE '%trans%'
    AND LOWER(v.caption) NOT LIKE '%suspend%'))
AND LEFT(ba.`document_type`,1)<>LEFT(v.`branch`,1)
GROUP BY bv.`bill_id`,ba.`document_type`,ba.`number`,ba.`date_pass1`,ba.`date_amend`,ba.`date_pass2`,v.`branch`) ba


ON ba.bill_id=bv.`bill_id`
AND ba.vote_timing=v.vote_date
WHERE (v.caption IS NULL OR (LOWER(v.`caption`) NOT LIKE '%table%' AND LOWER(v.`caption`) NOT LIKE '%adopt%' AND LOWER(v.`caption`) NOT LIKE '%recom%' AND LOWER(v.`caption`) NOT LIKE '%agree%' AND LOWER(v.caption) NOT LIKE '%recon%' AND LOWER(v.caption) NOT LIKE '%recom%'))
GROUP BY 1) t

SET a.yeas_pass1 = t.yeas_pass1,
  a.nays_pass1 = t.nays_pass1,
  a.excused_pass1 = t.excused_pass1,
  a.not_voting_pass1 = t.not_voting_pass1,
  a.yeas_amend = t.yeas_amend,
  a.nays_amend = t.nays_amend,
  a.excused_amend = t.excused_amend,
  a.not_voting_amend = t.not_voting_amend
  
WHERE a.id=t.bill_id;


UPDATE bills_attributes a, (
SELECT id,document_type,t.number,date_pass1,date_amend,date_pass2,
SUM(IF(LEFT(document_type,1)=LEFT(branch,1) AND caption NOT LIKE '%am%' AND IF(document_type='HB' AND yeas>=90,1,IF(document_type='SB' AND yeas>=26,1,0))=1,yeas,0)) AS yeas_pass1,
SUM(IF(LEFT(document_type,1)=LEFT(branch,1) AND caption NOT LIKE '%am%' AND IF(document_type='HB' AND yeas>=90,1,IF(document_type='SB' AND yeas>=26,1,0))=1,nays,0)) AS nays_pass1,
SUM(IF(LEFT(document_type,1)=LEFT(branch,1) AND caption NOT LIKE '%am%' AND IF(document_type='HB' AND yeas>=90,1,IF(document_type='SB' AND yeas>=26,1,0))=1,excused,0)) AS excused_pass1,
SUM(IF(LEFT(document_type,1)=LEFT(branch,1) AND caption NOT LIKE '%am%' AND IF(document_type='HB' AND yeas>=90,1,IF(document_type='SB' AND yeas>=26,1,0))=1,not_voting,0)) AS not_voting_pass1
FROM
(SELECT t.*,v.branch,v.`caption`,v.`vote_date`,v.yeas,v.`nays`,v.excused,v.`not_voting`
FROM
(SELECT ba.id,ba.document_type,ba.`number`,ba.date_pass1,ba.date_amend,ba.`date_pass2`
FROM bills_attributes ba
LEFT JOIN
(
SELECT ba.bill_id,ba.`document_type`,ba.`number`,
SUM(IF(vote='pass1',v.yeas,0)) AS yeas_pass1,
SUM(IF(vote='pass1',v.nays,0)) AS nays_pass1,
SUM(IF(vote='pass1',v.excused,0)) AS excused_pass1,
SUM(IF(vote='pass1',v.not_voting,0)) AS not_voting_pass1,
SUM(IF(vote='amend',v.yeas,0)) AS yeas_amend,
SUM(IF(vote='amend',v.nays,0)) AS nays_amend,
SUM(IF(vote='amend',v.excused,0)) AS excused_amend,
SUM(IF(vote='amend',v.not_voting,0)) AS not_voting_amend,
COUNT(*)
FROM votes v
JOIN bills_votes bv
ON v.`id`=bv.`vote_id`
JOIN
(SELECT bv.`bill_id`,ba.`document_type`,ba.`number`,ba.`date_pass1`,ba.`date_amend`,ba.`date_pass2`,v.`branch`, 'pass1' AS vote, MAX(v.vote_date) AS vote_timing
FROM bills_votes bv
JOIN bills_attributes ba
ON bv.`bill_id`=ba.`id`
JOIN votes v
ON bv.`vote_id`=v.`id`
AND DATE(v.`vote_date`)=DATE(ba.`date_pass1`)
WHERE ba.`session_id`<24
AND ba.session_id >11
AND (v.caption IS NULL OR (LOWER(v.`caption`) NOT LIKE '%table%' AND LOWER(v.`caption`) NOT LIKE '%adopt%' AND LOWER(v.`caption`) NOT LIKE '%recom%' AND LOWER(v.`caption`) NOT LIKE '%agree%'  AND LOWER(v.caption) NOT LIKE '%recon%'))
GROUP BY bv.`bill_id`,ba.`document_type`,ba.`number`,ba.`date_pass1`,ba.`date_amend`,ba.`date_pass2`,v.`branch`

UNION ALL

SELECT bv.`bill_id`,ba.`document_type`,ba.`number`,ba.`date_pass1`,ba.`date_amend`,ba.`date_pass2`,v.`branch`, 'amend' AS vote, MAX(v.vote_date) AS vote_timing
FROM bills_votes bv
JOIN bills_attributes ba
ON bv.`bill_id`=ba.`id`
JOIN votes v
ON bv.`vote_id`=v.`id`
AND DATE(v.`vote_date`)=DATE(ba.`date_amend`)
WHERE ba.`session_id`<24
AND ba.session_id >11
AND (v.caption IS NULL OR (LOWER(v.`caption`) NOT LIKE '%table%' AND LOWER(v.`caption`) NOT LIKE '%adopt%' AND LOWER(v.`caption`) NOT LIKE '%recom%' AND LOWER(v.`caption`) NOT LIKE '%agree%' AND LOWER(v.caption) NOT LIKE '%recon%' AND LOWER(v.caption) NOT LIKE '%recom%'))
AND LEFT(ba.`document_type`,1)<>LEFT(v.`branch`,1)
GROUP BY bv.`bill_id`,ba.`document_type`,ba.`number`,ba.`date_pass1`,ba.`date_amend`,ba.`date_pass2`,v.`branch`) ba
ON ba.bill_id=bv.`bill_id`
AND ba.vote_timing=v.vote_date
WHERE (v.caption IS NULL OR (LOWER(v.`caption`) NOT LIKE '%table%' AND LOWER(v.`caption`) NOT LIKE '%adopt%' AND LOWER(v.`caption`) NOT LIKE '%recom%' AND LOWER(v.`caption`) NOT LIKE '%agree%' AND LOWER(v.caption) NOT LIKE '%recon%' AND LOWER(v.caption) NOT LIKE '%recom%'))
GROUP BY 1
LIMIT 500000) t
ON ba.`id`=t.bill_id
WHERE ba.date_pass1 IS NOT NULL
AND ba.`session_id` >=14
AND t.bill_id IS NULL OR t.yeas_pass1=0
) t
LEFT JOIN bills_votes bv
ON t.id=bv.`bill_id`
LEFT JOIN votes v
ON bv.vote_id=v.id
WHERE (v.caption IS NULL OR (LOWER(v.caption) NOT LIKE '%table%' AND LOWER(v.caption) NOT LIKE '%adopt%' AND LOWER(v.caption) NOT LIKE '%recom%' AND LOWER(v.caption) NOT LIKE '%agree%' AND LOWER(v.caption) NOT LIKE '%recon%'))
ORDER BY t.id DESC,vote_date ASC) t
GROUP BY id,document_type,t.number,date_pass1,date_amend,date_pass2) t

SET a.yeas_pass1 = t.yeas_pass1,
  a.nays_pass1 = t.nays_pass1,
  a.excused_pass1 = t.excused_pass1,
  a.not_voting_pass1 = t.not_voting_pass1
  
WHERE a.id=t.id;


update bills_attributes a, (
select *
from bills_attributes ba
where ba.`yeas_pass1` is null
and ba.date_pass1 is not null
and session_id >= 14) t

SET a.yeas_pass1=0,
    a.nays_pass1=0,
    a.excused_pass1=0,
    a.`not_voting_pass1`=0
    
where a.id=t.id;

UPDATE bills_attributes a, (
SELECT t.id AS bill_id,
SUM(IF(LEFT(document_type,1)<>LEFT(branch,1)
    AND (v.caption IS NULL OR
    (LOWER(v.`caption`) NOT LIKE '%table%'
    AND LOWER(v.`caption`) NOT LIKE '%adopt%'
    AND LOWER(v.`caption`) NOT LIKE '%recom%'
    AND LOWER(v.`caption`) NOT LIKE '%agree%'
    AND LOWER(v.caption) NOT LIKE '%recon%'
    AND LOWER(v.caption) NOT LIKE '%trans%'
    AND LOWER(v.caption) NOT LIKE '%suspend%')),v.yeas,0)) AS yeas_amend,
SUM(IF(LEFT(document_type,1)<>LEFT(branch,1)
    AND (v.caption IS NULL OR
    (LOWER(v.`caption`) NOT LIKE '%table%'
    AND LOWER(v.`caption`) NOT LIKE '%adopt%'
    AND LOWER(v.`caption`) NOT LIKE '%recom%'
    AND LOWER(v.`caption`) NOT LIKE '%agree%'
    AND LOWER(v.caption) NOT LIKE '%recon%'
    AND LOWER(v.caption) NOT LIKE '%trans%'
    AND LOWER(v.caption) NOT LIKE '%suspend%')),v.nays,0)) AS nays_amend,
SUM(IF(LEFT(document_type,1)<>LEFT(branch,1)
    AND (v.caption IS NULL OR
    (LOWER(v.`caption`) NOT LIKE '%table%'
    AND LOWER(v.`caption`) NOT LIKE '%adopt%'
    AND LOWER(v.`caption`) NOT LIKE '%recom%'
    AND LOWER(v.`caption`) NOT LIKE '%agree%'
    AND LOWER(v.caption) NOT LIKE '%recon%'
    AND LOWER(v.caption) NOT LIKE '%trans%'
    AND LOWER(v.caption) NOT LIKE '%suspend%')),v.not_voting,0)) AS not_voting_amend,
SUM(IF(LEFT(document_type,1)<>LEFT(branch,1)
    AND (v.caption IS NULL OR
    (LOWER(v.`caption`) NOT LIKE '%table%'
    AND LOWER(v.`caption`) NOT LIKE '%adopt%'
    AND LOWER(v.`caption`) NOT LIKE '%recom%'
    AND LOWER(v.`caption`) NOT LIKE '%agree%'
    AND LOWER(v.caption) NOT LIKE '%recon%'
    AND LOWER(v.caption) NOT LIKE '%trans%'
    AND LOWER(v.caption) NOT LIKE '%suspend%')),v.excused,0)) AS excused_amend 
FROM
(SELECT *
FROM bills_attributes ba
WHERE (ba.`yeas_amend` IS NULL
OR IF(ba.`document_type`='SB' AND ba.`yeas_amend`<90,1,IF(ba.`document_type`='HB' AND ba.`yeas_amend`<26,1,0))=1
OR yeas_amend=0)
AND ba.date_amend IS NOT NULL
AND session_id >=14) t
LEFT JOIN bills_votes bv
ON t.id=bv.bill_id
LEFT JOIN votes v
ON bv.vote_id=v.id
GROUP BY 1) t

SET a.`yeas_amend`=t.yeas_amend,
    a.`nays_amend`=t.nays_amend,
    a.`not_voting_amend`=t.not_voting_amend,
    a.`excused_amend`=t.excused_amend
    
WHERE a.`id`=t.bill_id;


UPDATE bills_attributes a, (
SELECT ba.`id`,
IF(DATE(ba.date_pass1) IS NOT NULL,
	IF(yeas_pass1>0 AND yeas_pass1 IS NOT NULL,yeas_pass1/(yeas_pass1+nays_pass1+excused_pass1+not_voting_pass1),avg_yeas_pass1_percent),0)
AS yeas_pass1_percent,
IF(DATE(ba.date_amend) IS NOT NULL,
	IF(yeas_amend>0 AND yeas_amend IS NOT NULL,yeas_amend/(yeas_amend+nays_amend+excused_amend+not_voting_amend),avg_yeas_amend_percent),0)
AS yeas_amend_percent,
IF(DATE(ba.date_pass1) IS NOT NULL,
	IF(yeas_pass1>0 AND yeas_pass1 IS NOT NULL,nays_pass1/(yeas_pass1+nays_pass1+excused_pass1+not_voting_pass1),avg_nays_pass1_percent),0)
AS nays_pass1_percent,
IF(DATE(ba.date_amend) IS NOT NULL,
	IF(yeas_amend>0 AND yeas_amend IS NOT NULL,nays_amend/(yeas_amend+nays_amend+excused_amend+not_voting_amend),avg_nays_amend_percent),0)
AS nays_amend_percent
FROM bills_attributes ba
JOIN
(SELECT session_id,document_type,
AVG(yeas_pass1/(yeas_pass1+nays_pass1+not_voting_pass1+excused_pass1)) AS avg_yeas_pass1_percent,
AVG(nays_pass1/(yeas_pass1+nays_pass1+not_voting_pass1+excused_pass1)) AS avg_nays_pass1_percent,
AVG(not_voting_pass1/(yeas_pass1+nays_pass1+not_voting_pass1+excused_pass1)) AS avg_not_voting_pass1_percent,
AVG(excused_pass1/(yeas_pass1+nays_pass1+not_voting_pass1+excused_pass1)) AS avg_excused_pass1_percent,
AVG(yeas_amend/(yeas_amend+nays_amend+not_voting_amend+excused_amend)) AS avg_yeas_amend_percent,
AVG(nays_amend/(yeas_amend+nays_amend+not_voting_amend+excused_amend)) AS avg_nays_amend_percent,
AVG(not_voting_amend/(yeas_amend+nays_amend+not_voting_amend+excused_amend)) AS avg_not_voting_amend_percent,
AVG(excused_amend/(yeas_amend+nays_amend+not_voting_amend+excused_amend)) AS avg_excused_amend_percent
FROM bills_attributes ba
WHERE ba.`yeas_pass1`>0 AND ba.`yeas_pass1` IS NOT NULL
AND ba.`session_id` >=14
GROUP BY 1,2
) average_pass_amend
ON ba.session_id=average_pass_amend.session_id
AND ba.document_type=average_pass_amend.document_type) t

SET a.yeas_pass1_percent=t.yeas_pass1_percent,
    a.nays_pass1_percent=t.nays_pass1_percent,
    a.yeas_amend_percent=t.yeas_amend_percent,
    a.nays_amend_percent=t.nays_amend_percent
    
 WHERE a.id=t.id;
 

/*append most recent bills_attributes into historical table for record keeping purposes*/
INSERT INTO bills_attributes_recorded
SELECT CURRENT_TIMESTAMP(),ba.* FROM bills_attributes ba;

 
/*REPLACE bills_attributes_historical TABLE*/ 
 
DROP TABLE IF EXISTS bills_attributes_historical;



CREATE TABLE bills_attributes_historical AS 
SELECT ba.id AS bill_id,    
ba.`session_id`,
ba.`document_type`,
ba.`number`,
ld.`leg_day`,
IF(ld.leg_day>30,1,0) AS past_cross_over,
ld.`leg_days_remaining`,
ld.`status_date`,
-- ba.category,
IF(DATE(ba.date_pass2)<=ld.status_date,6,
	IF(DATE(ba.date_amend)<=ld.status_date,5,
	IF(DATE(ba.date_out_comm2)<=ld.status_date,4,
	IF(DATE(ba.date_pass1)<=ld.status_date,3,
	IF(DATE(ba.date_out_comm1)<=ld.status_date,2,
	IF(DATE(ba.date_submitted)<=ld.status_date,1,0))))))
AS leg_day_status,
IF(DATE(ba.date_pass2)<=ld.status_date,ba.leg_days_remaining_pass2-leg_days_remaining,
	IF(DATE(ba.date_amend)<=ld.status_date,leg_days_remaining_amend-leg_days_remaining,
	IF(DATE(ba.date_out_comm2)<=ld.status_date,leg_days_remaining_out_comm2-leg_days_remaining,
	IF(DATE(ba.date_pass1)<=ld.status_date,leg_days_remaining_pass1-leg_days_remaining,
	IF(DATE(ba.date_out_comm1)<=ld.status_date,leg_days_remaining_out_comm1-leg_days_remaining,
	IF(DATE(ba.date_submitted)<=ld.status_date,leg_days_remaining_submitted-leg_days_remaining,IF(ba.leg_year_submitted=2005,39,40)-leg_days_remaining))))))
AS leg_days_since_last_status,	
ba.`date_submitted`,
ba.`date_out_comm1`,
ba.`date_pass1`,
ba.`date_out_comm2`,
ba.`date_amend`,
ba.`date_pass2`,
ba.`date_sent_gov`,
ba.`leg_date_submitted`,
ba.`leg_date_out_comm1`,
ba.`leg_date_pass1`,
ba.`leg_date_out_comm2`,
ba.`leg_date_amend`,
ba.`leg_date_pass2`,
ba.`leg_date_sent_gov`,
ba.`leg_day_submitted`,
ba.`leg_day_out_comm1`,
ba.`leg_day_pass1`,
ba.`leg_day_out_comm2`,
ba.`leg_day_amend`,
ba.`leg_day_pass2`,
ba.`leg_day_sent_gov`,
ba.`leg_days_remaining_submitted`,
ba.`leg_days_remaining_out_comm1`,
ba.`leg_days_remaining_pass1`,
ba.`leg_days_remaining_out_comm2`,
ba.`leg_days_remaining_amend`,
ba.`leg_days_remaining_pass2`,
ba.`leg_days_remaining_sent_gov`,
ba.`passed_year_submitted`,
IF(ba.passed=1 AND ba.`passed_year_submitted`=0,1,0) AS passed_second_year,
ba.passed,
IF(chamber_leader_author=1,7,IF(rules_chair_author=1,6,IF(floor_leader_author,5,IF(majority_leadership_author,4,IF(majority_chairman_author=1,3,IF(minority_leader_author=1,2,majority_party_author)))))) AS author_category_chairs_fl,
IF(chamber_leader_author=1,5,IF(rules_chair_author=1,4,IF(majority_leadership_author,3,IF(majority_chairman_author=1,2,majority_party_author)))) AS author_category_chairs,
IF(chamber_leader_author=1,6,IF(rules_chair_author=1,5,IF(majority_leadership_author,4,IF(majority_chairman_author=1,3,IF(minority_leader_author=1,2,majority_party_author))))) AS author_category_chairs_min_leader,
IF(IF(chamber_leader_author=1,7,IF(rules_chair_author=1,6,IF(floor_leader_author,5,IF(majority_leadership_author,4,IF(majority_chairman_author=1,3,IF(minority_leader_author=1,2,majority_party_author))))))>2,2,majority_party_author) AS author_leadership_majority_only,
IF(ba.leg_year_submitted IN ('2000','2002','2004','2006','2008','2010','2012','2014','2016','2018'),1,0) AS leg_election_year,   
IF(summary_amend_act=1,1,IF(summary_amend_title=1,2,IF(summary_amend_chapter=1,3,IF(summary_amend_article=1,4,IF(summary_amend_code=1,5,0))))) AS summary_amend_cat_expanded,   
IF(majority_sponsors>4,5,majority_sponsors) AS majority_sponsors_cut,   
IF(minority_sponsors>4,5,minority_sponsors) AS minority_sponsors_cut,   
bi_partisan_sponsorship,   
summary_homestead,   
summary_amend_act,   
summary_tax,   
summary_to_authorize,   
summary_new_charter,   
summary_city,   
summary_county,   
summary_election, 
summary_office,   
summary_regulate,           
summary_health,           
summary_social,           
local_label,           
IF(summary_amend_act=0 AND summary_amend_any=1,1,IF(summary_amend_act=1,2,0)) AS summary_amend_cat,   
days_from_may_submitted,   
summary_county_names,   
summary_city_of,   
IF(minority_leader_sponsor>0,1,0) AS minority_leader_sponsor,   
IF(rules_chair_sponsor>0,1,0) AS rules_chair_sponsor,   
IF(chamber_leader_sponsor>0,1,0) AS chamber_leader_sponsor,   
IF(majority_leadership_sponsors>0,1,0) AS majority_leadership_sponsor,           
IF(majority_chairman_sponsors>0,1,0) AS majority_chairman_sponsor,           
IF(floor_leader_sponsors>1,1,0) AS floor_leader_sponsor,
committee_1,
committee_2,
IF(DATE(ba.date_out_comm1)<=ld.status_date,
	IF(committee_1 IN ('reapportionment','agriculture','budget and fiscal affairs oversight','information and audits','regulated beverages','small business development',
	'interstate cooperation','code revision','science and technology','children & youth','veterans') 
	OR committee_1 LIKE '%special%','aggregated',IF(committee_1 IS NULL, "no_first_comm_reported",committee_1)),
	"no_first_committee")
AS committee_1_conv,
IF(DATE(ba.date_out_comm2)<=ld.status_date,
	IF(committee_2 IN ('reapportionment','agriculture','budget and fiscal affairs oversight','information and audits','regulated beverages','small business development',
	'interstate cooperation','code revision','science and technology','children & youth','veterans') 
	OR committee_2 LIKE '%special%','aggregated',IF(committee_2 IS NULL, "no_second_comm_reported",committee_2)),
	"no_first_committee")
AS committee_2_conv,
IF(DATE(ba.date_out_comm1)<=ld.status_date AND comm_1_sub=1,1,0) AS comm_1_sub,
IF(DATE(ba.date_out_comm2)<=ld.status_date AND comm_2_sub=1,1,0) AS comm_2_sub,
IF(summary_city_of = 1 OR summary_county_names=1,1,0) AS local_inferred,
IF(DATE(ba.date_amend)<=ld.status_date,yeas_amend_percent,0) AS yeas_amend_percent,
IF(DATE(ba.date_amend)<=ld.status_date,yeas_amend_percent,0) AS nays_amend_percent,
IF(DATE(ba.date_pass1)<=ld.status_date,yeas_pass1_percent,0) AS yeas_pass1_percent,
IF(DATE(ba.date_pass1)<=ld.status_date,yeas_pass1_percent,0) AS nays_pass1_percent,
ba.leg_year_submitted
FROM bills_attributes ba
JOIN legislative_days_historical ld
ON ba.`leg_year_submitted`=ld.`leg_year_submitted`
WHERE ld.on_calendar <> 2
AND author_party IS NOT NULL AND ba.session_id >= 14;

/*ADD MORE GRANULAR STATUSES*/
ALTER TABLE bills_attributes_historical
ADD COLUMN leg_day_status_granular VARCHAR(20),
ADD COLUMN date_granular_status DATETIME,
ADD COLUMN leg_days_since_last_status_granular INT;

UPDATE bills_attributes_historical a,( 
SELECT t.bill_id,t.status_date,bsl.code,max_status_date
FROM
(SELECT bsl.`bill_id`,ba.status_date,MAX(IF(DATE(bsl.`status_date`)<=DATE(ba.`status_date`),bsl.status_date,NULL)) AS max_status_date
FROM bill_status_listings bsl
JOIN bills_attributes_historical ba
ON bsl.`bill_id`=ba.`bill_id`
WHERE ba.`session_id` >=14
AND bsl.code NOT IN ('EFF','Signed Gov','HDSG','SDSG')
GROUP BY 1,2) t
JOIN bill_status_listings bsl
ON t.bill_id=bsl.`bill_id`
AND t.max_status_date=bsl.`status_date`
AND bsl.code NOT IN ('EFF','Signed Gov','HDSG','SDSG')) t

SET a.leg_day_status_granular=t.code,
    a.date_granular_status=t.max_status_date

WHERE a.bill_id=t.bill_id AND
      a.`status_date`=t.status_date;
      
      
UPDATE bills_attributes_historical
SET leg_day_status_granular="not submitted"
WHERE leg_day_status=0;

UPDATE bills_attributes_historical
SET leg_day_status_granular="passed"
WHERE leg_day_status=6;

/*INDEX TO EXPEDITE STATUS CHANGES QUERY*/
CREATE UNIQUE INDEX status_change_query
ON bills_attributes_historical
(bill_id,status_date,leg_day_status_granular);


UPDATE bills_attributes_historical a, (
SELECT bah1.bill_id,bah1.status_date,bah1.leg_day_status_granular,COUNT(*)-IF(bah1.leg_day_status_granular IN ('HPF','SPF'),0,1) AS leg_days_since_last_status_granular
FROM bills_attributes_historical bah1
JOIN bills_attributes_historical bah2
ON bah1.bill_id=bah2.bill_id
AND bah1.`leg_day_status_granular`=bah2.`leg_day_status_granular`
WHERE bah1.`session_id` >= 14 
AND bah1.status_date>bah2.status_date
GROUP BY 1,2,3) t

SET a.leg_days_since_last_status_granular=t.leg_days_since_last_status_granular

WHERE a.`bill_id`=t.bill_id
      AND a.`status_date`=t.status_date;
      
      
UPDATE bills_attributes_historical
SET leg_days_since_last_status_granular=IF(leg_year_submitted=2005,39,40)-leg_days_remaining
WHERE leg_day_status=0;
