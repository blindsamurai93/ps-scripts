#Written by Xavier Fields 9/12/2023
#For any issues, contact the writer @ xavier.fields@dgs.virginia.gov


#Grabs a list of all of the user templates from their respective groups. You can only select ONE. 
$TemplateAcct = Get-ADuser -server "dclsdc.dclslab.local" -filter * -properties * |where name -Clike "*Template" |select -expandproperty name |Out-GridView -PassThru

#Grabs the full path to the target OU (ex. OU=COMP Group Users,OU=COMP Group,OU=Lab Computers and Users,DC=DCLSLAB,DC=local)
$OU1 = Get-ADuser -server "dclsdc.dclslab.local" -filter * -properties * |where name -eq $TemplateAcct| select -ExpandProperty DistinguishedName

#The following variables:
# 1. Split the full OU path into single objects($OU2)
# 2. Collect the objects and store them as an array ($OU3)
# 3. Restructure the array w/o the CN as part of the OU path ($OU_Final)
$ou2 = $OU1.split(",")
$OU3 = $ou2[1],$ou2[2],$ou2[3],$ou2[4],$ou2[5]
$OU_Final = $ou3 -join ","


#Copies member groups, primary group, and the description (Typically blank but just incase)
$NewUserAttribs = Get-ADuser -server "dclsdc.dclslab.local" -filter * -properties * |where name -eq $TemplateAcct |select MemberOf, PrimaryGroup, Description

#The following 3 variables:
# 1. Prompt for a temp PW
# 2. Convert the password string into a secure string
# 3. Encrypt the secure string (as a just incase)
$yo = read-host "Enter Password"-AsSecureString 
$encrypt = ConvertFrom-SecureString -SecureString $yo
$pass2 = ConvertTo-SecureString -String $encrypt

#The following 4 variables:
# 1. Prompt for a full name (Ex. John Doe)
# 2. Prompt for first name
# 3. Prompt for last name
# 4. Prompt for first initial + last name (ex.jdoe)
$FullName = read-host "Enter Fullname"
$First = read-host "Enter First Name"
$Last = read-host "Enter Last Name" 
$LoginName = Read-Host "Enter first initial + Last name (ex.jdoe)"

#Creates a new user, using the name variables (full, first, last, and login names) 
New-ADUser -Name $FullName -GivenName $First -Surname $Last -SamAccountName $LoginName -Instance $NewUserAttribs -DisplayName $FullName -UserPrincipalName "$LoginName@dclslab.local" -AccountPassword $pass2 -ChangePasswordAtLogon $true -Enabled $true 

#Brief sleep to ensure the new account is replicated across all DCs
sleep 15

#Retrieves new user account and moves it to the proper OU, specified in the $OU_Final variable.
Get-ADUser -server "dclsdc.dclslab.local" -Identity $LoginName | move-adobject -targetpath $ExecutionContext.InvokeCommand.ExpandString($OU_Final) -Verbose