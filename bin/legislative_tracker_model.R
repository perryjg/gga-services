
library(RMySQL)
library(rms)


con <-dbConnect(MySQL(), user = "ggaservice", password = "serviceat223", host = "ajc-web.cgmwsizvte0i.us-east-1.rds.amazonaws.com", dbname = "gga_staging")


training_frame <- dbGetQuery(con,
    "select id as bill_id, if(document_type='SB',1,0) as document_type,
           if(chamber_leader_author=1,2,majority_party_author) as author_category,
	   minority_sponsors,
	   majority_sponsors,
           sponsors_independent,
	   if(leg_year_submitted in ('2000','2002','2004','2006','2008','2010','2012','2014'),1,0) as leg_election_year,
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
	   days_from_may_submitted,
	   passed
	   from bills_attributes
	   where author_party is not null and session_id IN ('20','21')")



testing <- dbGetQuery(con,
    "select id as bill_id, if(document_type='SB',1,0) as document_type,
           if(chamber_leader_author=1,2,majority_party_author) as author_category,
	   minority_sponsors,
	   majority_sponsors,
           sponsors_independent,
	   if(leg_year_submitted in ('2000','2002','2004','2006','2008','2010','2012','2014'),1,0) as leg_election_year,
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
	   days_from_may_submitted,
	   passed
	   from bills_attributes
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


dd<-datadist(training)
options(datadist='dd')

f<-lrm(
passed~
rcs(days_from_may_submitted,4)+
rcs(majority_sponsors,7)+
rcs(minority_sponsors,7)+
author_category+
leg_election_year+
summary_amend_act+
summary_homestead+
summary_tax+
summary_regulate+
summary_to_authorize+
summary_new_charter+
summary_city+
summary_county+
summary_election+
summary_office+
summary_social+
summary_health,data=training,x=T,y=T)



id<-rownames(testing)
results <- data.frame(id)
results$bill_id<-testing$bill_id
results$prediction<-predict(f,testing,type="fitted")

dbWriteTable(con,name = "predictions",value=results, overwrite = TRUE,field.types=list(id="INT", bill_id="INT", prediction="double"), row.names=FALSE)
