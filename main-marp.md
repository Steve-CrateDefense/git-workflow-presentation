---
marp: true
theme: gaia
class:
    - invert
paginate: true
---
<!--- _class: lead invert --->

# A Tale Of Two Terraform Deployments
A migration tale from unruly deployments to automation zen.

---

# Background
- Platform had been active for 5 years
- Pre-existing infrastructure with IaC
- Multi-domain Commercial, Govcloud, Secret, Top Secret AWS deployments
- Small team: Manager, Senior Platform Engineer, Myself
- High previous turnover

---

# Problem
- Configuration drift between Classification domains
- Intermittent production outages
- Low confidence in deploying any infrastructure or platform tooling changes
- Low confidence in version controlled code sync
- Very low staff morale

---
<style scoped>
section { padding-top: 30px; }
section { font-size: 30px; }
li { margin-bottom: 0.3em; }
section ul ul li { font-size: 18px; }
</style>

# Analysis
- No meaningful version control workflow
    - Reviewed current state of repositories in GitLab, including Terraform modules and large "driver" mono-repo
    - Difficult to perform any rollbacks or iterate on modules.
    - Updates to main monorepo were difficult and poorly tracked.
    - GitLab existed on SIPR and JWICS but was not utilized for source code control by the Platform team.
- No code validation or test procedures
    - No test environment, updates done in production
    - Updates or changes were regularly rolled back sloppily. 
    - Changes were iterated on in a production setting usually breaking functionality.
- Manual local deployments
    - Platform team deployments were always done on a local machine, making it almost impossible to trace who made changes and the breadth of those changes
    - Many times small changes or bugfixes were never checked into central version control system, or were left dangling as feature branches untracked
    - Development teams regularly made changes in the AWS console (on all classifications)
- One off divergent deployments across classification domains
    - Code bundled into containers pushed to classified regions; changes were never sync'd into the SIPR or JWICS GitLab

---
<style scoped>
section { padding-top: 30px; }
section { font-size: 30px; }
li { margin-bottom: 0.3em; }
section ul ul li { font-size: 18px; }
</style>

# Analysis Git Workflow
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
    - A three-tiered structure replaced it: driver, modules, various terraform modules
    - Allowed independent small changes to be made without affecting the wider system

![bg right:68% w:90%](./assets/new_repo_structure.drawio.svg)

--- 

<style scoped>
section { padding-top: 30px; }
section { font-size: 30px; }
li { margin-bottom: 0.3em; }
section ul ul li { font-size: 18px; }
</style>

# Solution (contd)
- Enforce all infrastructure changes be made through automation
- Create test environment to validate changes
- Create and enforce multi-domain code sync and deployments

--- 

# Stakeholder management
- Platform teams:
    - Overall little discussion required, changes were welcomed
    - Enforce git based workflows
    - Enforce deployment testing
- Development teams:
    - More discussion required, many permissions and features were removed from developers
    - Remove admin access to infrastructure
    - Remove kubectl access

---

# Results
- Team morale improvement
- Multiple pushes to IaC repositories daily
- Bugs fixed and committed immediately