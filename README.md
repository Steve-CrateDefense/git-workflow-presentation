# Quick Git workflow update presentation

## Viewing presentation

This project uses [MARP](https://marp.app/) to view slideshow deck. I personally use the [VS Code extension ](https://github.com/marp-team/marp-vscode) to view the slideshow but other options exist as well. 

## Testing out example repo
The repository for brevity is kept in a single repository, usually each of the 4 folders under `example-deployment` would be separate repositories.

Requirements: 
| Tool | Version
|--- | ---
| Terragrunt |  >= v1.1.0 
| OpenTofu | >= v1.12.3 

```bash
# Start at the repository root

# Set the first environment envs
cd example-deployment/remote-config
set -a
source environment1.env
set +a
echo $CUSTOMER_1_INPUT

# Deploy and check the output remote_value matches environment1.env value
cd ../driver/live/customer-1/stacks
terragrunt stack generate
terragrunt stack run apply

# Set the other envs
cd ../../../../remote-config
set -a
source environment2.env
set +a
echo $CUSTOMER_1_INPUT

# Deploy and check the output remote_value matches environment2.env value
cd ../driver/live/customer-1/stacks
terragrunt stack generate
terragrunt stack run apply

# Set a custom value to inject
cd ../../../../remote-config
# Edit the values to whatever you want
set -a
source environment2.env
set +a

# Deploy your custom values
cd ../driver/live/customer-1/stacks
terragrunt stack generate
terragrunt stack run apply
```