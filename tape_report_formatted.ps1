#BEMCLI module can be found @:
# import-module "C:\Program Files\Veritas\Backup Exec\Modules\BEMCLI"

$date = Get-Date -Format MM.dd.yyyy
$Jobs = Get-BEStorage|where name -clike 'T*'| Get-BEJobHistory -FromLastJobRun -JobStatus Succeeded 
$CompleteRE = [regex] "(Job ended: [a-zA-Z]{0,9}\, [a-zA-Z]{0,9} \d{0,2}\, \d\d\d\d (at) \d{0,2}\:\d\d\:\d\d (AM|PM))"

$finalRun = foreach($_ in $Jobs){

 #Converts each line in a job log from the job history list captured in the $Jobs variable to objects
 $backups = $_ |Get-BEJobLog |ConvertFrom-String -delimiter ([environment]::NewLine) 

 #Searches each enumerated log for a pattern matching "Media Label: 000XXXL6"
 $test = $backups | select-string -Pattern "\w*Media Label: \d+\w\d" -AllMatches |Sort-Object |get-unique
 $run = $backups |select-string -Pattern $CompleteRE |sort |Get-Unique
 #Write to host the name of the job and its associated media label w/ job start date (EX. RUNJOB contains Media Label: 000145L6. Job started: Monday, January 1, 20XX) 
 Write-Output "$($_.name) contains: "  |SORT|Get-Unique |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 if($test.matches.count -gt 1){
  write-output "------> $($test.matches.value[0])."|Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "------> $($test.matches.value[1])." |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "------> $($BACKUPS.P5)"  |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "------> $($run.matches.value)" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "************************"  |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "\/\/\/\/\/\/\/\/\/\/\/\/" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 }else{

 write-output "------> $($test.matches.value)."  |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 write-output "------> $($BACKUPS.P5)" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 write-output "------> $($run.matches.value)" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 write-output "************************"  |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 write-output "\/\/\/\/\/\/\/\/\/\/\/\/" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 }




 #Check for jobs that were successfull with exceptions
 write-host "Checking for jobs that were successful w/ exceptions:" -BackgroundColor Red
write-host " "
write-host " "

$Jobs = Get-BEStorage|where name -clike 'T*'| Get-BEJobHistory -FromLastJobRun -JobStatus SucceededWithExceptions 
$CompleteRE = [regex] "(Job ended: [a-zA-Z]{0,9}\, [a-zA-Z]{0,9} \d{0,2}\, \d\d\d\d (at) \d{0,2}\:\d\d\:\d\d (AM|PM))"

$finalRun = foreach($_ in $Jobs){

 #Converts each line in a job log from the job history list captured in the $Jobs variable to objects
 $backups = $_ |Get-BEJobLog |ConvertFrom-String -delimiter ([environment]::NewLine) 

 #Searches each enumerated log for a pattern matching "Media Label: 000XXXL6"
 $test = $backups | select-string -Pattern "\w*Media Label: \d+\w\d" -AllMatches |Sort-Object |get-unique
 $run = $backups |select-string -Pattern $CompleteRE |sort |Get-Unique
 #Write to host the name of the job and its associated media label w/ job start date (EX. RUNJOB contains Media Label: 000145L6. Job started: Monday, January 1, 20XX) 
 Write-host "$($_.name) contains: "  |SORT|Get-Unique #|Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 if($test.matches.count -gt 1){
  write-output "------> $($test.matches.value[0])."|Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "------> $($test.matches.value[1])." |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "------> $($BACKUPS.P5)"  |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "------> $($run.matches.value)" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "************************"  |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
  write-output "\/\/\/\/\/\/\/\/\/\/\/\/" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 }else{

 write-output "------> $($test.matches.value)."  |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 write-output "------> $($BACKUPS.P5)" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 write-output "------> $($run.matches.value)" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 write-output "************************"  |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 write-output "\/\/\/\/\/\/\/\/\/\/\/\/" |Out-File "[FILEPATH]\BackExecLogs\Tape_Reports\tape_report_$($date).txt" -append 
 }
}





}

