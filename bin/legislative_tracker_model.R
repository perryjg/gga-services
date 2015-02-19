library(RMySQL)
library(rms)

gga_host<-Sys.getenv("GGA_HOST")
gga_user<-Sys.getenv("GGA_USER")
gga_password<-Sys.getenv("GGA_PASSWORD")
gga_database<-Sys.getenv("GGA_DATABASE")

con <-dbConnect(MySQL(), user = gga_user, password = gga_password, host = gga_host, dbname = gga_database)


testing<-dbGetQuery(con,
    "SELECT *,if((summary_city_of = 1 or summary_county_names=1),1,if(leg_day_status>2,1,0)) as crossed_over,
    if(leg_day_status>1,1,0) as out_comm1,
    if(leg_day_status>2,1,0) as pass1,
    if(leg_day_status>3,1,0) as out_comm2
    FROM bills_attributes_historical
    WHERE session_id=24
    AND leg_day_status NOT IN (0,6)")

testing <-testing[testing$status_date == max(testing$status_date),]


#OUR MODEL SPECIFICATIONS
#f<-lrm(
#passed_year_submitted~
#(rcs(days_from_may_submitted,5)+
#rcs(majority_sponsors_cut,6)+
#rcs(minority_sponsors_cut,6)+
#summary_amend_cat+
#leg_election_year+
#bi_partisan_sponsorship+
#document_type+
#author_category_chairs+
#rules_chair_sponsor+
#chamber_leader_sponsor
#)*
#local_inferred*
#rcs(leg_days_remaining,3)+
#floor_leader_sponsor+
#minority_leader_sponsor+
#majority_leadership_sponsor+
#majority_chairman_sponsor+
#summary_tax+
#summary_social+
#summary_health+
#summary_new_charter+
#yeas_pass1_percent+
#yeas_amend_percent+
#crossed_over+
#rcs(leg_days_since_last_status_granular,3)+
#rcs(leg_days_since_last_status,3)*rcs(leg_days_remaining,3)*(out_comm1+out_comm2+pass1+amend)+
#(out_comm1+out_comm2)*local_inferred*rcs(leg_days_remaining,3)+
#(out_comm1+out_comm2)*local_inferred*rcs(leg_days_since_last_status,3),data=training[training$leg_day_status != 6,],x=T,y=T)

#Import saved model
load(paste(getwd(),"/gga-services/bin/legislative_model.rda", sep=""))

#get CIs
pred.logit.f <- predict(f,testing,se.fit=TRUE)
f.ci<-plogis(with(pred.logit.f,linear.predictors + 1.96*cbind(-se.fit,se.fit)))


id<-rownames(testing)
results <- data.frame(id)
results$bill_id<-testing$bill_id
results$bill_passed<-testing$passed_year_submitted
results$prediction<-predict(f,testing,type="fitted")
results$upper<-f.ci[,2]
results$lower<-f.ci[,1]



dbWriteTable(con,name = "predictions",value=results, overwrite = TRUE,field.types=list(id="INT", bill_id="INT",bill_passed="INT",prediction="double",upper="double",lower="double"), row.names=FALSE)

