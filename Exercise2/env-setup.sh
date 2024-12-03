#!/bin/bash

################################
### Arguments for the script ###
################################

repo_directory="$1"

#################
### Constants ###
#################


#########################
### Auxiliary methods ###
#########################

# Stage all the current changes and then commit them.
function add-and-commit(){
	local commit_message="$1"
	git add --all
	git commit -m "$commit_message"
}

# Write given string to file
function write-to-file(){
	local file_path=$1
	local string=$2
	local should_truncate=${3:-"true"}
	
	if [[ "$should_truncate" == "true" ]] ; then
		echo "$string" > $file_path
	else
		echo "$string" >> $file_path
	fi
}

###########################################
### Setup the exercise local repository ###
###########################################

# Create the git repository for this exercise.
function setup-env(){
	# Create empty empty repository.
	# This will create all the path is the path does not exist.
	git init $repo_directory

	# Change the current directory to the given repository path.
	echo "Changing current directory to $repo_directory"
	cd $repo_directory

	##############################################
	# Create the initial state of the exercise ###
	##############################################

	local file_path="file1.txt"
	touch $file_path
	
	local string=""
	
	# First master commit.
	string="1"
	write-to-file "$file_path" "$string"
	add-and-commit "$string"
	
	# Second master commit.
	string="2"
	write-to-file "$file_path" "$string" "false"
	add-and-commit "$string"
	
	# Create feature1 branch.
	git checkout -b "feature1"
	
	# First commit of the feature1 branch.
	string="3"
	write-to-file "$file_path" "$string"
	add-and-commit "$string"
	
	# Second feature1 commit.
	string="4"
	write-to-file "$file_path" "$string" "false"
	add-and-commit "$string"
	
	# Return to the master branch
	git checkout master
	
	# Third master commit.
	string="5"
	write-to-file "$file_path" "$string" "false"
	add-and-commit "$string"
	
	# Create feature2 branch.
	git checkout -b "feature2"
	
	# First commit of the feature2 branch.
	string="6"
	write-to-file "$file_path" "$string"
	add-and-commit "$string"
	
	# Return to the feature1 branch
	git checkout feature1
	
	# Third feature1 commit.
	string="7"
	write-to-file "$file_path" "$string" "false"
	add-and-commit "$string"
	
	local file_content_at_feature1=$(<$file_path)
	
	# Return to the master branch
	git checkout master
	
	local file_content_at_master=$(<$file_path)
	
	# Merge feature1 into master
	git merge feature1 --no-commit --no-ff
	
	# Handle conflicting files
	echo "$file_content_at_master" > "$file_path"
	echo "$file_content_at_feature1" >> "$file_path"
	
	# Commit the merge
	add-and-commit "Merge feature1 into master"
	
	# Return to feature2
	git checkout feature2
	
	# Third commit of the feature2 branch.
	string="8"
	write-to-file "$file_path" "$string" "false"
	add-and-commit "$string"
	
	# Third commit of the feature2 branch.
	string="9"
	write-to-file "$file_path" "$string" "false"
	add-and-commit "$string"
	
	local file_content_at_feature2=$(<$file_path)
	
	# Return to the master branch
	git checkout master
	
	file_content_at_master=$(<$file_path)
		
	# Merge feature2 into master
	git merge feature2 --no-commit --no-ff
	
	# Handle conflicting files
	echo "$file_content_at_master" > "$file_path"
	echo "$file_content_at_feature2" >> "$file_path"
	
	# Commit the merge
	add-and-commit "Merge feature2 into master"
}

#################
### Run setup ###
#################

setup-env

