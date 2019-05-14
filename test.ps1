# $changes = git status -s ./README.md

# if ( $changes) {
#     # git add .\README.md
#     # git commit -m 'Update README versions.'
#     # git push origin master 

#     Write-Output ""
#     Write-Output "GIT: Committed README update and pushed to remote master."
#     Write-Output ""
# }
# else {
#     Write-Output ""
#     Write-Output "GIT: No change. Exiting..."
#     Write-Output ""
# }

# $bucketName = (get-content .\outputs.txt) -match ("bucketName = *.")
# $tokens = $bucketName -split ' = '
# Write-Output $tokens[1]

# $tfVersion = terraform version
# Write-Output $tfVersion[1]

$cwd = Get-Location 
$tokens = $cwd -split '\\'

# Write-Output $tokens
# Write-Output $tokens.Length
# Write-Output ($tokens[$tokens.Length -1] -replace(' ', '_'))

$fileName = $tokens[$tokens.Length -1] -replace(' ', '_')
Write-Output "$fileName.log"