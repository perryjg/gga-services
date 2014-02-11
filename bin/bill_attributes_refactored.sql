DROP TABLE IF EXISTS bills_attributes;


CREATE TABLE bills_attributes AS
SELECT a.id, a.session_id, a.document_type, a.number,
       IF(SUBSTRING_INDEX(summary,' ',12)='A bill to be entitled an Act to provide a homestead exemption','1','0') AS summary_homestead,
       IF(SUBSTRING_INDEX(summary,' ',11)='A bill to be entitled an Act to amend an Act' or SUBSTRING_INDEX(summary,' ',6)='A bill to amend an Act','1','0') AS summary_amend_act,
       IF(SUBSTRING_INDEX(summary,' ',10)='A bill to be entitled an Act to amend title' or SUBSTRING_INDEX(summary,' ',5)='A bill to amend title','1','0') AS summary_amend_title,
       IF(SUBSTRING_INDEX(summary,' ',10)='A bill to be entitled an Act to amend chapter' or SUBSTRING_INDEX(summary,' ',5)='A bill to amend chapter','1','0') AS summary_amend_chapter,
       IF(SUBSTRING_INDEX(summary,' ',10)='A bill to be entitled an Act to amend article' or SUBSTRING_INDEX(summary,' ',5)='A bill to amend article','1','0') AS summary_amend_article,
       IF(SUBSTRING_INDEX(summary,' ',11)='A bill to be entitled an Act to amend code section' or SUBSTRING_INDEX(summary,' ',6)='A bill to amend code section','1','0') AS summary_amend_code,
       IF(SUBSTRING_INDEX(summary,' ',10)='A bill to be entitled an Act to amend part' or SUBSTRING_INDEX(summary,' ',5)='A bill to amend part','1','0') AS summary_amend_part,  
       IF(SUBSTRING_INDEX(summary,' ',9)='A bill to be entitled an Act to amend' or SUBSTRING_INDEX(summary,' ',4)='A bill to amend','1','0') AS summary_amend_any,       
       IF(summary LIKE '%new charter%',1,0) AS summary_new_charter,
       IF(SUBSTRING_INDEX(summary,' ',15) LIKE '%to authorize the city%' OR SUBSTRING_INDEX(summary,' ',15) LIKE '%to authorize the governing authority%',1,0) as summary_to_authorize,
       IF(summary LIKE '%48-%' OR summary LIKE '% 48 %',1,0) AS summary_tax,
       IF(summary LIKE '%county%',1,0) AS summary_county,
	   IF((a.summary like '% Appling %' or a.summary like '% Athens-Clarke %' or a.summary like '% Atkinson %' or a.summary like '% Augusta-Richmond %' or a.summary like '% Bacon %' or a.summary like '% Baker %' or a.summary like '% Baldwin %' or a.summary like '% Banks %' or a.summary like '% Barrow %' or a.summary like '% Bartow %' or a.summary like '% Ben Hill %' or a.summary like '% Berrien %' or a.summary like '% Bibb %' or a.summary like '% Bleckley %' or a.summary like '% Brantley %' or a.summary like '% Brooks %' or a.summary like '% Bryan %' or a.summary like '% Bulloch %' or a.summary like '% Burke %' or a.summary like '% Butts %' or a.summary like '% Calhoun %' or a.summary like '% Camden %' or a.summary like '% Candler %' or a.summary like '% Carroll %' or a.summary like '% Catoosa %' or a.summary like '% Charlton %' or a.summary like '% Chatham %' or a.summary like '% Chattooga %' or a.summary like '% Cherokee %' or a.summary like '% Clay %' or a.summary like '% Clayton %' or a.summary like '% Clinch %' or a.summary like '% Cobb %' or a.summary like '% Coffee %' or a.summary like '% Colquitt %' or a.summary like '% Columbia %' or a.summary like '% Columbus-Muscogee %' or a.summary like '% Cook %' or a.summary like '% Coweta %' or a.summary like '% Crawford %' or a.summary like '% Crisp %' or a.summary like '% Cusseta-Chattahoochee %' or a.summary like '% Dade %' or a.summary like '% Dawson %' or a.summary like '% Decatur %' or a.summary like '% DeKalb %' or a.summary like '% Dodge %' or a.summary like '% Dooly %' or a.summary like '% Dougherty %' or a.summary like '% Douglas %' or a.summary like '% Early %' or a.summary like '% Echols %' or a.summary like '% Effingham %' or a.summary like '% Elbert %' or a.summary like '% Emanuel %' or a.summary like '% Evans %' or a.summary like '% Fannin %' or a.summary like '% Fayette %' or a.summary like '% Floyd %' or a.summary like '% Forsyth %' or a.summary like '% Franklin %' or a.summary like '% Fulton %' or a.summary like '% Georgetown-Quitman %' or a.summary like '% Gilmer %' or a.summary like '% Glascock %' or a.summary like '% Glynn %' or a.summary like '% Gordon %' or a.summary like '% Grady %' or a.summary like '% Greene %' or a.summary like '% Gwinnett %' or a.summary like '% Habersham %' or a.summary like '% Hall %' or a.summary like '% Hancock %' or a.summary like '% Haralson %' or a.summary like '% Harris %' or a.summary like '% Hart %' or a.summary like '% Heard %' or a.summary like '% Henry %' or a.summary like '% Houston %' or a.summary like '% Irwin %' or a.summary like '% Jackson %' or a.summary like '% Jasper %' or a.summary like '% Jeff Davis %' or a.summary like '% Jefferson %' or a.summary like '% Jenkins %' or a.summary like '% Johnson %' or a.summary like '% Jones %' or a.summary like '% Lamar %' or a.summary like '% Lanier %' or a.summary like '% Laurens %' or a.summary like '% Lee %' or a.summary like '% Liberty %' or a.summary like '% Lincoln %' or a.summary like '% Long %' or a.summary like '% Lowndes %' or a.summary like '% Lumpkin %' or a.summary like '% Macon %' or a.summary like '% Madison %' or a.summary like '% Marion %' or a.summary like '% McDuffie %' or a.summary like '% McIntosh %' or a.summary like '% Meriwether %' or a.summary like '% Miller %' or a.summary like '% Mitchell %' or a.summary like '% Monroe %' or a.summary like '% Montgomery %' or a.summary like '% Morgan %' or a.summary like '% Murray %' or a.summary like '% Newton %' or a.summary like '% Oconee %' or a.summary like '% Oglethorpe %' or a.summary like '% Paulding %' or a.summary like '% Peach %' or a.summary like '% Pickens %' or a.summary like '% Pierce %' or a.summary like '% Pike %' or a.summary like '% Polk %' or a.summary like '% Pulaski %' or a.summary like '% Putnam %' or a.summary like '% Rabun %' or a.summary like '% Randolph %' or a.summary like '% Rockdale %' or a.summary like '% Schley %' or a.summary like '% Screven %' or a.summary like '% Seminole %' or a.summary like '% Spalding %' or a.summary like '% Stephens %' or a.summary like '% Stewart %' or a.summary like '% Sumter %' or a.summary like '% Talbot %' or a.summary like '% Taliaferro %' or a.summary like '% Tattnall %' or a.summary like '% Taylor %' or a.summary like '% Telfair %' or a.summary like '% Terrell %' or a.summary like '% Thomas %' or a.summary like '% Tift %' or a.summary like '% Toombs %' or a.summary like '% Towns %' or a.summary like '% Treutlen %' or a.summary like '% Troup %' or a.summary like '% Turner %' or a.summary like '% Twiggs %' or a.summary like '% Union %' or a.summary like '% Upson %' or a.summary like '% Walker %' or a.summary like '% Walton %' or a.summary like '% Ware %' or a.summary like '% Warren %' or a.summary like '% Washington %' or a.summary like '% Wayne %' or a.summary like '% Webster %' or a.summary like '% Wheeler %' or a.summary like '% White %' or a.summary like '% Whitfield %' or a.summary like '% Wilcox %' or a.summary like '% Wilkes %' or a.summary like '% Wilkinson %' or a.summary like '% Worth %') and (a.summary like '%county%' or a.summary like '%consolidated%'),1,0) as summary_county_names,
       IF(summary LIKE '%city%',1,0) AS summary_city,
   	   IF((summary like '%city of%' or summary like '%town of%' or summary like '%consolidated government of%' or summary like '%metropolitan%' or summary like '%municipality of%') and summary not like "%city of this state%" and summary not like "%town of this state%",1,0)
	 as summary_city_of,
       IF(summary LIKE '%regulat%',1,0) AS summary_regulate,
       IF(summary LIKE '%office %',1,0) AS summary_office,
       IF(summary LIKE '%election %',1,0) AS summary_election,
       IF(summary LIKE '% health %',1,0) AS summary_health,
       IF(summary LIKE '%firearm%' OR summary LIKE '% gun%' OR summary LIKE '% abort%' OR summary LIKE '%marriage%'
OR summary LIKE '% pray%' OR summary LIKE '%alcohol%' OR summary LIKE '% sex%' OR summary LIKE '%controlled substance%',1,0) AS summary_social,
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
ADD COLUMN minority_chairman_author INT;



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


/*add key leadership author and sponsorship*/
UPDATE bills_attributes a, (
select b.id as id,
sum(if(sl.sequence=1 and sl.body in ('house','senate'),1,0)) as chamber_leader_author,
sum(if(sl.sequence=1 and sl.body in ('rules'),1,0)) as rules_chair_author,
sum(if(sl.sequence<>1 and sl.body in ('house','senate'),1,0)) as chamber_leader_sponsor,
sum(if(sl.sequence<>1 and sl.body in ('rules'),1,0)) as rules_chair_sponsor,
sum(if(sl.sequence=1 and sl.body in ('minority'),1,0)) as minority_leader_author,
sum(if(sl.sequence<>1 and sl.body in ('minority'),1,0)) as minority_leader_sponsor
from bills_attributes as b
left join
(select l.leg_year_submitted, l.body, s.*
from sponsorships s
join leadership_roles_by_year l
on s.member_id=l.member_id) as sl
on sl.bill_id=b.id
and b.leg_year_submitted=sl.leg_year_submitted
group by b.id) t

set a.chamber_leader_sponsor=t.chamber_leader_sponsor,
	a.chamber_leader_author=t.chamber_leader_author,
	a.rules_chair_sponsor=t.rules_chair_sponsor,
	a.rules_chair_author=t.rules_chair_author,
	a.minority_leader_author=t.minority_leader_author,
	a.minority_leader_sponsor=t.minority_leader_sponsor

where a.id=t.id;

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
JOIN legislative_services_amended AS l
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


