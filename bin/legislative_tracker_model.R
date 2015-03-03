library(RMySQL)
library(rms)

gga_host<-Sys.getenv("GGA_HOST")
gga_user<-Sys.getenv("GGA_USER")
gga_password<-Sys.getenv("GGA_PASSWORD")
gga_database<-Sys.getenv("GGA_DATABASE")

con <-dbConnect(MySQL(), user = gga_user, password = gga_password, host = gga_host, dbname = gga_database)


data<-dbGetQuery(con,
    "SELECT *,if((summary_city_of = 1 or summary_county_names=1),1,if(leg_day_status>2,1,0)) as crossed_over,
    if(leg_day_status=1,1,0) as submitted,
    if(leg_day_status=2,1,0) as out_comm1,
    if(leg_day_status=3,1,0) as pass1,
    if(leg_day_status=4,1,0) as out_comm2,
    if(leg_day_status=5,1,0) as amend,
    CURDATE() as prediction_date
    FROM bills_attributes_historical
    WHERE leg_day_status NOT IN (0,6)")

testing <-data[data$status_date == max(data$status_date),]



#GET TRAINING DATA SET OF ONLY LIVE BILLS
#training <- data[data$session_id in c(14,18,20,21,23),]

#training_cross<-training[training$crossed_over == 1,]
#training_cross<-training_cross[training_cross$leg_days_remaining < 11,]
#training_cross<-training_cross[training_cross$leg_days_remaining > 0,]

#training_non_cross<-training[training$leg_days_remaining > 10,]

#training_combined<-rbind(training_cross,training_non_cross)
#training_combined<-training_combined[training_combined$leg_day_status != 6,]
#training_combined<-training_combined[training_combined$leg_day_status != 0,]



#OUR MODEL SPECIFICATIONS
#f<-lrm(
#passed_year_submitted ~
#(rcs(leg_days_remaining_submitted,5) +
#rcs(majority_sponsors_cut, 3) *
#rcs(minority_sponsors_cut, 3) +
#summary_amend_cat +
#leg_election_year +
#document_type + 
#author_category_chairs +
#rules_chair_sponsor +
#chamber_leader_sponsor + 
#submitted +
#out_comm1 +
#out_comm2 +
#rcs(yeas_pass1_percent,3) +
#yeas_amend_percent +
#floor_leader_sponsors + 
#rcs(leg_days_since_last_status,4) +
#rcs(leg_days_remaining,10)) *
#local_inferred +
#rcs(yeas_pass1_percent,3)*
#(rcs(leg_days_since_last_status,4) +
#rcs(leg_days_remaining,10))+
#minority_leader_sponsor +
#rcs(majority_caucus_leadership_sponsors, 4) +
#majority_chairman_sponsor + 
#summary_tax +
#summary_social +
#summary_health +
#rcs(nays_pass1_percent,3),
#data = training_combined, x = T, y = T)

#Import saved model
load(paste(getwd(),"/gga-services/bin/legislative_model.rda", sep=""))

#Write predictions to MySQL server
id<-rownames(testing)
results <- data.frame(id)
results$bill_id<-testing$bill_id
results$bill_passed<-testing$passed_year_submitted
results$prediction_date<-testing$prediction_date
results$legislative_day_date<-testing$status_date
results$legislative_days_remaining<-testing$leg_days_remaining
results$legislative_status<-testing$leg_day_status
results$prediction<-predict(f,testing,type="fitted")


#fix prediction for budget at 1
results[results$bill_id==42877,]$prediction<-1


dbWriteTable(con,name = "predictions",value=results, overwrite = TRUE,field.types=list(id="INT", bill_id="INT",bill_passed="INT",prediction_date="date",legislative_day_date="date",legislative_days_remaining="INT",legislative_status="INT",prediction="double"), row.names=FALSE)



#looping over the predictions and injecting them with timestamp as ID

rows<-nrow(results)
cols<-ncol(results)

for (i in seq(1,rows,1)){
    record_statement<-paste(sep="","INSERT IGNORE INTO predictions_history VALUES(CONCAT('",results[i,]$bill_id,"',UNIX_TIMESTAMP('",results[i,]$legislative_day_date,"'),UNIX_TIMESTAMP('",results[i,]$prediction_date,"'))")
    for (j in seq(2,cols,1)){
        record_statement<-paste(sep="",record_statement,",'",results[i,][j],"'")
    }
    record_statement<-paste(record_statement,")")
    #print(record_statement)
    dbSendQuery(con,record_statement)
}

