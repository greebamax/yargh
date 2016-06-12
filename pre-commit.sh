#!/bin/sh
#
# The hook script validates js files with a linter
set +x

failed_commit_msg="
COMMIT FAILED
Your commit contains files that should pass ESLint but do not.
Please fix ESLint errors and try again.
"

success_commmit_msg="COMMIT SUCCEEDED"

eslint_missing_msg="
ESLint installed locally requires
Run 'npm install' first
"

function join { local IFS="$1"; shift; echo "$*"; }

# list of supported file formats
supported_files=( js )

# regex to match changed files from git status output
pattern="[AM?]+\s.+\.($(join \| ${supported_files[@]}))$"

# define changed files
function changed_files {
  echo $(git status -sb | grep -E $pattern | cut -c3-)
}

# ESLint configure
eslint_local=node_modules/eslint/bin/eslint.js # path to project eslint binary
eslint_cfg_local=.eslintrc # path to project eslint config

is_eslint_exist=$(command -v $eslint_local)

if [ ! -x "$is_eslint_exist" ] ; then
  echo $eslint_missing_msg
  exit 1
fi

# execute linting on file by local eslint module
function lint () {
  eval $eslint_local -c $eslint_cfg_local $1;
}

files=$(changed_files);

if [ ! -z "${files}" ]; then

  echo "Validating JavaScript:"
  pass=true

  for file in ${files}; do

    lint_result=$(lint $file)

    if [[ $lint_result == '' || $lint_result =~ '0 errors' ]]; then
      echo "ESLint Passed: ${file}"
    else
      echo "ESLint Failed: ${file}"
      pass=false
    fi

  done

  echo "JavaScript validation complete"

  if ! $pass; then
    echo $failed_commit_msg
    exit 1
  else
    echo $success_commmit_msg
    exit 0
  fi

fi
