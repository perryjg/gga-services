library(RMySQL)
library(rms)
library(log4r)

logger <- create.logger()
logfile(logger) <- 'logs/model.log'
level(logger) <- 'DEBUG'

gga_host<-Sys.getenv("GGA_HOST")
gga_user<-Sys.getenv("GGA_USER")
gga_password<-Sys.getenv("GGA_PASSWORD")
gga_database<-Sys.getenv("GGA_DATABASE")

con <-dbConnect(MySQL(), user = gga_user, password = gga_password, host = gga_host, dbname = gga_database)
debug(logger, "DB connection successful")

data<-dbGetQuery(con,
    "SELECT *,if((local_inferred = 1),1,if(leg_day_status>2,1,0)) as crossed_over,
    if(past_cross_over = 1 AND YEAR(status_date)<>leg_year_submitted,1,0) as past_cross_over_year_2,
    if(leg_year_submitted = YEAR(status_date),1,0) AS submitted_same_session,
    if(leg_day_status=1,1,0) as submitted,
    if(leg_day_status=2,1,0) as out_comm1,
    if(leg_day_status=3,1,0) as pass1,
    if(leg_day_status=4,1,0) as out_comm2,
    if(leg_day_status=5,1,0) as amend,
    CURDATE() as prediction_date
    FROM bills_attributes_historical
    WHERE leg_day_status NOT IN (0,6)
    AND session_id=24")

testing <-data[data$status_date == max(data$status_date),]

if(min(testing$leg_days_remaining) < 10) {
	testing <-testing[ testing$crossed_over == 1,]
}

testing_reg<-testing[testing$submitted_same_session == 1,]
testing_lo<-testing[testing$submitted_same_session == 0,]

#GET TRAINING DATA SET OF ONLY LIVE BILLS
#training_leftovers<-training[training$submitted_same_session == 0,]
#training_regular<-training[training$submitted_same_session == 1,]

#training_cross_leftovers<-training_leftovers[training$crossed_over == 1,]
#training_cross_leftovers<-training_cross_leftovers[training_cross_leftovers$past_cross_over_year_2 == 1,]
#training_cross_leftovers<-training_cross_leftovers[training_cross_leftovers$leg_days_remaining > 0,]
#
#training_non_cross_leftovers<-training_leftovers[training_leftovers$past_cross_over_year_2 == 0,]
#
#training_combined_leftovers<-rbind(training_cross_leftovers,training_non_cross_leftovers)
#
#training_cross_regular<-training_regular[training$crossed_over == 1,]
#training_cross_regular<-training_cross_regular[training_cross_regular$past_cross_over == 1,]
#training_cross_regular<-training_cross_regular[training_cross_regular$leg_days_remaining > 0,]
#
#training_non_cross_regular<-training_regular[training_regular$past_cross_over == 0,]
#
#training_combined_regular<-rbind(training_cross_regular,training_non_cross_regular)

#OUR MODEL SPECIFICATIONS
#f_reg<-lrm(
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
#data = training_combined_regular, x = T, y = T)

#f_lo<-lrm(
#passed_second_year ~
#author_category_chairs_group_caucus_rules_chamber+
#(some_movement_second_year+
#rcs(majority_sponsors_cut, 3) *
#rcs(minority_sponsors_cut, 3) +
#summary_amend_cat +
#document_type +
#chamber_leader_sponsor +
#submitted +
#out_comm1 +
#out_comm2 +
#rcs(yeas_pass1_percent,3) +
#yeas_amend_percent +
#floor_leader_sponsors +
#rcs(leg_days_since_last_status,3) +
#rcs(leg_days_remaining,8)) *
#local_inferred +
#rules_chair_sponsor +
#rcs(yeas_pass1_percent,3)*
#(some_movement_second_year+
#rcs(leg_days_since_last_status,3) +
#rcs(leg_days_remaining,8))+
#minority_leader_sponsor +
#majority_caucus_leadership_sponsors +
#majority_chairman_sponsor +
#summary_tax +
#summary_social +
#summary_health +
#rcs(nays_pass1_percent,3),
#data = training_combined_leftovers, x = T, y = T)

#Import saved model
load(paste(getwd(),"/gga-services/bin/legislative_models.rda", sep=""))
debug(logger, "Model loaded")

#Write predictions to MySQL server
id<-rownames(testing_reg)
results_reg <- data.frame(id)
results_reg$bill_id<-testing_reg$bill_id
results_reg$bill_passed<-testing_reg$passed_year_submitted
results_reg$prediction_date<-testing_reg$prediction_date
results_reg$legislative_day_date<-testing_reg$status_date
results_reg$legislative_days_remaining<-testing_reg$leg_days_remaining
results_reg$legislative_status<-testing_reg$leg_day_status
results_reg$prediction<-predict(f_reg,testing_reg,type="fitted")

id<-rownames(testing_lo)
results_lo <- data.frame(id)
results_lo$bill_id<-testing_lo$bill_id
results_lo$bill_passed<-testing_lo$passed_second_year
results_lo$prediction_date<-testing_lo$prediction_date
results_lo$legislative_day_date<-testing_lo$status_date
results_lo$legislative_days_remaining<-testing_lo$leg_days_remaining
results_lo$legislative_status<-testing_lo$leg_day_status
results_lo$prediction<-predict(f_lo,testing_lo,type="fitted")

results<-rbind(results_reg,results_lo)

#fix prediction for budget at 1
#results[results$bill_id==42877,]$prediction<-1


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
debug(logger, "Predictions archived")


