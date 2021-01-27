#!/bin/bash

# ------------------------------------------------------------------- #
#
# Title: URL sanitisation
#
# Original author: Mark Battistella - 2020.12
# Updated author:  George O'Connor  - 2021.01
#
# Re-write author: Mark Battistella - 2021.01
#
# This script is written for usage with Github Actions
# 1. Searches the repository for urls
# 2. Checks them with the Google Safe Browsing API
# 3. If they are unsafe, they are replaced with a user defined string
# 4. Push it back to the repository
#
# ------------------------------------------------------------------- #


# info: exit if error
set -eu
# "set -e" short for "set -o errexit"
# --> that is, abort the script if a command returns with a non-zero exit code
# "set -u" short for "set -o nounset"
# --> that is, abort the script if a variable name is dereferenced when the variable hasn't been set


# info: set up colours
CLR="\033[0m"
RED="\033[0;31m"
GRN="\033[0;32m"
BLU="\033[0;34m"
YLW="\033[0;33m"


# info: git setup
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")


# info: command line arguments
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
INPUT_API=${INPUT_API}
INPUT_REPLACE=${INPUT_REPLACE:-'~~REDACTED~~'}
INPUT_AUTHOR_EMAIL=${INPUT_AUTHOR_EMAIL:-'github-actions[bot]@users.noreply.github.com'}
INPUT_AUTHOR_NAME=${INPUT_AUTHOR_NAME:-'github-actions[bot]'}
INPUT_MESSAGE=${INPUT_MESSAGE:-"Sanitised URLs via Google Safe Browsing API on ${TIMESTAMP}"}
INPUT_BRANCH=${INPUT_BRANCH:-main}
INPUT_EMPTY=${INPUT_EMPTY:-false}
INPUT_FORCE=${INPUT_FORCE:-false}


# --> api key
if [ -z "${INPUT_API}" ]; then
	echo -e "${RED}No API key specified. Exiting.${CLR}"
	echo -e "Please visit Google API for a key (https://developers.google.com/safe-browsing/)"
	exit 1
else
	INPUT_DIRECTORY="${INPUT_DIRECTORY}"
fi


# info: install npm module (globally)
npm i -g @markbattistella/markdown-safe-link


# debug: log the directory and the replacement text
echo -e "${BLU}SEARCH DIRECTORY:${CLR}  ${INPUT_DIRECTORY}"
echo -e "${BLU}REPLACE URLS WITH:${CLR} ${INPUT_REPLACE}"


# run it
markdown-safe-link \
	--dir="${INPUT_DIRECTORY}" \
	--api="${INPUT_API}" \
	--replace="${INPUT_REPLACE}"


# git: where we will push to
echo -e "Push to branch ${YLW}${INPUT_BRANCH}${CLR}";

# git: did we pass a token
if [ -z "${INPUT_GITHUB_TOKEN}" ]; then
    echo -e "${RED}ERROR: ${CLR}Missing input github_token.";
    exit 1;
fi

# git: are we passing an empty commit
if [ ${INPUT_EMPTY} ]; then
    _EMPTY='--allow-empty'
fi

# git: force commit
if [ ${INPUT_FORCE} ]; then
    _FORCE_OPTION='--force'
fi

# git: go to directory
cd "${INPUT_DIRECTORY}"

# git: set remote repository
REMOTE_REPOSITORY="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

# git: SSL verification not needed
git config http.sslVerify false

# git: set the user and email for commit
git config --local user.email "${INPUT_AUTHOR_EMAIL}"
git config --local user.name  "${INPUT_AUTHOR_NAME}"

# git: add ALL changes
git add -A

# git: commit with a message
git commit -m "{$INPUT_MESSAGE}" $_EMPTY || exit 0

# git: push to remote
git push "${REMOTE_REPOSITORY}" HEAD:"${INPUT_BRANCH}" --follow-tags $_FORCE_OPTION;
