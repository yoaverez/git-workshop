# Welcome To Exersice 1

## The Scenario
You are a new developer and the team leader has given you a task to create a new feature.

You were very excited and started to work on your feature.
You've work hard on the feature for couple of weeks.

You've finished the implementation of the feature just before the end of the sprint and then you run all the tests of the main project in order to make sure that you didn't ruin anything.

Unfortunately a single test called: `mysterious-test` failed.
You've looked at the test trying to figure out what have you done but with no success.

What do you do?

## Set-up
In order to create the environment, you need to open `git bash` shell from this directory and
run the following command:

`./env-setup.sh "<The path to a directory in which you want to have the exercise repository>"`

An exapmle of a real run:

`./env-setup.sh "C:\Users\Public\yoav\GitRepositories\GitLecture\Exercises\Exercise1"`

## Notes
1. **DO NOT GIVE THE DIRECTORY OF THIS REPOSITORY AS A PARAMETER. THIS WILL CAUSE TWO GIT REPOS IN THE SAME DIRECTORY.**

2. The path that you give to the set-up file does not have to exist. The script will create the path if it does not exist.

3. You can run the test in the new repository by running the following command in a `git bash` shell:

    `./mysterious-test.sh`