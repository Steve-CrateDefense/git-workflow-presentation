---
marp: true
theme: gaia
class:
    - invert
paginate: true
---
<!--- _class: lead invert --->

# Git Updates that Unlocked Platform Development Velocity
A migration from trunk chaos to versioned deployments.

---

# Background
- Hired to implement an updated Platform solution
- Platform active for 5 years
- Pre-existing infrastructure with IaC
- Multi-domain Commercial, Govcloud, Secret, Top Secret AWS deployments
- 7 Tenants onboarded to Platform with a mix of Dev/Stg/Prd spread throughout classifications
- Team: Manager, Senior Platform Engineer, Junior Platform Engineer, Myself
- High previous turnover

---

# Problem
- Low confidence in deploying existing IaC
- Configuration drift between Classification domains
- Intermittent production outages
- Low staff morale

---
<style scoped>
section { padding-top: 30px; }
section { font-size: 30px; }
li { margin-bottom: 0.3em; }
section ul ul li { font-size: 18px; }
</style>

# Analysis
- No meaningful version control workflow
    - No tags or releases used
    - Sloppy use and maintanance of feature branches
    - Code missing from central repository
- Manual local deployments
    - Deployments done from local laptops
    - No traceability
    - Small bug fixes not merged into central repository
    - Development teams regularly made changes in the AWS console (on all classifications)
- One off divergent deployments across classification domains
    - Code updates saved in a string of Docker containers
    - No traceability on who/what changed
    - Classified region code updates never merged into central repository
- No code validation or test procedures
    - No Platform test environment
    - All changes made in developer UAT/STG or Production environments

---
<style scoped>
section { padding-top: 30px; }
section { font-size: 30px; }
li { margin-bottom: 0.3em; }
section ul ul li { font-size: 18px; }
</style>

# Analysis:  Legacy Git Workflow
![bg right:68% h:90%](./assets/old_workflow.drawio.svg)

---
<style scoped>
section { padding-top: 30px; }
section { font-size: 30px; }
li { margin-bottom: 0.3em; }
section ul ul li { font-size: 18px; }
</style>

# Solution
- Institute mandatory git based workflow
    - Legacy repository structure was mostly scrapped
    - A three-tiered structure replaced it: driver,  terragrunt modules, terraform modules
        - Driver: Holds automation and injected remote config and variables
        - Terragrunt Modules: Version controlled artifact holding terragrunt stacks and units
        - Terraform Modules: Version controlled artifact holding terraform module code
    - Allowed independent small changes to be made without affecting the wider system
- Enforce all infrastructure changes be made through automation
    - Build out Gitlab pipeline code
    - Enforce via team policy all deployment happen via pipelines
- Create test environment to validate changes
- Create and enforce multi-domain code sync and deployments
    - Enforce via team policy that all features are tested then deployed in all three environments,
    Ensuring all features are correctly deployed in all environments completing the sync
    - Fix CDS syncs to allow branching and tags to properly sync to high side environments

--- 

<style scoped>
section { padding-top: 30px; }
section { font-size: 30px; }
li { margin-bottom: 0.3em; }
section ul ul li { font-size: 18px; }
</style>

## Solution: New Git Repository
![bg right:68% w:90%](./assets/new_repo_structure.drawio.svg)

--- 

# Stakeholder management
- Platform teams:
    - Overall little discussion required, changes were welcomed
    - Enforce git based workflows
    - Enforce deployment testing
- Program management: 
    - Pushback on new platform development length and time
    - Set expectations
    - Show value new system provided

---

# Results
- Team morale improvement
- Multiple pushes to IaC repositories daily
- Bugs fixed and committed immediately

---

<style scoped>
section { padding-top: 22px; font-size: 22px; }
h1 { font-size: 32px; }
pre { font-size: 16px; line-height: 1.25; }
</style>

# Appendix: Walking a Version Change Through the Stack

Versions file holds the current version that should be utilized
```hcl
# driver/versions.hcl

locals {
    hub_version = "main"
    customer_1_version = "main"
}
```
Version is used in the driver/live/tenant/terragrunt.stack.hcl to call a specific terragrunt module version
```
# driver/terragrunt.stack.hcl

stack "first" {
  source = "${local.global_vars.locals.git_url}//example-deployment/modules/stacks/stack-1?ref=${local.version_vars.locals.customer_1_version}"
  path = "first"

  values = {
    unit_tag = local.version_vars.locals.customer_1_version
    git_url = local.global_vars.locals.git_url
    ...
  }
}
```
Stack in module folders calls unit using passed in unit tag
```
# modules/terragrunt.stack.hcl

unit "module_1" {
  source = "${values.git_url}//example-deployment/modules/units/unit-2?ref=${values.unit_tag}"
  path = "module_1"
  ...
}
```


---

<style scoped>
section { padding-top: 22px; font-size: 22px; }
h1 { font-size: 32px; }
pre { font-size: 16px; line-height: 1.25; }
</style>

# Appendix: Different Remote Value Usage

Multiple remote values files are held inside a separate repository

```hcl
# Remote files
remote-config
├── environment1.env
└── environment2.env
```

Inside the automation pipeline a check is done to see which values file should be used
```bash

# A default value is set per branch, is overriden by Gitlab pipeline variables on classified regions
export CURRENT_ENVIRONMENT_CLASSIFICATION="environment1" 

if [[ "${CURRENT_ENVIRONMENT_CLASSIFICATION}" = "environment1" ]]; then
    cp remote-config/environment1.env .env
elif [[ "${CURRENT_ENVIRONMENT_CLASSIFICATION}" = "environment2" ]]; then
    cp remote-config/environment2.env .env
fi
set -a
source .env
set +a
```

Various terragrunt files use get_env() to set the remote values per environment
```
# driver/values.hcl

locals {
    git_url = "get_env("GIT_URL", git::https://github.com/Steve-CrateDefense/git-workflow-presentation.git")
    value1 = get_env("VALUE1", "default_value1")
    value2 = get_env("VALUE2", "default_value2")
}
```