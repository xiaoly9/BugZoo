#!/bin/bash
EXECUTABLE=$1
TEST_ID=$2
here_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if this test script is being used to compute coverage information.
if [ $(basename $1) = "coverage" ]; then
  cov=1
else
  cov=0
fi

# Treats the test case as a positive test case.
exec_pos()
{
  if [ $cov = 0 ]; then
    timeout 2 bash -c "$EXECUTABLE < $here_dir/test/$TEST_ID" \
      |& diff $here_dir/test/output.$TEST_ID - &> /dev/null
  else
    bash -c "$EXECUTABLE < $DIR/test/$TEST_ID" \
      |& diff $here_dir/test/output.$TEST_ID - &> /dev/null
  fi
  return $?
}

# Treats the test case as a negative test case.
exec_neg()
{
  if [ $cov = 0 ]; then
    timeout 1 $EXECUTABLE < $here_dir/test/n1 &> /dev/null
  else
    timeout 10 $EXECUTABLE < $here_dir/test/n1 &> /dev/null
  fi
  return $?
}

# Execute the appropriate test case.
case $TEST_ID in
  p1) exec_pos && exit 0;;
  p2) exec_pos && exit 0;;
  p3) exec_pos && exit 0;;
  p4) exec_pos && exit 0;;
  p5) exec_pos && exit 0;;
  n1) exec_neg && exit 0;;
esac
exit 1