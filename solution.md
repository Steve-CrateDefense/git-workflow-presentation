# Solution

## Institute mandatory git based workflow
Legacy repository structures were mostly scrapped in order to start a new structure and project. Nick-named Spear, it consisted of a centralized "driver" repository responsible for holding various configuration files and linkages to modules. A second repository holding various terragrunt stack and unit files was created and independently version controlled. Then each individual terraform module had a repository and was independently version controlled. 

All changes went through testing and validation before being rebased onto main and subsequently tagged for release to production environments. 

## Enforce all infrastructure changes be made through automation
Moved all deployments into GitLab pipelines; this allowed traceability and understanding of what each engineer was working on and deploying. 

## Create test environment to validate changes
Stood up a separate branch for testing which mirrored the production branch, this branch could independently deploy feature branches or version tags of spear-modules before promotion happened.

## Create and enforce multi-domain code sync and deployments
A job tracked the main branches of spear, spear-modules, and all terraform modules and automatically pushed the latest tags and commits to main to classified GitLab via the in-house CDS. Once the code was high side, all deployments acted exactly the same as low side, with deployments happening through GitLab pipelines. For artifacts, a centralized script was generated which pulled the listed version of each tool and also pushed them alongside the code to high side environments, allowing them to sync.