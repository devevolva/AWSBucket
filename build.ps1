###############################################################################
# 
# BUILD
#
###############################################################################
# POWERSHELL ##################################################################

###############################################################################
# INIT ########################################################################
#_ USER INTERACTION ___________________________________________________________
#$interactive = 0 #0=false, 1=true

#_ LOGGING ____________________________________________________________________
#log levels TRACE, DEBUG, INFO, WARN or ERROR change the verbosity of the logs.
$env:TF_LOG = "TRACE" #TRACE is the most verbose.
$env:TF_LOG_PATH = "AWS_S3_BUCKET.log" #TODO: name after cwd



###############################################################################
# PLAN ########################################################################
terraform plan
# -out will overwrite plan on each run.
# terraform plan -out="s3_bucket_plan" 



###############################################################################
# PLAN APPROVAL ###############################################################
$apply = Read-Host 'Apply plan?'

if($apply -eq "y") {
    Write-Output ""
    terraform apply -input=false -auto-approve 
    # terraform apply -input=false -auto-approve "s3_bucket_plan" 
    Write-Output ""
}
else {
    Write-Output ""
    Write-Output "Build aborted, no resources created or modified."
    Write-Output ""
    return
}



###############################################################################
# SAVE OUTPUTS ################################################################
terraform output > outputs.txt
terraform output -json > outputs.json
Write-Output ""
Write-Output "Ouput file(s) generated."
Write-Output ""



###############################################################################
# TESTS #######################################################################
#_ BUCKET LIST ________________________________________________________________ 
Write-Output ""
Write-Output "TEST: Bucket file list."
Write-Output ""
aws s3api list-objects --bucket web-copy-test #TODO: pull bucket name from outputs



###############################################################################
# README UPDATE ###############################################################
$tfVersion = terraform version # also lists provider versions.
(get-content .\README.md) -replace ('Terraform v.*', $tfVersion) | out-file .\README.md

$psVersion = 'Powershell v' + $PSVersionTable.PSVersion.ToString()
(get-content .\README.md) -replace ('Powershell v.*', $psVersion) | out-file .\README.md

Write-Output ""
Write-Output "README updated."
Write-Output ""



###############################################################################
# GIT #########################################################################
# git add .\README.md
# git commit -m 'Update README versions.'
# git push origin master 

# Write-Output ""
# Write-Output "Committed README update and pushed to remote master."
# Write-Output ""