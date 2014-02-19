BEGIN

  update watched_bills, bills
  set watched_bills.predictions = bills.predictions,
    watched_bills.status_description = bills.status_description,
    watched_bills.status_date = bills.status_date,
    watched_bills.bill_passed = bills.bill_passed,
    watched_bills.passed_over = bills.passed_over
  where watched_bills.bill_id = bills.id;
END