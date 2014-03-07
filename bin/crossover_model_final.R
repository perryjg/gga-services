library(RMySQL)
library(rms)


con <-dbConnect(MySQL(), user = "ajcnews", password = "KbZ776Pd", host = "ajc-intranet.cgmwsizvte0i.us-east-1.rds.amazonaws.com", dbname = "predictions")


training_frame <- dbGetQuery(con,
    "SELECT id AS bill_id, 
	   IF(document_type='SB',1,0) AS document_type,
	   session_id,
           IF(chamber_leader_author=1,6,IF(rules_chair_author=1,5,IF(floor_leader_author,4,IF(majority_chairman_author=1,3,IF(minority_leader_author=1,2,majority_party_author))))) AS author_category_chairs,
           IF(chamber_leader_author=1,5,IF(rules_chair_author=1,4,IF(floor_leader_author,3,IF(majority_chairman_author=1,2,majority_party_author)))) AS author_category_chairs_new,
	   IF(leg_year_submitted IN ('2000','2002','2004','2006','2008','2010','2012','2014'),1,0) AS leg_election_year,
	   IF(minority_sponsors>4,5,minority_sponsors) AS minority_sponsors_cut,
	   IF(majority_sponsors>4,5,majority_sponsors) AS majority_sponsors_cut,
	   IF(sponsors>4,5,sponsors) AS sponsors_cut,
	   IF(sent_gov_date IS NULL OR DATE(sent_gov_date)>DATE(crossover_date_second),0,1) AS sent_gov_pre_crossover,
	   IF(out_committee_date IS NULL OR DATE(out_committee_date)>DATE(crossover_date_second),0,1) AS out_committee_pre_crossover,
	   IF(chamber_passes>0 AND DATE(min_pass_date)<=DATE(crossover_date_second),1,0) AS passed_one_pre_crossover,
	   IF(min_movement_date_second_year IS NOT NULL,1,0) AS movement_second_year,
	   local_label,
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
	   majority_party_author,
	   majority_chairman_sponsors,
	   IF(majority_chairman_author=1 OR chamber_leader_author=1 OR rules_chair_author=1 OR floor_leader_author=1,1,0) AS majority_leadership_author,
	   if(days_from_crossover_last_moved>100,100,days_from_crossover_last_moved) as days_from_crossover_last_moved,
	   if(chamber_passes_pre_crossover>1,3,if(chamber_passes_pre_crossover>0,2,if(DATE(out_committee_date)<=crossover_date_second,1,0))) as bill_status_pre_crossover,
	   days_from_may_submitted,
	   days_from_may_passed_first,
	   out_committee,
	   chamber_passes,
	   chamber_passes_pre_crossover,
	   if(chamber_passes_pre_crossover > 0, 1,0) as passed_chamber_pre_crossover,
	   IF(minority_leader_sponsor>0,1,0) AS minority_leader_sponsor,
	   IF(rules_chair_sponsor>0,1,0) AS rules_chair_sponsor,
	   IF(chamber_leader_sponsor>0,1,0) AS chamber_leader_sponsor,
	   IF(floor_leader_sponsors>1,1,0) AS floor_leader_sponsor,
	   last_precross_move_withdrawn_tabled,
	   passed
	   FROM bills_attributes
	   where author_party is not null and session_id IN ('21','18','20')")


testing <- dbGetQuery(con,
    "SELECT id AS bill_id, 
	   IF(document_type='SB',1,0) AS document_type,
	   session_id,
           IF(chamber_leader_author=1,6,IF(rules_chair_author=1,5,IF(floor_leader_author,4,IF(majority_chairman_author=1,3,IF(minority_leader_author=1,2,majority_party_author))))) AS author_category_chairs,
           IF(chamber_leader_author=1,5,IF(rules_chair_author=1,4,IF(floor_leader_author,3,IF(majority_chairman_author=1,2,majority_party_author)))) AS author_category_chairs_new,
	   IF(leg_year_submitted IN ('2000','2002','2004','2006','2008','2010','2012','2014'),1,0) AS leg_election_year,
	   IF(minority_sponsors>4,5,minority_sponsors) AS minority_sponsors_cut,
	   IF(majority_sponsors>4,5,majority_sponsors) AS majority_sponsors_cut,
	   IF(sponsors>4,5,sponsors) AS sponsors_cut,
	   IF(sent_gov_date IS NULL OR DATE(sent_gov_date)>DATE(crossover_date_second),0,1) AS sent_gov_pre_crossover,
	   IF(out_committee_date IS NULL OR DATE(out_committee_date)>DATE(crossover_date_second),0,1) AS out_committee_pre_crossover,
	   IF(chamber_passes>0 AND DATE(min_pass_date)<=DATE(crossover_date_second),1,0) AS passed_one_pre_crossover,
	   IF(min_movement_date_second_year IS NOT NULL,1,0) AS movement_second_year,
	   local_label,
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
	   majority_party_author,
	   majority_chairman_sponsors,
	   IF(majority_chairman_author=1 OR chamber_leader_author=1 OR rules_chair_author=1 OR floor_leader_author=1,1,0) AS majority_leadership_author,
	   days_from_may_submitted,
	   days_from_may_passed_first,
	   if(days_from_crossover_last_moved>100,100,days_from_crossover_last_moved) as days_from_crossover_last_moved,
	   out_committee,
	   if(chamber_passes_pre_crossover>1,3,if(chamber_passes_pre_crossover>0,2,if(DATE(out_committee_date)<=crossover_date_second,1,0))) as bill_status_pre_crossover,
	   chamber_passes,
	   chamber_passes_pre_crossover,
	   if(chamber_passes_pre_crossover > 0, 1,0) as passed_chamber_pre_crossover,
	   IF(minority_leader_sponsor>0,1,0) AS minority_leader_sponsor,
	   IF(rules_chair_sponsor>0,1,0) AS rules_chair_sponsor,
	   IF(chamber_leader_sponsor>0,1,0) AS chamber_leader_sponsor,
	   IF(floor_leader_sponsors>1,1,0) AS floor_leader_sponsor,
	   last_precross_move_withdrawn_tabled,
	   passed
	   FROM bills_attributes
	   where author_party is not null and session_id IN ('23')")



training<-data.frame(as.factor(training_frame$passed))
colnames(training)[1]<-"passed"
training$passed<-as.factor(training_frame$passed)
training$leg_election_year<-as.factor(training_frame$leg_election_year)
training$days_from_may_submitted<-training_frame$days_from_may_submitted
training$majority_sponsors<-training_frame$majority_sponsors
training$minority_sponsors<-training_frame$minority_sponsors
training$minority_sponsors_cut<-training_frame$minority_sponsors_cut
training$rules_chair_sponsor<-as.factor(training_frame$rules_chair_sponsor)
training$minority_leader_sponsor<-as.factor(training_frame$minority_leader_sponsor)
training$chamber_leader_sponsor<-as.factor(training_frame$chamber_leader_sponsor)
training$bi_partisan_sponsorship<-as.factor(training_frame$bi_partisan_sponsorship)
training$floor_leader_sponsor<-as.factor(training_frame$floor_leader_sponsor)
training$out_committee<-as.factor(training_frame$out_committee)
training$chamber_passes<-as.factor(training_frame$chamber_passes)
training$document_type<-as.factor(training_frame$document_type)
training$majority_leadership_author<-as.factor(training_frame$majority_leadership_author)
training$sent_gov_pre_crossover<-as.factor(training_frame$sent_gov_pre_crossover)
training$out_committee_pre_crossover<-as.factor(training_frame$out_committee_pre_crossover)
training$passed_one_pre_crossover<-as.factor(training_frame$passed_one_pre_crossover)
training$movement_second_year<-as.factor(training_frame$movement_second_year)
training$local_label<-as.factor(training_frame$local_label)
training$chamber_passes_pre_crossover<-as.factor(training_frame$chamber_passes_pre_crossover)
training$passed_chamber_pre_crossover<-as.factor(training_frame$passed_chamber_pre_crossover)
training$days_from_crossover_last_moved<-training_frame$days_from_crossover_last_moved
training$last_precross_move_withdrawn_tabled<-as.factor(training_frame$last_precross_move_withdrawn_tabled)
training$bill_status_pre_crossover<-as.factor(training_frame$bill_status_pre_crossover)


dd<-datadist(training)
options(datadist='dd')


training.general<-training[training$local_label == 0,]
testing.general<-testing[testing$local_label == 0,]
training.local<-training[training$local_label == 1,]
testing.local<-testing[testing$local_label == 1,]



training.general<-training.general[training.general$chamber_passes_pre_crossover %in% c(1,2),]
testing.general<-testing.general[testing.general$chamber_passes_pre_crossover %in% c(1,2),]

training.general<-training.general[training.general$sent_gov_pre_crossover == 0,]
testing.general<-testing.general[testing.general$sent_gov_pre_crossover == 0,]

training.local<-training.local[training.local$sent_gov_pre_crossover == 0,]
testing.local<-testing.local[testing.local$sent_gov_pre_crossover == 0,]


f.general<-lrm(
passed~
rcs(days_from_crossover_last_moved,5)+
leg_election_year+
bi_partisan_sponsorship+
minority_sponsors_cut+
document_type+
majority_leadership_author+
chamber_leader_sponsor+
floor_leader_sponsor+
rules_chair_sponsor+
chamber_passes_pre_crossover,data=training.general,x=T,y=T)



f.local<-lrm(
passed~
days_from_crossover_last_moved+
minority_sponsors_cut+
chamber_passes_pre_crossover+
last_precross_move_withdrawn_tabled,data=training.local,x=T,y=T)


testing.combined<-rbind(testing.general,testing.local)
predict.local<-predict(f.local,testing.local,type="fitted")
predict.general<-predict(f.general,testing.general,type="fitted")
predict.combined<-c(predict.general,predict.local)


id<-rownames(testing.combined)
results <- data.frame(id)
results$bill_passed<-testing.combined$passed
results$bill_id<-testing.combined$bill_id
results$prediction<-predict.combined

dbWriteTable(con,name = "predictions",value=results, overwrite = TRUE,field.types=list(id="INT", bill_passed="INT", bill_id="INT",prediction="double"), row.names=FALSE)


