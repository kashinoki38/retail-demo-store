#!/bin/bash

source .venv/bin/activate

dir="$PWD"
home_dir="$(dirname "$dir")"
cd "$home_dir" || exit 1

: '
If we have accepted an argument (service name), attempt to change into that directory.
This ensures we only run tests for that service as requested.
'
if [ ! -z "$1" ]; then
  cd "$1" || { echo "Service does not exist."; exit 1; }
fi

#########################
####### Functions #######
#########################
# Execute pytest in all directory with the name "integ"
run_all_tests() {
  failed_tests=0
  total_tests=0
  for dir in $(find . -type d  -name 'integ')
  do
    pushd "$dir"
    pytest test*.py || failed_tests=$[failed_tests + 1]
    total_tests=$[total_tests + 1]

    # Change back into home directory after each set of tests
    popd
  done

  echo "########################################"
  echo "#### Summary: ($failed_tests/$total_tests) test suits fail ####"
  echo "########################################"
  return $failed_tests
}


run_all_tests
result=$?

deactivate

exit $result



