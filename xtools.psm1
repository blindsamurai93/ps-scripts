##Lookup end user info using full name
function XTOOLS-ADusid 
{
Get-ADUser -Server "xxxx" -Filter "samAccountname -like '$args'" -Properties name,samaccountname,mail,info,passwordlastset,lastbadpasswordattempt,lockedout,lockouttime, enabled |select-object -Property name,samaccountname,mail,info,passwordlastset,lastbadpasswordattempt,lockedout,lockouttime, enabled| sort-object -Property samaccountname,mail,location,passwordlastset,lastbadpasswordattempt,lockedout,lockouttime, enabled -Descending |Out-GridView -Title 'User Info'
}



##Lookup end user AD info using ID
function XTOOLS-ADname 
{

$name = read-host 'name?' 
Get-ADUser -Server "xxxx" -Filter 'name -like $name' -Properties name,samaccountname,mail,info,passwordlastset,lastbadpasswordattempt,lockedout,lockouttime, enabled |select-object -Property name,samaccountname,mail,info,passwordlastset,lastbadpasswordattempt,lockedout,lockouttime, enabled| sort-object -Property samaccountname,mail,location,passwordlastset,lastbadpasswordattempt,lockedout,lockouttime, enabled -Descending |Out-GridView -Title $ExecutionContext.InvokeCommand.ExpandString($name) 
}


##Reset AD password
function XTOOLS-PWReset 
{
#New password as variable
$pwd = read-host "enter pwd" -AsSecureString
#Pull user info (The users name in particular) using the $usid variable
$quickad = Get-ADUser -Server xxxx -Identity $args[0] -Properties DistinguishedName
#Reset PW
Set-ADAccountPassword -Server xxxx -Identity $quickad -NewPassword $pwd -Reset
$wshell = New-Object -ComObject Wscript.Shell
$popup = $wshell.Popup('Complete!',0,"OK!",0x1)
}


##Enable end user in AD
function XTOOLS-EnableUser
{
set-addomain 'xxxx'  
$quickad = Get-ADUser -Server 'xxxx' -Identity $args[0] 
Enable-ADAccount -Identity $quickad
dsquery user -samid $args[0] | dsget user -Disabled
}


##Disable end user in AD
function XTOOLS-DisableUser
{
set-addomain 'xxxx'  
$quickad = Get-ADUser -Server 'xxxx' -Identity $args[0] 
Disable-ADAccount -Identity $quickad
dsquery user -samid $args[0] | dsget user -Disabled
}


##Access network drive from PS
function XTOOLS-getnetdrive 
{
start-process $args[0]
}

##Google search from PS
function XTOOLS-google
{
$query=start-process "https://www.google.com/search?q=$args"
}

## short script to access software network folder via PS.
function XTOOLS-QuickCMM{
get-childitem \\xxxx\d$\* |out-gridview -title "CMM List" -passthru|foreach{
start-process $ExecutionContext.InvokeCommand.ExpandString($_)
}
}

## short script to access software network folder via PS.
function XTOOLS-QuickMDC{
get-childitem \\xxxx\* |out-gridview -title "MDC List" -passthru|foreach{
start-process $ExecutionContext.InvokeCommand.ExpandString($_)
}
}



##Automates end user termination process
function xtools-leaver{
$date = get-date 
$pwd = read-host "enter pwd" -AsSecureString
#Pull user info (The users name in particular) using the $usid variable
$quickad = Get-ADUser -Server xxxx -Identity $args[0] -Properties DistinguishedName
#Reset PW
Set-ADAccountPassword -Server xxxx -Identity $quickad -NewPassword $pwd -Reset
#Enable user account
Enable-ADAccount -server xxxx -Identity $quickad
Set-ADAccountExpiration -server xxxx -Identity $quickad -datetime $date.AddDays(1)
dsquery user -samid $args[0] | dsget user -Disabled -acctexpires


$wshell = New-Object -ComObject Wscript.Shell
$popup = $wshell.Popup('Complete!',0,"OK!",0x1)
}




##Unlocks user account in AD
function xtools-ADunlock {
$quickad = Get-ADUser -Server "xxxx" -Filter "samAccountname -like '$args'" -Properties info,City,CN,department,mail,samaccountname,lastbadpasswordattempt,lockedout,lockouttime,lastlogon,passwordlastset
unlock-ADAccount -Identity $quickad 
}



##short script that copies ticket strikes to clipboard for quicker ticket updates. 
function xtools-strike{
$date = get-date -UFormat %m/%d 
set-clipboard "[s1 $date]" } 


##call this function before running xtools-shouldertaps or any other script that requires windows forms.
function set-quickforms {Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
}






##Short script to input shoulder tap info into a spreadsheet for submission to the helpdesk in bulk.
function xtools-shouldertaps {Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
add-type -AssemblyName microsoft.visualbasic

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Tech Bar Sign In'
$form.Size = New-Object System.Drawing.Size(450,250)
$form.StartPosition = 'CenterScreen'

$label = New-Object system.windows.forms.label
$label.text = "Press OK to continue.."
$label.autosize = $true
$form.Controls.Add($label)


$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)


$xl=New-Object -ComObject Excel.Application
$wb=$xl.WorkBooks.Open("C:\Users\us57442\Desktop\shouldertap.xltm")
$ws=$wb.WorkSheets.item(1)

$result = $form.ShowDialog()

$date = get-date -UFormat %m/%d/%y
$Username = [microsoft.visualbasic.interaction]::inputbox('Enter USID','Tech Bar Sign In')
$name = [microsoft.visualbasic.interaction]::inputbox('Enter Name','Tech Bar Sign In')
$problem = [microsoft.visualbasic.interaction]::inputbox('Describe Issue','Tech Bar Sign In')

$form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK){

    $ws.Cells.Item(2,3)= $ExecutionContext.InvokeCommand.ExpandString($username)
    $ws.Cells.Item(2,4)= $ExecutionContext.InvokeCommand.ExpandString($name)
    $ws.Cells.Item(2,5)= $ExecutionContext.InvokeCommand.ExpandString($date)
    $ws.Cells.Item(2,6)= $ExecutionContext.InvokeCommand.ExpandString($problem)





}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $Username = [microsoft.visualbasic.interaction]::inputbox('Enter USID','Tech Bar Sign In')
    $name = [microsoft.visualbasic.interaction]::inputbox('Enter Name','Tech Bar Sign In')
    $problem = [microsoft.visualbasic.interaction]::inputbox('Describe Issue','Tech Bar Sign In')

    $ws.Cells.Item(3,3)= $ExecutionContext.InvokeCommand.ExpandString($username)
    $ws.Cells.Item(3,4)= $ExecutionContext.InvokeCommand.ExpandString($name)
    $ws.Cells.Item(3,5)= $ExecutionContext.InvokeCommand.ExpandString($date)
    $ws.Cells.Item(3,6)= $ExecutionContext.InvokeCommand.ExpandString($problem)

    
    $result = $form.ShowDialog()
}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $Username = [microsoft.visualbasic.interaction]::inputbox('Enter USID','Tech Bar Sign In')
    $name = [microsoft.visualbasic.interaction]::inputbox('Enter Name','Tech Bar Sign In')
    $problem = [microsoft.visualbasic.interaction]::inputbox('Describe Issue','Tech Bar Sign In')

    $ws.Cells.Item(4,3)= $ExecutionContext.InvokeCommand.ExpandString($username)
    $ws.Cells.Item(4,4)= $ExecutionContext.InvokeCommand.ExpandString($name)
    $ws.Cells.Item(4,5)= $ExecutionContext.InvokeCommand.ExpandString($date)
    $ws.Cells.Item(4,6)= $ExecutionContext.InvokeCommand.ExpandString($problem)
    
    $result = $form.ShowDialog()
}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $Username = [microsoft.visualbasic.interaction]::inputbox('Enter USID','Tech Bar Sign In')
    $name = [microsoft.visualbasic.interaction]::inputbox('Enter Name','Tech Bar Sign In')
    $problem = [microsoft.visualbasic.interaction]::inputbox('Describe Issue','Tech Bar Sign In')

    $ws.Cells.Item(5,3)= $ExecutionContext.InvokeCommand.ExpandString($username)
    $ws.Cells.Item(5,4)= $ExecutionContext.InvokeCommand.ExpandString($name)
    $ws.Cells.Item(5,5)= $ExecutionContext.InvokeCommand.ExpandString($date)
    $ws.Cells.Item(5,6)= $ExecutionContext.InvokeCommand.ExpandString($problem)
    
    $result = $form.ShowDialog()
}
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $Username = [microsoft.visualbasic.interaction]::inputbox('Enter USID','Tech Bar Sign In')
    $name = [microsoft.visualbasic.interaction]::inputbox('Enter Name','Tech Bar Sign In')
    $problem = [microsoft.visualbasic.interaction]::inputbox('Describe Issue','Tech Bar Sign In')

    $ws.Cells.Item(6,3)= $ExecutionContext.InvokeCommand.ExpandString($username)
    $ws.Cells.Item(6,4)= $ExecutionContext.InvokeCommand.ExpandString($name)
    $ws.Cells.Item(6,5)= $ExecutionContext.InvokeCommand.ExpandString($date)
    $ws.Cells.Item(6,6)= $ExecutionContext.InvokeCommand.ExpandString($problem)
    
    $result = $form.ShowDialog()
}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $Username = [microsoft.visualbasic.interaction]::inputbox('Enter USID','Tech Bar Sign In')
    $name = [microsoft.visualbasic.interaction]::inputbox('Enter Name','Tech Bar Sign In')
    $problem = [microsoft.visualbasic.interaction]::inputbox('Describe Issue','Tech Bar Sign In')

    $ws.Cells.Item(7,3)= $ExecutionContext.InvokeCommand.ExpandString($username)
    $ws.Cells.Item(7,4)= $ExecutionContext.InvokeCommand.ExpandString($name)
    $ws.Cells.Item(7,5)= $ExecutionContext.InvokeCommand.ExpandString($date)
    $ws.Cells.Item(7,6)= $ExecutionContext.InvokeCommand.ExpandString($problem)
    
    $result = $form.ShowDialog()
}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $Username = [microsoft.visualbasic.interaction]::inputbox('Enter USID','Tech Bar Sign In')
    $name = [microsoft.visualbasic.interaction]::inputbox('Enter Name','Tech Bar Sign In')
    $problem = [microsoft.visualbasic.interaction]::inputbox('Describe Issue','Tech Bar Sign In')

    $ws.Cells.Item(8,3)= $ExecutionContext.InvokeCommand.ExpandString($username)
    $ws.Cells.Item(8,4)= $ExecutionContext.InvokeCommand.ExpandString($name)
    $ws.Cells.Item(8,5)= $ExecutionContext.InvokeCommand.ExpandString($date)
    $ws.Cells.Item(8,6)= $ExecutionContext.InvokeCommand.ExpandString($problem)
    
    $result = $form.ShowDialog()
}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $Username = [microsoft.visualbasic.interaction]::inputbox('Enter USID','Tech Bar Sign In')
    $name = [microsoft.visualbasic.interaction]::inputbox('Enter Name','Tech Bar Sign In')
    $problem = [microsoft.visualbasic.interaction]::inputbox('Describe Issue','Tech Bar Sign In')

    $ws.Cells.Item(9,3)= $ExecutionContext.InvokeCommand.ExpandString($username)
    $ws.Cells.Item(9,4)= $ExecutionContext.InvokeCommand.ExpandString($name)
    $ws.Cells.Item(9,5)= $ExecutionContext.InvokeCommand.ExpandString($date)
    $ws.Cells.Item(9,6)= $ExecutionContext.InvokeCommand.ExpandString($problem)
    
    $result = $form.ShowDialog()
}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $Username = [microsoft.visualbasic.interaction]::inputbox('Enter USID','Tech Bar Sign In')
    $name = [microsoft.visualbasic.interaction]::inputbox('Enter Name','Tech Bar Sign In')
    $problem = [microsoft.visualbasic.interaction]::inputbox('Describe Issue','Tech Bar Sign In')

    $ws.Cells.Item(10,3)= $ExecutionContext.InvokeCommand.ExpandString($username)
    $ws.Cells.Item(10,4)= $ExecutionContext.InvokeCommand.ExpandString($name)
    $ws.Cells.Item(10,5)= $ExecutionContext.InvokeCommand.ExpandString($date)
    $ws.Cells.Item(10,6)= $ExecutionContext.InvokeCommand.ExpandString($problem)
    
    $result = $form.ShowDialog()
}
$ws.saveas("C:\Users\us57442\Desktop\shouldertap.xltm")
$xl.Visible=$true
}




##Add AD user to group
function xtools-ADDgroupmember{
$usid = read-host "enter usid"
write-host "Loading group lists..."
$group = get-adgroup -server xxxx -filter *|Out-GridView -passthru 
$quick = Get-ADUser -Server "xxxx" -Filter 'samAccountname -like $usid' -Properties samaccountname

Add-ADGroupMember -Credential "" -Identity $group -members $quick 
}




##Script that provides a GUI interface for closing ticket codes. 
function xtools-ticketcoder {add-type -AssemblyName microsoft.visualbasic
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Category Type'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Category Type:'
$form.Controls.Add($label)

$listBox2 = New-Object System.Windows.Forms.ListBox
$listBox2.Location = New-Object System.Drawing.Point(10,40)
$listBox2.Size = New-Object System.Drawing.Size(260,20)
$listBox2.Height = 80

[void] $listBox2.Items.Add('*DS')
[void] $listBox2.Items.Add('*ID')
[void] $listBox2.Items.Add('*BF')
[void] $listBox2.Items.Add('*RF')
[void] $listBox2.Items.Add('*QH')


$form.Controls.Add($listBox2)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $y = $listBox2.SelectedItem
    
}

$msgbox = [microsoft.visualbasic.interaction]::inputbox('Time on task','Ticket Coding Tool')
$msgbox.top





Set-Clipboard "$y $msgbox"
}
