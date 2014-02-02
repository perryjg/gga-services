DROP TABLE IF EXISTS bills_attributes;


CREATE TABLE bills_attributes AS
SELECT a.id, a.session_id, a.document_type, a.number,
       IF(SUBSTRING_INDEX(summary,' ',12)='A bill to be entitled an Act to provide a homestead exemption','1','0') AS summary_homestead,
       IF(SUBSTRING_INDEX(summary,' ',11)='A bill to be entitled an Act to amend an Act','1','0') AS summary_amend_act,
       IF(summary LIKE '%new charter%',1,0) AS summary_new_charter,
       IF(SUBSTRING_INDEX(summary,' ',15) LIKE '%to authorize the city%' OR SUBSTRING_INDEX(summary,' ',15) LIKE '%to authorize the governing authority%',1,0) as summary_to_authorize,
       IF(summary LIKE '%48-%' OR summary LIKE '% 48 %',1,0) AS summary_tax,
       IF(summary LIKE '%county%',1,0) AS summary_county,
       IF(summary LIKE '%city%',1,0) AS summary_city,
       IF(summary LIKE '%regulat%',1,0) AS summary_regulate,
       IF(summary LIKE '%office %',1,0) AS summary_office,
       IF(summary LIKE '%election %',1,0) AS summary_election,
       IF(summary LIKE '% health %',1,0) AS summary_health,
       IF(summary LIKE '%firearm%' OR summary LIKE '% gun%' OR summary LIKE '% abort%' OR summary LIKE '%marriage%'
OR summary LIKE '% pray%' OR summary LIKE '%alcohol%' OR summary LIKE '% sex %',1,0) AS summary_social,
       IF(SUM(IF(b.code IN ('HSG','SSG'),1,0))>0,1,0) AS passed,
       IF(SUM(IF(b.code IN ('HCFR','SCFR'),1,0) )>0,1,0) AS out_committee,
       MAX(b.status_date) AS max_action_date,
       MIN(b.status_date) AS min_action_date
FROM bills a
LEFT JOIN bill_status_listings b
      ON a.id = bill_id

WHERE a.document_type IN ('HB','SB')
  AND b.code <> 'EFF'
  AND a.session_id IN (1,11,14,18,20,21,23)/* Regular sessions */
  
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
ADD COLUMN days_from_may_submitted INT,
ADD COLUMN days_from_may_out_committee INT,
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
ADD COLUMN out_committee_date DATE,
ADD COLUMN single_party_rule INT,
ADD COLUMN bi_partisan_sponsorship INT,
ADD COLUMN movement_second_year INT,
ADD COLUMN house_date_passed DATE,
ADD COLUMN senate_date_passed DATE;


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
  AND session_id IN (14,18,20,21,23);

UPDATE bills_attributes
SET majority_party = '0'
WHERE document_type = 'SB'
  AND session_id IN (1);

UPDATE bills_attributes
SET  majority_party = '1'
WHERE document_type = 'SB'
  AND session_id IN (11,14,18,20,21,23);
  
UPDATE bills_attributes
SET majority_party_house = IF(session_id in (1,11),'0','1'),
    majority_party_senate = IF(session_id in (1),'0','1');


/*get dem/rep, leadership figures */
UPDATE bills_attributes a, (
SELECT bill_id,
        COUNT(*) AS sponsors,
        SUM(IF(l.party = 'Republican' and sequence=1, 1,IF(l.party = 'Democrat' and sequence = 1,0,IF(l.party NOT IN ('Democrat','Republican') and sequence = 1,2,0)))) as author_party,
        SUM(IF(l.party = 'Republican' and sequence<>1,1,0)) AS sponsors_republican,
	SUM(IF(l.party = 'Democrat' and sequence<>1,1,0)) AS sponsors_democrat,
	SUM(IF(l.district_type = 'House' and sequence<>1,1,0)) AS sponsors_house,
	SUM(IF(l.district_type = 'Senate' and sequence<>1,1,0)) AS sponsors_senate,
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
        FROM legislative_services_amended AS l
    JOIN 
    (
    SELECT a.bill_id,a.member_id,a.sequence,b.`session_id`
    FROM sponsorships a
    JOIN bills b ON a.bill_id = b.id
    JOIN members m ON a.member_id = m.id
    WHERE b.document_type IN ('HB','SB') AND b.`session_id` IN (1,11,14,18,20,21,23)
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
    datediff(MAKEDATE((IF(MONTH(min_action_date)>6,YEAR(min_action_date)+1,YEAR(min_action_date))),121),min_action_date) as days_from_may_submitted,
    IF(IF(MONTH(min_action_date)>6,YEAR(min_action_date)+1,YEAR(min_action_date)) IN ('2000','2004','2008','2012'),1,0) AS leg_election_year,
    IF(IF(MONTH(min_action_date)>6,YEAR(min_action_date)+1,YEAR(min_action_date)) IN ('2002','2006','2010','2014'),1,0) AS gov_election_year,
    IF(MONTH(min_action_date)>6,YEAR(min_action_date)+1,YEAR(min_action_date)) as leg_year_submitted,
    IF(IF(MONTH(min_action_date)>6,YEAR(min_action_date)+1,YEAR(min_action_date)) IN ('2002','2006','2014'),1,0) AS gov_reelection_year,
    IF(YEAR(max_action_date)>IF(MONTH(min_action_date)>6,YEAR(min_action_date)+1,YEAR(min_action_date)),1,0) AS movement_second_year,
    IF(sponsors_republican>0 AND sponsors_democrat>0,1,0) as bi_partisan_sponsorship,
    IF(majority_party_senate=majority_party_house AND majority_party_senate=gov_party,1,0) AS single_party_rule,
    IF(author_party=majority_party,1,0) AS majority_party_author,
    IF(majority_party=1,leadership_author_republican,leadership_author_democrat) as majority_leadership_author,
    IF(majority_party=1,leadership_sponsors_republican,leadership_sponsors_democrat) as majority_leadership_sponsors,
    IF(majority_party=0,leadership_author_republican,leadership_author_democrat) as minority_leadership_author,
    IF(majority_party=0,leadership_sponsors_republican,leadership_sponsors_democrat) as minority_leadership_sponsors,
    IF(majority_party=1,other_leadership_sponsors_republican,other_leadership_sponsors_democrat) as other_majority_leadership_sponsors,
    IF(majority_party=0,other_leadership_sponsors_republican,other_leadership_sponsors_democrat) as other_minority_leadership_sponsors,
    IF(majority_party=1,other_sponsors_republican,other_sponsors_democrat) as other_majority_sponsors,
    IF(majority_party=0,other_sponsors_republican,other_sponsors_democrat) as other_minority_sponsors,
    IF(majority_party=1,sponsors_republican,sponsors_democrat) as majority_sponsors,
    IF(majority_party=0,sponsors_republican,sponsors_democrat) as minority_sponsors
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


/*UPDATE bills_attributes a, (
    SELECT id,
    IF(author_party=majority_party,1,0) AS majority_party_author,
    IF(majority_party=1,leadership_author_republican,leadership_author_democrat) as majority_leadership_author,
    IF(majority_party=1,leadership_sponsors_republican,leadership_sponsors_democrat) as majority_leadership_sponsors,
    IF(majority_party=0,leadership_author_republican,leadership_author_democrat) as minority_leadership_author,
    IF(majority_party=0,leadership_sponsors_republican,leadership_sponsors_democrat) as minority_leadership_sponsors,
    IF(majority_party=1,other_leadership_sponsors_republican,other_leadership_sponsors_democrat) as other_majority_leadership_sponsors,
    IF(majority_party=0,other_leadership_sponsors_republican,other_leadership_sponsors_democrat) as other_minority_leadership_sponsors,
    IF(majority_party=1,other_sponsors_republican,other_sponsors_democrat) as other_majority_sponsors,
    IF(majority_party=0,other_sponsors_republican,other_sponsors_democrat) as other_minority_sponsors,
    IF(majority_party=1,sponsors_republican,sponsors_democrat) as majority_sponsors,
    IF(majority_party=0,sponsors_republican,sponsors_democrat) as minority_sponsors
    FROM bills_attributes) t
    
SET a.majority_party_author=t.majority_party_author,
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
    
WHERE a.id=t.id;*/


/*UPDATE bills_attributes a, (
SELECT id,
IF(id in (1,11),(democrats_house-republicans_house)/(republicans_house+democrats_house),(republicans_house-democrats_house)/(republicans_house+democrats_house)) AS majority_edge_percent_house,
IF(id in (1),(democrats_senate-republicans_senate)/(republicans_senate+democrats_senate),(republicans_senate-democrats_senate)/(republicans_senate+democrats_senate)) AS majority_edge_percent_senate,
IF(id in (1),democrats_senate-republicans_senate,republicans_senate-democrats_senate) AS majority_edge_senate,
IF(id in (1,11),democrats_house-republicans_house,republicans_house-democrats_house) AS majority_edge_house,
IF(id in (1),democrats_senate,republicans_senate) AS majority_members_senate,
IF(id in (1,11),democrats_house,republicans_house) AS majority_members_house,
IF(id in (1),republicans_senate,democrats_senate) AS minority_members_senate,
IF(id in (1,11),republicans_house,democrats_house) AS minority_members_house
FROM sessions_amended
GROUP BY id) t

SET a.majority_edge_percent_house=t.majority_edge_percent_house,
    a.majority_edge_percent_senate=t.majority_edge_percent_senate,
    a.majority_edge_house=t.majority_edge_house,
    a.majority_edge_senate=t.majority_edge_senate,
    a.majority_members_house=t.majority_members_house,
    a.minority_members_house=t.minority_members_house,
    a.majority_members_senate=t.majority_members_senate,
    a.minority_members_senate=t.minority_members_senate
    
WHERE a.session_id=t.id;

UPDATE bills_attributes
SET majority_edge_percent = majority_edge_percent_senate,
    majority_edge = majority_edge_senate
WHERE document_type = 'SB';

UPDATE bills_attributes
SET majority_edge_percent = majority_edge_percent_house,
    majority_edge = majority_edge_house
WHERE document_type = 'HB';




UPDATE bills_attributes a, (
SELECT bill_id, MIN(status_date) as out_committee_date
FROM bill_status_listings 
WHERE CODE IN ('HCFR','SCFR') AND document_type IN ('HB','SB')
GROUP BY bill_id) t

SET a.out_committee_date=t.out_committee_date,
a.days_from_may_out_committee=datediff(MAKEDATE(YEAR(t.out_committee_date),121),t.out_committee_date)


WHERE a.id=t.bill_id;

UPDATE bills_attributes a, (
    SELECT id,
    datediff(MAKEDATE(YEAR(out_committee_date),121),out_committee_date) as days_from_may_out_committee
    FROM bills_attributes) t

SET a.days_from_may_out_committee=t.days_from_may_out_committee

WHERE a.id=t.id;*/


