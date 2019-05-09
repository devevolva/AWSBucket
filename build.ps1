###############################################################################
# 
# BUILD
#
###############################################################################
# POWERSHELL ##################################################################

###############################################################################
# INIT ########################################################################
#_ PARAMETERS _________________________________________________________________
param([string] $interactive = "true")# Require human interaction.

#_ LOGGING ____________________________________________________________________
# Log levels TRACE, DEBUG, INFO, WARN or ERROR change log verbosity.
$env:TF_LOG = "TRACE" #TRACE is the most verbose.
$env:TF_LOG_PATH = "AWS_S3_BUCKET.log" #TODO: name after cwd as default.



###############################################################################
# PLAN ########################################################################
# -out will overwrite plan on each run.
terraform plan -detailed-exitcode -out="AWS_S3_BUCKET.plan"
$tfPlanExitCode = $LASTEXITCODE

if ($tfPlanExitCode -eq 0) {
    Write-Output ""
    Write-Output "PLAN: succeeded with empty diff (no changes). Exiting..."
    Write-Output ""
    return
}
elseif ($tfPlanExitCode -eq 1) {
    Write-Output ""
    Write-Output "PLAN: Error! Exiting..."
    Write-Output ""
    return
}
elseif ($tfPlanExitCode -eq 2) { # continue to PLAN APPROVAL
    Write-Output ""
    Write-Output "PLAN: Succeeded with non-empty diff (changes present)." 
    Write-Output ""
}
else {
    Write-Output ""
    Write-Output "PLAN: Exited with an unknown state: $tfPlanExitCode. Exiting..."
    Write-Output ""
    return
}



###############################################################################
# PLAN APPROVAL ###############################################################
$apply = ""
if ($interactive -eq "true") {
    $apply = Read-Host 'Apply plan?'
}

if(($apply -eq "y" -or $apply -eq "yes") -or $interactive -eq "false") { # continue to SAVE OUTPUTS
    Write-Output ""
    terraform apply -input=false -auto-approve "AWS_S3_BUCKET.plan" 
    Write-Output ""
}
else {
    Write-Output ""
    Write-Output "PLAN APPROVAL: Build aborted, no resources created or modified. Exiting..."
    Write-Output ""
    return
}



###############################################################################
# SAVE OUTPUTS ################################################################
terraform output > outputs.txt
terraform output -json > outputs.json
Write-Output ""
Write-Output "SAVE OUTPUTS: file(s) generated."
Write-Output ""



###############################################################################
# TESTS #######################################################################
#_ BUCKET LIST ________________________________________________________________ 
Write-Output ""
Write-Output "TEST: Bucket file list, manual validation."
Write-Output ""
aws s3api list-objects --bucket web-copy-test #TODO: pull bucket name from outputs



###############################################################################
# README UPDATE ###############################################################
$tfVersion = terraform version # also lists provider versions.
(get-content .\README.md) -replace ('Terraform v.*', $tfVersion) | out-file .\README.md

$psVersion = 'Powershell v' + $PSVersionTable.PSVersion.ToString()
(get-content .\README.md) -replace ('Powershell v.*', $psVersion) | out-file .\README.md

Write-Output ""
Write-Output "README UPDATE: Done: $tfVersion , $PSVersion."
Write-Output ""



###############################################################################
# GIT #########################################################################
$changes = git status ./README.md

if ( $changes -match("Changes not staged for commit")) {
    git add .\README.md
    git commit -m "Update README versions: $tfVersion , $PSVersion."
    git push origin master 

    Write-Output ""
    Write-Output "GIT: Committed README update and pushed to remote master."
    Write-Output ""
}
else {
    Write-Output ""
    Write-Output "GIT: No change."
    Write-Output ""
}