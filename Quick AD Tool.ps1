#Written by Xavier Fields 10/3/2023

﻿function Show-Menu {
    param (
        [string]$Title = 'Quick AD Tool'
    )
    Clear-Host
    Write-Host "===============//$Title\\================"
    
    Write-Host "Press '1' to get AD info"
    Write-Host "||MUST RUN FIRST|| Press '2' to get select list of properties ||MUST RUN FIRST||" -BackgroundColor Red
    Write-Host "Q: Press 'Q' to quit."
    }
do
 {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
      '1' {
$username = read-host "enter user logon name (ex. cxavier)" 

$userData = get-aduser -server "[DOMAIN]" -Identity $username -Properties * |select *

foreach($property in $props){

    write-host $property ** $userdata.$property -backgroundcolor DarkGreen 

}


    } '2' {
    #Pulls a list of complete AD user properties for selection from a text file. (txt file will need to be recreated when deployed in new environment.)
    #Link to AD attribs @ https://docs.secureauth.com/0903/en/active-directory-attributes-list.html
    $ps = get-content "$env:userprofile\desktop\textfiles\ADprops.txt"

    $props = $ps |out-gridview -PassThru 
    }
    }
    pause
 }
 until ($selection -eq 'q')
