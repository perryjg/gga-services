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
           if(chamber_leader_author=1,7,if(rules_chair_author=1,6,if(floor_leader_author,5,if(majority_leadership_author,4,if(majority_chairman_author=1,3,if(minority_leader_author=1,2,majority_party_author)))))) as author_category_chairs,
	   if(leg_year_submitted in ('2000','2002','2004','2006','2008','2010','2012','2014','2016','2018'),1,0) as leg_election_year,
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
           local_label,
           if(summary_city_of=1 or summary_county_names=1 or summary_to_authorize=1 or summary_new_charter=1,1,0) as summary_local_new,
	   if(summary_amend_act=0 and summary_amend_any=1,1,if(summary_amend_act=1,2,0)) as summary_amend_cat,
	   days_from_may_submitted,
	   summary_county_names,
	   summary_city_of,
	   if(minority_leader_sponsor>0,1,0) as minority_leader_sponsor,
	   if(rules_chair_sponsor>0,1,0) as rules_chair_sponsor,
	   if(chamber_leader_sponsor>0,1,0) as chamber_leader_sponsor,
	   if(majority_leadership_sponsors>0,1,0) as majority_leadership_sponsor,
	   if(floor_leader_sponsors>0,1,0) as floor_leader_sponsor,
	   IF(YEAR(sent_gov_date)=leg_year_submitted,1,0) AS passed
	   from bills_attributes
	   where author_party is not null and session_id IN ('14','18','20','21','23')
	   and IF(leg_year_submitted IN ('2000','2002','2004','2006','2008','2010','2012','2014','2016','2018'),1,0)=0")


testing <- dbGetQuery(con,
    "select id as bill_id, 
	   if(document_type='SB',1,0) as document_type,
	   session_id,
           if(chamber_leader_author=1,7,if(rules_chair_author=1,6,if(floor_leader_author,5,if(majority_leadership_author,4,if(majority_chairman_author=1,3,if(minority_leader_author=1,2,majority_party_author)))))) as author_category_chairs,
	   if(leg_year_submitted in ('2000','2002','2004','2006','2008','2010','2012','2014','2016','2018'),1,0) as leg_election_year,
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
           local_label,
           if(summary_city_of=1 or summary_county_names=1 or summary_to_authorize=1 or summary_new_charter=1,1,0) as summary_local_new,
	   if(summary_amend_act=0 and summary_amend_any=1,1,if(summary_amend_act=1,2,0)) as summary_amend_cat,
	   days_from_may_submitted,
	   summary_county_names,
	   summary_city_of,
	   if(minority_leader_sponsor>0,1,0) as minority_leader_sponsor,
	   if(rules_chair_sponsor>0,1,0) as rules_chair_sponsor,
	   if(chamber_leader_sponsor>0,1,0) as chamber_leader_sponsor,
	   if(majority_leadership_sponsors>0,1,0) as majority_leadership_sponsor,
	   if(floor_leader_sponsors>0,1,0) as floor_leader_sponsor,
	   IF(YEAR(sent_gov_date)=leg_year_submitted,1,0) AS passed
	   from bills_attributes
	   where author_party is not null and session_id IN ('24')
	   and IF(leg_year_submitted IN ('2000','2002','2004','2006','2008','2010','2012','2014','2016','2018'),1,0)=0")



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
training$majority_leadership_sponsor<-as.factor(training_frame$majority_leadership_sponsor)
training$local_label<-as.factor(training_frame$local_label)
training$floor_leader_sponsor<-as.factor(training_frame$floor_leader_sponsor)



dd<-datadist(training)
options(datadist='dd')

f<-lrm(
passed~
rcs(days_from_may_submitted,7)+
(rcs(majority_sponsors_cut,5)+
rcs(minority_sponsors_cut,5)+
summary_amend_cat)*
local_label+
author_category_chairs+
rules_chair_sponsor+
chamber_leader_sponsor+
bi_partisan_sponsorship+
summary_homestead+
minority_leader_sponsor+
floor_leader_sponsor+
majority_leadership_sponsor+
summary_tax+
summary_social+
summary_health,data=training,x=T,y=T)


#get CIs
pred.logit.f <- predict(f,testing,se.fit=TRUE)
f.ci<-plogis(with(pred.logit.f,linear.predictors + 1.96*cbind(-se.fit,se.fit)))


id<-rownames(testing)
results <- data.frame(id)
results$bill_passed<-testing$passed
results$bill_id<-testing$bill_id
results$prediction<-predict(f,testing,type="fitted")
results$upper<-f.ci[,2]
results$lower<-f.ci[,1]

dbWriteTable(con,name = "predictions",value=results, overwrite = TRUE,field.types=list(id="INT", bill_passed="INT", bill_id="INT",prediction="double",upper="double",lower="double"), row.names=FALSE)

