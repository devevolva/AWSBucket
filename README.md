# AWS S3 Bucket 

## Using

Terraform v0.11.13 + provider.aws v1.56.0 

Powershell v5.1.17763.316

<br />

## Description

Create an Amazon Web Services(AWS) Simple Storage Service(S3) bucket to store backup files.


:warning: Be sure to replace the bucketName default with your own unique bucket name.
``` ruby
variable "bucketName" {
  description = "Bucket used to hold backup files."
  default = "web-copy-test" # Replace with your unique bucket name.
}
```

<br />

## Build Script
To be used after cloning the repo initially or using destroy on existing resources.
Can be used interactively or unattended.

#### Syntax
```
build.ps1 [-interactive "true"|"false"] [-logName "LOGNAME"] [-planName "PLANNAME"] [-logLevel "LOGLEVEL"]
```

  * **interactive [string]** - Require human interaction. Can be "true" or "false", default is "true" when unspecified. When "false" script will run unattended.

  * **logName [string]** - Name for Terraform log file, when unspecified defaults to the current working directory name with spaces replaced by underscores, so "My Folder Name" becomes "My_Folder_Name.log". 

  * **planName [string]** - Name for Terraform saved plan file, when unspecified defaults to the current working directory name with spaces replaced by underscores, so "My Folder Name" becomes "My_Folder_Name.plan". 

  * **logLevel [string]** - Log level changes log verbosity. Available levels: NONE, TRACE, DEBUG, INFO, WARN or ERROR. Default is TRACE when unspecified, which is the most verbose setting. NONE will disable logging.

<br />

#### Execution
You will need to enable unsigned script execution if it isn't already:

    1. Start Powershell with the "Run as Administrator" option.
    2. PS > set-executionpolicy remotesigned

<br />

#### Examples
To build using default parameter values:
``` 
PS > .\build.ps1
```

All parameters are optional and may be included, or excluded, as needed:
```
PS > .\build.ps1 -interactive "false" -logName "Log_Name" -planName "Plan_Name" -logLevel "DEBUG"
```

