###############################################################################
# 
# BUILD
#
###############################################################################
# POWERSHELL ##################################################################

###############################################################################
# INIT ########################################################################
param([string] $interactive = "true", # Require human interaction.
      [string] $logName = "", # TF_LOG path.
      [string] $planName = "", # Saved plan name.
      [string] $logLevel = "TRACE") # Log verbosity. TRACE is the most verbose.

# Get current working dir as base for log and plan names when unspecified. 
$cwd = Get-Location
$tokens = $cwd -split '\\'
$fileName = $tokens[$tokens.Length - 1] -replace(' ', '_')



###############################################################################
# LOGGING #####################################################################
if ($logName -eq "") {
    $logName = "$fileName.log"
}

$env:TF_LOG_PATH = $logName

# Setting TF_LOG to empty string will disable logging.
if ($logLevel -eq "NONE") {
    $logLevel = ""
}
# Log levels: NONE, TRACE, DEBUG, INFO, WARN or ERROR change log verbosity.
$env:TF_LOG = $logLevel



###############################################################################
# PLAN ########################################################################
if ($planName -eq "") {
    $planName = "$fileName.plan"
}

# -out will overwrite plan on each run.
terraform plan -detailed-exitcode -out="$planName"
$tfPlanExitCode = $LASTEXITCODE

if ($tfPlanExitCode -eq 0) {
    Write-Output ""
    Write-Output "PLAN: succeeded with empty diff (no changes). Exiting..."
    Write-Output ""
    return
}
elseif ($tfPlanExitCode -eq 1) {
    Write-Output ""
    Write-Output "PLAN: Error! Check $logName for details. Exiting..."
    Write-Output ""
    return
}
elseif ($tfPlanExitCode -eq 2) { # Continue to PLAN APPROVAL
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
    terraform apply -input=false -auto-approve "$planName"
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
#terraform output -json > outputs.json
Write-Output ""
Write-Output "SAVE OUTPUTS: file(s) generated."
Write-Output ""



###############################################################################
# TESTS #######################################################################
#_ BUCKET LIST ________________________________________________________________ 
Write-Output ""
Write-Output "TEST: Bucket file list, manual validation."
Write-Output ""

# Use outputs file to get bucketname for list creation.
$bucketName = (get-content .\outputs.txt) -match ("bucketName = *.")
$tokens = $bucketName -split ' = ' 

aws s3api list-objects --bucket $tokens[1]



###############################################################################
# README UPDATE ###############################################################
# Update versioning info section. Always overwrites, even same version.
$tfVersion = terraform version # also lists provider versions.
(get-content .\README.md) -replace ('Terraform v.*', $tfVersion) | out-file .\README.md

$psVersion = 'Powershell v' + $PSVersionTable.PSVersion.ToString()
(get-content .\README.md) -replace ('Powershell v.*', $psVersion) | out-file .\README.md

Write-Output ""
Write-Output "README UPDATE: Done: $tfVersion , $PSVersion."
Write-Output ""



###############################################################################
# GIT #########################################################################
# Does not commit if no version change.
# -s switch for short format, returns empty string on no change.
$changes = git status -s ./README.md

if ($changes) { # non-emepty, change present.
    git add .\README.md
    git commit -m "Update README versions: $tfVersion , $PSVersion."
    git push origin master 

    Write-Output ""
    Write-Output "GIT: Committed README update and pushed to remote master."
    Write-Output ""
}
else { # empty string.
    Write-Output ""
    Write-Output "GIT: No change. Exiting..."
    Write-Output ""
}