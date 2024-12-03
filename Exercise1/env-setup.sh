#!/bin/bash

################################
### Arguments for the script ###
################################

repo_directory="$1"

#################
### Constants ###
#################

letters=('a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z')

#########################
### Auxiliary methods ###
#########################

# Stage all the current changes and then commit them.
function add-and-commit(){
	local commit_message="$1"
	git add --all
	git commit -m "$commit_message"
}

# Generate random char and return the result in a global variable.
function get-random-char(){
	local letter_index=$(($RANDOM % ${#letters[@]}))
	random_char_result=${letters[letter_index]}
}

# Generate a random line of letters.
function generate-single-line(){
	local num_of_chars=$1
	single_line_result=""
	for i in $(seq 1 "$num_of_chars")
	do
		get-random-char
		single_line_result="${single_line_result}${random_char_result}"
	done
}

# Generate multiple random lines.
function generate-lines(){
	local num_of_lines=$1
	local num_of_chars=$2
	local -n result_array=$3  # Pass the array by reference
	echo "num_of_lines=$num_of_lines num_of_chars=$num_of_chars"
	
	lines_result=""
	
	for j in $(seq 1 "$num_of_lines")
	do
		generate-single-line ${num_of_chars}
		
		result_array+=("$single_line_result")
	done
}

# Replace a single char in the given string with the given replacement at a given index.
# If the char[index] is equal to the replacement pick randomly a different index until the prior conditino returns false.
function replace-char(){
	local string=$1
	local replacement=$2
	local index=$3
	
	replacement_result=""
	
	local char_to_replace="${string:index:1}"
	local num_of_trys=0
	while [[ "$char_to_replace" == "$replacement" || "$char_to_replace" == "!" && "$num_of_trys" -lt 100 ]]
	do
		index=$(($RANDOM%${#string}))
		char_to_replace="${string:index:1}"
		num_of_trys=$((num_of_trys+1))
	done
	
	if [[ $index -eq 0 ]] ; then
		replacement_result="${replacement}${string:index+1}"
				
	elif [[ $index -lt ${#string} && $index -gt 0 ]] ; then
		replacement_result="${string:0:index}${replacement}${string:index+1}"
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

	local mysterious_file_path="mysterious-test.sh"
	touch $mysterious_file_path
	
	local num_of_lines=40
	local num_of_chars=120
	local num_of_commits=128
	
	declare -a my_array
	generate-lines $num_of_lines $num_of_chars my_array
	
	local rand_commit_index=$(($RANDOM%${num_of_commits}))
	if [[ $rand_commit_index -eq 0 || $rand_commit_index -eq $((num_of_commits-1)) ]]; then
		rand_commit_index=1
	fi
	
	for k in $(seq 1 "$num_of_commits")
	do
		local rand_line_idx=$(($RANDOM % ${num_of_lines}))
		local rand_char_idx=$(($RANDOM % ${num_of_chars}))
		if [[ $k -eq $((rand_commit_index+1)) ]] ; then
			replace-char "${my_array[$rand_line_idx]}" "!" $"rand_char_idx"
			my_array[$rand_line_idx]=$replacement_result
		else
			get-random-char
			local rand_char=$random_char_result
			
			replace-char "${my_array[$rand_line_idx]}" "$rand_char" $"rand_char_idx"
			my_array[$rand_line_idx]=$replacement_result
		fi
		
		echo "#!/bin/bash" > $mysterious_file_path # truncate the file
		
		echo "coded_key=\"" >> $mysterious_file_path
		for item in "${my_array[@]}"; 
		do
			echo "$item" >> $mysterious_file_path
		done
		echo "\"" >> $mysterious_file_path
		
		local if_statment="
if [[ \"\$coded_key\" == *\"!\"* ]]; then
  echo \"Test Failed!!!!!\"
else
  echo \"Test Succeded!!!!!\"
fi
		"
		echo "$if_statment" >> $mysterious_file_path
		
		add-and-commit "commit number $k"
		
		# Start the new feature branch.
		if [[ $k -eq 1 ]] ; then
			git checkout -b feature
		fi
		
	done
}

#################
### Run setup ###
#################

setup-env

