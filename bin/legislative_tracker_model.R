library(RMySQL)
library(rms)

gga_host<-Sys.getenv("GGA_HOST")
gga_user<-Sys.getenv("GGA_USER")
gga_password<-Sys.getenv("GGA_PASSWORD")
gga_database<-Sys.getenv("GGA_DATABASE")

con <-dbConnect(MySQL(), user = gga_user, password = gga_password, host = gga_host, dbname = gga_database)

training_frame <- dbGetQuery(con,
    "select id as bill_id, 
	   if(document_type='SB',1,0) as document_type,
	   session_id,
           if(chamber_leader_author=1,6,if(rules_chair_author=1,5,if(floor_leader_author,4,if(majority_chairman_author=1,3,if(minority_leader_author=1,2,majority_party_author))))) as author_category_chairs,
	   if(leg_year_submitted in ('2000','2002','2004','2006','2008','2010','2012','2014'),1,0) as leg_election_year,
	   if(summary_amend_act=1,1,if(summary_amend_title=1,2,if(summary_amend_chapter=1,3,if(summary_amend_article=1,4,if(summary_amend_code=1,5,0))))) as summary_amend_cat_expanded,
	   if(majority_sponsors>4,5,majority_sponsors) as majority_sponsors_cut,
	   if(minority_sponsors>4,5,minority_sponsors) as minority_sponsors_cut,
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
           if(summary_city_of=1 or summary_county_names=1 or summary_to_authorize=1 or summary_new_charter=1,1,0) as summary_local_new,
	   if(summary_amend_act=0 and summary_amend_any=1,1,if(summary_amend_act=1,2,0)) as summary_amend_cat,
	   days_from_may_submitted,
	   summary_county_names,
	   summary_city_of,
	   minority_leader_sponsor,
	   rules_chair_sponsor,
	   chamber_leader_sponsor,
	   passed
	   from bills_attributes_backup
	   where author_party is not null and session_id IN ('20','21')")


testing <- dbGetQuery(con,
    "select id as bill_id, 
	   if(document_type='SB',1,0) as document_type,
	   session_id,
           if(chamber_leader_author=1,6,if(rules_chair_author=1,5,if(floor_leader_author,4,if(majority_chairman_author=1,3,if(minority_leader_author=1,2,majority_party_author))))) as author_category_chairs,
	   if(leg_year_submitted in ('2000','2002','2004','2006','2008','2010','2012','2014'),1,0) as leg_election_year,
	   if(summary_amend_act=1,1,if(summary_amend_title=1,2,if(summary_amend_chapter=1,3,if(summary_amend_article=1,4,if(summary_amend_code=1,5,0))))) as summary_amend_cat_expanded,
	   if(majority_sponsors>4,5,majority_sponsors) as majority_sponsors_cut,
	   if(minority_sponsors>4,5,minority_sponsors) as minority_sponsors_cut,
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
           if(summary_city_of=1 or summary_county_names=1 or summary_to_authorize=1 or summary_new_charter=1,1,0) as summary_local_new,
	   if(summary_amend_act=0 and summary_amend_any=1,1,if(summary_amend_act=1,2,0)) as summary_amend_cat,
	   days_from_may_submitted,
	   summary_county_names,
	   summary_city_of,
	   minority_leader_sponsor,
	   rules_chair_sponsor,
	   chamber_leader_sponsor,
	   passed
	   from bills_attributes_backup
	   where author_party is not null and session_id IN ('23')")



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
training$independent_sponsors<-as.factor(training_frame$sponsors_independent)
training$summary_local_new<-as.factor(training_frame$summary_local_new)
training$majority_sponsors_cut<-training_frame$majority_sponsors_cut
training$minority_sponsors_cut<-training_frame$minority_sponsors_cut
training$summary_amend_cat<-as.factor(training_frame$summary_amend_cat)
training$rules_chair_sponsor<-as.factor(training_frame$rules_chair_sponsor)
training$minority_leader_sponsor<-as.factor(training_frame$minority_leader_sponsor)
training$chamber_leader_sponsor<-as.factor(training_frame$chamber_leader_sponsor)
training$bi_partisan_sponsorship<-as.factor(training_frame$bi_partisan_sponsorship)
training$author_category_chairs<-as.factor(training_frame$author_category_chairs)





dd<-datadist(training)
options(datadist='dd')

f<-lrm(
passed~
rcs(days_from_may_submitted,7)+
(rcs(majority_sponsors_cut,5)+
rcs(minority_sponsors_cut,5)+
summary_amend_cat)*
summary_local_new+
author_category_chairs+
rules_chair_sponsor+
chamber_leader_sponsor+
leg_election_year+
bi_partisan_sponsorship+
summary_homestead+
minority_leader_sponsor+
summary_tax+
summary_social+
summary_health,data=training,x=T,y=T)


id<-rownames(testing)
results <- data.frame(id)
results$bill_passed<-testing$passed
results$bill_id<-testing$bill_id
results$prediction<-predict(f,testing,type="fitted")

dbWriteTable(con,name = "predictions",value=results, overwrite = TRUE,field.types=list(id="INT", bill_passed="INT", bill_id="INT",prediction="double"), row.names=FALSE)

