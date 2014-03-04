library(RMySQL)
library(rms)


con <-dbConnect(MySQL(), user = "ajcnews", password = "KbZ776Pd", host = "ajc-intranet.cgmwsizvte0i.us-east-1.rds.amazonaws.com", dbname = "predictions")


training_frame <- dbGetQuery(con,
    "select id as bill_id, 
	   if(document_type='SB',1,0) as document_type,
	   session_id,
           if(chamber_leader_author=1,6,if(rules_chair_author=1,5,if(floor_leader_author,4,if(majority_chairman_author=1,3,if(minority_leader_author=1,2,majority_party_author))))) as author_category_chairs,
           if(chamber_leader_author=1,5,if(rules_chair_author=1,4,if(floor_leader_author,3,if(majority_chairman_author=1,2,majority_party_author)))) as author_category_chairs_new,
	   if(leg_year_submitted in ('2000','2002','2004','2006','2008','2010','2012','2014'),1,0) as leg_election_year,
	   if(minority_sponsors>4,5,minority_sponsors) as minority_sponsors_cut,
	   if(YEAR(min_movement_date_second_year)>leg_year_submitted,1,0) as movement_second_year,
	   if(sent_gov_date is null or date(sent_gov_date)>date(crossover_date_second),0,1) as sent_gov_pre_crossover,
	   if(out_committee_date is null or date(out_committee_date)>date(crossover_date_second),0,1) as out_committee_pre_crossover,
	   if(chamber_passes>0 and date(min_pass_date)<=date(crossover_date_second),1,0) as passed_one_pre_crossover,
	   if(min_movement_date_second_year is not null,1,0) as movement_second_year,
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
	   if(majority_chairman_author=1 or chamber_leader_author=1 or rules_chair_author=1 or floor_leader_author=1,1,0) as majority_leadership_author,
	   days_from_may_submitted,
	   days_from_may_out_committee,
	   days_from_may_passed_first,
	   days_from_may_passed_second,
	   out_committee_first_year,
	   out_committee,
	   chamber_passes,
	   if(minority_leader_sponsor>0,1,0) as minority_leader_sponsor,
	   if(rules_chair_sponsor>0,1,0) as rules_chair_sponsor,
	   if(chamber_leader_sponsor>0,1,0) as chamber_leader_sponsor,
	   if(floor_leader_sponsors>1,1,0) as floor_leader_sponsor,
	   passed
	   from bills_attributes_working_version
	   where author_party is not null and session_id IN ('18','20')")


testing <- dbGetQuery(con,
    "select id as bill_id, 
	   if(document_type='SB',1,0) as document_type,
	   session_id,
           if(chamber_leader_author=1,6,if(rules_chair_author=1,5,if(floor_leader_author,4,if(majority_chairman_author=1,3,if(minority_leader_author=1,2,majority_party_author))))) as author_category_chairs,
           if(chamber_leader_author=1,5,if(rules_chair_author=1,4,if(floor_leader_author,3,if(majority_chairman_author=1,2,majority_party_author)))) as author_category_chairs_new,
	   if(leg_year_submitted in ('2000','2002','2004','2006','2008','2010','2012','2014'),1,0) as leg_election_year,
	   if(summary_amend_act=1,1,if(summary_amend_title=1,2,if(summary_amend_chapter=1,3,if(summary_amend_article=1,4,if(summary_amend_code=1,5,0))))) as summary_amend_cat_expanded,
	   if(majority_sponsors>4,5,majority_sponsors) as majority_sponsors_cut,
	   if(minority_sponsors>4,5,minority_sponsors) as minority_sponsors_cut,
	   if(YEAR(min_movement_date_second_year)>leg_year_submitted,1,0) as movement_second_year,
	   if(sent_gov_date is null or date(sent_gov_date)>date(crossover_date_second),0,1) as sent_gov_pre_crossover,
	   if(out_committee_date is null or date(out_committee_date)>date(crossover_date_second),0,1) as out_committee_pre_crossover,
	   if(chamber_passes>0 and date(min_pass_date)<=date(crossover_date_second),1,0) as passed_one_pre_crossover,
	   if(min_movement_date_second_year is not null,1,0) as movement_second_year,
	   local_label,
	   bi_partisan_sponsorship,
	   rules_chair_author,
	   majority_chairman_author,
	   chamber_leader_author,
	   majority_sponsors,
	   minority_sponsors,
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
	   if(majority_chairman_author=1 or chamber_leader_author=1 or rules_chair_author=1 or floor_leader_author=1,1,0) as majority_leadership_author,
	   days_from_may_submitted,
	   summary_county_names,
	   summary_city_of,
	   movement_second_year,
	   days_from_may_out_committee,
	   days_from_may_passed_first,
	   days_from_may_passed_second,
	   out_committee,
	   chamber_passes,
	   cross_first_year,
	   if(minority_leader_sponsor>0,1,0) as minority_leader_sponsor,
	   if(rules_chair_sponsor>0,1,0) as rules_chair_sponsor,
	   if(chamber_leader_sponsor>0,1,0) as chamber_leader_sponsor,
	   if(floor_leader_sponsors>1,1,0) as floor_leader_sponsor,
	   passed
	   from bills_attributes_working_version
	   where author_party is not null and session_id IN ('21')")

#results <-dbGetQuery(con, "select * from predictions_joined")
#                   
#newrow = c(12,1,24,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,40,0,0,0,0,0,0)

#testing = rbind(testing,newrow)



training<-data.frame(as.factor(training_frame$passed))
colnames(training)[1]<-"passed"
training$passed<-as.factor(training_frame$passed)
training$author_category<-as.factor(training_frame$author_category)
training$summary_amend_act<-as.factor(training_frame$summary_amend_act)
training$summary_homestead<-as.factor(training_frame$summary_homestead)
training$summary_tax<-as.factor(training_frame$summary_tax)
training$summary_regulate<-as.factor(training_frame$summary_regulate)
training$summary_to_authorize<-as.factor(training_frame$summary_to_authorize)
training$summary_new_charter<-as.factor(training_frame$summary_new_charter)
training$summary_city<-as.factor(training_frame$summary_city)
training$summary_county<-as.factor(training_frame$summary_county)
training$summary_office<-as.factor(training_frame$summary_office)
training$summary_election<-as.factor(training_frame$summary_election)
training$summary_social<-as.factor(training_frame$summary_social)
training$summary_health<-as.factor(training_frame$summary_health)
training$leg_election_year<-as.factor(training_frame$leg_election_year)
training$days_from_may_submitted<-training_frame$days_from_may_submitted
training$majority_sponsors<-training_frame$majority_sponsors
training$minority_sponsors<-training_frame$minority_sponsors
training$summary_local_new<-as.factor(training_frame$summary_local_new)
training$majority_sponsors_cut<-training_frame$majority_sponsors_cut
training$minority_sponsors_cut<-training_frame$minority_sponsors_cut
training$summary_amend_cat<-as.factor(training_frame$summary_amend_cat)
training$rules_chair_sponsor<-as.factor(training_frame$rules_chair_sponsor)
training$minority_leader_sponsor<-as.factor(training_frame$minority_leader_sponsor)
training$chamber_leader_sponsor<-as.factor(training_frame$chamber_leader_sponsor)
training$bi_partisan_sponsorship<-as.factor(training_frame$bi_partisan_sponsorship)
training$author_category_chairs<-as.factor(training_frame$author_category_chairs)
training$floor_leader_sponsor<-as.factor(training_frame$floor_leader_sponsor)
training$author_category_chairs_new<-as.factor(training_frame$author_category_chairs_new)
training$bills_local<-as.factor(training_frame$bills_local)
training$majority_party_author<-as.factor(training_frame$majority_party_author)
training$days_from_may_out_committee<-training_frame$days_from_may_out_committee
training$movement_second_year_committee<-as.factor(training_frame$movement_second_year_committee)
training$days_from_may_passed_first<-training_frame$days_from_may_passed_first
training$days_from_may_passed_second<-training_frame$days_from_may_passed_second
training$out_committee<-as.factor(training_frame$out_committee)
training$chamber_passes<-as.factor(training_frame$chamber_passes)
training$movement_second_year_cross<-as.factor(training_frame$movement_second_year_cross)
training$document_type<-as.factor(training_frame$document_type)
training$cross_first_year<-as.factor(training_frame$cross_first_year)
training$majority_chairman_sponsors<-training_frame$majority_chairman_sponsors
training$majority_chairman_author<-as.factor(training_frame$majority_chairman_author)
training$chamber_leader_author<-as.factor(training_frame$chamber_leader_author)
training$rules_chair_author<-as.factor(training_frame$rules_chair_author)
training$majority_leadership_author<-as.factor(training_frame$majority_leadership_author)
training$sent_gov_first_year<-as.factor(training_frame$sent_gov_first_year)
training$out_committee_first_year<-as.factor(training_frame$out_committee_first_year)
training$sent_gov_pre_crossover<-as.factor(training_frame$sent_gov_pre_crossover)
training$out_committee_pre_crossover<-as.factor(training_frame$out_committee_pre_crossover)
training$passed_one_pre_crossover<-as.factor(training_frame$passed_one_pre_crossover)
training$movement_second_year<-as.factor(training_frame$movement_second_year)
training$local_label<-as.factor(training_frame$local_label)




dd<-datadist(training)
options(datadist='dd')


training.general<-training[training$local_label == 0,]
testing.general<-testing[testing$local_label == 0,]
training.local<-training[training$local_label == 1,]
testing.local<-testing[testing$local_label == 1,]



training.general<-training.general[training.general$chamber_passes %in% c(1,2),]
testing.general<-testing.general[testing.general$chamber_passes %in% c(1,2),]

training.general<-training.general[training.general$sent_gov_pre_crossover == 0,]
testing.general<-testing.general[testing.general$sent_gov_pre_crossover == 0,]

training.local<-training.local[training.local$sent_gov_pre_crossover == 0,]
testing.local<-testing.local[testing.local$sent_gov_pre_crossover == 0,]




f.general<-lrm(
passed~
rcs(days_from_may_passed_first)+
movement_second_year+
leg_election_year+
bi_partisan_sponsorship+
document_type+
majority_leadership_author+
chamber_leader_sponsor+
rules_chair_sponsor+
floor_leader_sponsor,data=training.general,x=T,y=T)


f.local<-lrm(
passed~
rcs(days_from_may_submitted)+
movement_second_year+
out_committee_pre_crossover+
leg_election_year+
minority_sponsors_cut+
bi_partisan_sponsorship+
document_type+
summary_homestead,data=training.local,x=T,y=T)


pred.logit.f.general <- predict(f.general,testing.general)
phat.f.general <- 1/(1+exp(-pred.logit.f.general))
pred.logit.f.local <- predict(f.local,testing.local)
phat.f.local <- 1/(1+exp(-pred.logit.f.local))

testing.combined<-rbind(testing.general,testing.local)
phat.f.combined<-c(phat.f.general,phat.f.local)

par<-par(mfrow=c(1,1))
source('val.prob.s')
val.prob.f<-val.prob(phat.f.combined, testing.combined$passed, cex=.8, pl=TRUE, m=20)


par<-par(mfrow=c(2,1))
source('val.prob.s')
val.prob.f.local<-val.prob(phat.f.local, testing.local$passed, cex=.8, pl=TRUE, m=20)
source('val.prob.s')
val.prob.f.general<-val.prob(phat.f.general, testing.general$passed, cex=.8, pl=TRUE, m=20)




