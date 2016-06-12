
#!/bin/sh
#
# The hook script validates commit messages on each commit.
# Allowed format: <JIRA_PROJECT_PREFIX>-#### Commit message
# preceded by a single space. Otherwise you can use one of
# allowed word at the start of commit message to determine
# commit kind
set +x

function join { local IFS="$1"; shift; echo "$*"; }

# allowed prefixes
jira_project_prefixes=(AG ND) # list of JIRA projects prefixes
whitelisted_prefixes=(FIX HOTFIX REFACTORING TYPO TECH TEST) # allowed words which used to determine commit kind

# regex to validate commit message
commit_regex="^(Merge|$(join \| ${whitelisted_prefixes[@]})|($(join \| ${jira_project_prefixes[@]})){1}\-[0-9]+){1}[[:blank:]]"

error_msg="
ABORTING COMMIT:
Your commit message is missing either a JIRA Issue or one of allowed prefixes.
Allowed prefixes: FIX, HOTFIX, REFACTORING, TYPO, TECH or TEST.
Examples: 'AG-1234 Commit message preceded by a single space' or 'FIX hotfix to prod'
"

if grep -iqE "$commit_regex" "$1"; then
  exit 0
else
  echo "$error_msg" >&2
  exit 1
fi
