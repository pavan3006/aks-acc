# Pull Request Process

1. Every contributor creates a release branch for a specific feature/task from the main branch.
2. Name the feature branch based on the following convention "**feature id - github handle/team**" 
    - git checkout -b **branch name**
3. Build new feature following [file structure](https://github.com/sede-x/shell-innersource-iac-terraform/blob/main/TF_ModuleStructure.md)
4. After development is complete sandbox testing needs to be performed.
5. Pull the code main branch to local before commiting changes to avoid merge conflicts
6. Commit code to feature branch follow best practices.
     -  Make small and single purpose commit
     -  Write short and detailed Commit message.
     -  Follow the [link](https://chris.beams.io/posts/git-commit) to write good commit messages
7. Push to git feature branch.
8. Create pull request.

# After Pull Request submitted
1. Automated end to end testing for the TF module will be commence.
2. Upon successful automated testing, PR will be release for review by Maintainers (<link to maintainers team>)
3. Upon successful Review, Maintainer will approve and perform Release tag.


# Overall process flow
![InnerSource IaC process flow](./Documentation/IIaC_Flow.svg)
