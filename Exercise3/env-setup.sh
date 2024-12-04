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
	local remote_dir="${repo_directory}/remote_repo"
	local local_dir="${repo_directory}/local_repo"
		
	# Create empty empty repository for the remote.
	git init --bare $remote_dir
	
	# Clone the remote repository to the local directory.
	git clone "$remote_dir" "$local_dir"
	cd $local_dir
	
	# Initialize git config to make sure that you can commit changes
	git config --local user.name "developer"
	git config --local user.email "developer@gmail.com"
	
	# Add a first commit.
	local file_path="file1.txt"
	touch $file_path
	for k in {1..10}; do
		write-to-file "$file_path" "" "false"
	done	
	
	add-and-commit "First commit of the repo"
	git push
	
	# Create feature branch
	git checkout -b feature
	
	# Fill the feature branch
	sed -i '1c VERY IMPORTANT LINE' "$file_path"
	add-and-commit "Important commit"
	sed -i '4c Not very important 1' "$file_path"
	add-and-commit "Not very important commit 1"
	sed -i '7c Not very important 2' "$file_path"
	add-and-commit "Not very important commit 2"
	git push -u origin feature
	
	git checkout master
	sed -i '9c Hello world' "$file_path"
	add-and-commit "Added hello word message"
	git push
	
	git rebase --onto master feature~2 feature
	git push -f
}

#################
### Run setup ###
#################

setup-env

