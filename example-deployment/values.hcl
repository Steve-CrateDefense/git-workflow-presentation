locals {
    git_url = "git::https://github.com/Steve-CrateDefense/git-workflow-presentation.git"
    value1 = get_env("VALUE1", "test_value1")
    value2 = get_env("VALUE2", "test_value2")
}