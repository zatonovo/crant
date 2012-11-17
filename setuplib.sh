#!/bin/bash
# Set up R libraries
# Example:
#   setuplib.sh -R ~/devel/bin/R RUnit testthat parser
R=R
repo=http://cran.us.r-project.org
while getopts "r:R:" opt
do
  case $opt in
  r) repo=$OPTARG;;
  R) R=$OPTARG;;
  esac
done
shift $(($OPTIND - 1))

for pkg in $*
do
  echo "Installing $pkg"
  ${R}script -e "install.packages('$pkg', depend=TRUE, repos='$repo')"
done

