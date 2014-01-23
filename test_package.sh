#!/bin/bash

R=R
sed=sed


set_sed()
{
  platform=$(uname -s)
  if [ "$platform" = "Darwin" ]
  then
    echo "NOTE: Using GNU coreutils on Darwin"
    sed=gsed
    readlink=greadlink
  fi
}

read_package_name()
{
  package_name=$($sed -n -r \
    "/^Package:/{s/^Package:[ \t]+([^ \t]+)[ \t]*$/\1/;p}" DESCRIPTION)
  [ -z "$package_name" ] &&
    fatal 2 "Cannot determine package name. Is your DESCRIPTION file properly formatted?"
  echo -n "$package_name"
}


get_reverse_deps() {
  raw=$(${R}script -e "library(tools); dependsOnPkgs('$package')")
  clean=$(echo $raw | $sed 's/\[[0-9]\+\] //g' | tr -d '"' | tr -d "'")
  if [ -n "$ignore_revdeps" ]
  then
    ignore=$(echo $ignore_revdeps | $sed 's/ /\\|/g')
    clean=$(echo $clean | tr ' ' '\n' | grep -v $ignore)
  fi
  echo $clean
}

run_tests() {
  echo "Testing all reverse dependencies"
  rm -rf deps
  mkdir deps
  string=$(echo "$revdeps" | $sed "s/ /', '/g")
  pkgvec="c('$string')"
  ${R}script \
    -e "library(tools)" \
    -e "sapply($pkgvec, function(x) testInstalledPackage(x, outDir='deps'))"
}


do_install() {
  echo "Installing existing version of $package from CRAN"
  setuplib.sh $package

  echo "Installing reverse dependencies:"
  echo $revdeps
  setuplib.sh -t $(echo $revdeps | $sed 's/"//g')

  echo "Installing $package from source"
  crant -SCi
  if [ "$?" -gt "0" ]
  then
    echo "FATAL: Error building package"
    exit 1
  fi
}


set_sed
while getopts "Ir:R:" opt
do
  case $opt in
    I) no_install=1;;
    r) revdeps=$OPTARG;;
    R) ignore_revdeps="$OPTARG";;
  esac
done
shift $(($OPTIND - 1))
package=$1
[ -z "$package" ] && package=$(read_package_name)
[ -z "$revdeps" ] && revdeps="$(get_reverse_deps)"

[ -z "$no_install" ] && do_install
run_tests

