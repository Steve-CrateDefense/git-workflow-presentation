# Analysis of Skyward environment

## No meaningful version control workflow
When I joined the team, I started by reviewing the various GitLab repos that the platform team was utilizing. The first thing that stood out
was that the Terraform modules weren't using git version tags and all the deployments were attempting to be deployed off the main branch of the 
large monorepo containing the underlying platform code and all the development teams' AWS-specific infrastructure.

- Reviewed current state of repositories in GitLab, including Terraform modules and large "driver" mono-repo
- Made it difficult to perform any rollbacks or iterate on modules.
- Updates to main monorepo were difficult and poorly tracked.
- GitLab existed on SIPR and JWICS but was not utilized for source code control by the Platform team.

## No code validation or test procedures
Changes were usually done directly to production systems as "hot fixes". And very little, if any, improvement work had been done in the two years before I joined the team. This regularly caused multiple hours/days of iterating over small issues like ingress settings or firewall updates.

- No test environment, updates done in production
- Updates or changes were regularly rolled back sloppily. 
- Changes were iterated on in a production setting usually breaking functionality.

## Manual local deployments
Changes were always deployed from a Platform engineer's local machine or done directly through the AWS console for development teams, making it almost impossible to track infrastructure changes over time or enforce a security boundary for the system's ATO. Many times, even on such a small team, engineers would deploy divergent changes overriding each other's updates due to improper local code syncing. 

Many times small changes or fixes that were updated into the codebase were written into a feature branch which was never merged, or just overwritten and never committed, causing bugs to persist intermittently as engineers pulled and pushed code. 

- Platform team deployments were always done on a local machine, making it almost impossible to trace who made changes and the breadth of those changes
- Many times small changes or bugfixes were never checked into central version control system, or were left dangling as feature branches untracked
- Development teams regularly made changes in the AWS console (on all classifications)


## One off divergent deployments across classification domains
The workflow was that local code changes would be pulled and built into a docker container. The docker container was then shipped to the classified domains for various updates. The code was never shipped to the centralized GitLab server and would just exist on a series of docker containers on a shared EC2 instance. Previous containers were regularly deleted to free up space by development team members and were lost, removing any history or traceability. Because of this, classified domains were almost never updated due to fear of breaking functionality and having no rollback mechanism. 