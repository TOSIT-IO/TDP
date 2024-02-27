#!/bin/bash

# The script checks if the branches ending with '-TDP' have been rebased on their corresponding '-build' branch in each component's repository.

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
    build_branches=()

    # Read each line of the command output into the array
    while IFS= read -r branch; do
        # Append each branch to the array
        build_branches+=("$branch")
    done < <(git branch -r --list 'origin/*-build')

    # Check if the array is empty
    if [ ${#build_branches[@]} -eq 0 ]; then
        echo "No branches matching the pattern 'origin/*-build' found."
    else
        # Loop through each branch in the array
        for ((i=0; i<${#build_branches[@]}; i++)); do
            # Replace "-build" with "-TDP" for each branch
            tdp_branch=${build_branches[i]/-build/-TDP}
            echo "Build branch: ${build_branches[i]}"
            # Check if TDP branch contains the build branch
            if git merge-base --is-ancestor ${build_branches[i]} $tdp_branch; then
                echo "Branch -TDP is based on -build branch"
            else
                echo "Error: Branch -TDP is not based on -build branch"
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
