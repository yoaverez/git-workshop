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

# Fill the given file with empty lines
function fill-file-with-empty-lines(){
	local file_path=$1
	local num_of_lines=$2
	
	touch $file_path
	for i in $(seq 1 "$num_of_lines"); do
		write-to-file "$file_path" "" "false"
	done
}

###########################################
### Setup the exercise local repository ###
###########################################

# Create the git repository for this exercise.
function setup-env(){

	# Create empty repository.
	git init $repo_directory
	cd $repo_directory
	
	# Initialize git config to make sure that you can commit changes
	git config --local user.name "developer"
	git config --local user.email "developer@gmail.com"
	
	local file_name="file"
	for j in {0..9}; do
		fill-file-with-empty-lines "${file_name}_${j}.txt" "10"
	done
	
	add-and-commit "Add empty files"
	
	git checkout -b bugfix
	
	local file_path=""
	
	for j in {0..9}; do
		file_path="${file_name}_${j}.txt"
		sed -i '1c created a fuction foo1' "$file_path"
	done
	add-and-commit "Commit 1"
	
	for j in {0..9}; do
		file_path="${file_name}_${j}.txt"
		sed -i '2c LOG FOR DEBUG' "$file_path"
		sed -i '4c created a fuction foo2' "$file_path"
		sed -i '5c LOG FOR DEBUG' "$file_path"
		sed -i '8c LOG FOR DEBUG' "$file_path"
		sed -i '9c Fixed the bug' "$file_path"
	done
	add-and-commit "Add logs for debug"
	
	for j in {0..9}; do
		file_path="${file_name}_${j}.txt"
		sed -i '7c Fixed the bug' "$file_path"
	done
	add-and-commit "Fixed the bug"
}

#################
### Run setup ###
#################

setup-env

