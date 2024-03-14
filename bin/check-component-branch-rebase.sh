#!/bin/bash

# The script checks if the branches ending with '-fix' have been rebased on their corresponding '-basic' branch in each component's repository.

# Go to the folder which contains all theses repositories and execute this script.

# List of repositories
repositories=(
    "hadoop"
    "tez"
    "spark-hive"
    "spark"
    "hive"
    "hbase"
    "ranger"
    "phoenix"
    "phoenix-queryserver"
    "knox"
    "hbase-connectors"
    "hbase-operator-tools"
)

# Function to check branches
check_branches() {
    cd "$1" || return
    echo "Checking repository: $(basename "$1")"
    
    # Fetch latest changes from remote
    git fetch origin

    # Initialize an empty array
    basic_branches=()

    # Read each line of the command output into the array
    while IFS= read -r branch; do
        # Append each branch to the array
        basic_branches+=("$branch")
    done < <(git branch -r --list 'origin/*-basic')

    # Check if the array is empty
    if [ ${#basic_branches[@]} -eq 0 ]; then
        echo "No branches matching the pattern 'origin/*-basic' found."
    else
        # Loop through each branch in the array
        for ((i=0; i<${#basic_branches[@]}; i++)); do
            # Replace "-basic" with "-fix" for each branch
            fix_branch=${basic_branches[i]/-basic/-fix}
            echo "Basic branch: ${basic_branches[i]}"
            # Check if fix branch contains the basic branch
            if git merge-base --is-ancestor ${basic_branches[i]} $fix_branch; then
                echo "Branch -fix is based on -basic branch"
            else
                echo "Error: Branch -fix is not based on -basic branch"
            fi
        done
    fi
    cd ..
}

# Loop through each repository
for repo in "${repositories[@]}"; do
    check_branches "$repo"
    echo ""
done
