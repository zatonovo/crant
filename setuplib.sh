#!/bin/bash
# Set up R libraries
# Example:
#   setuplib.sh -R ~/devel/bin/R RUnit testthat parser
R=R
repo=http://cran.mirrors.hoobly.com
while getopts "r:tR:" opt
do
  case $opt in
  r) repo=$OPTARG;;
  t) tests='INSTALL_opts="--install-tests"';;
  R) R=$OPTARG;;
  esac
done
shift $(($OPTIND - 1))

for pkg in $*
do
  echo "Installing $pkg"
  ${R}script --vanilla \
    -e "install.packages('$pkg', repos='$repo', $install_opts)"
done

