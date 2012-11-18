#!/bin/bash
export REPOS=https://svn.r-project.org/R
export RTOP=~ #adjust as necessary

# See this page for definitions
# http://developer.r-project.org/SVNtips.html
release_ver=2-15
patch_ver=2
get_branch()
{
  branch=$1
  if [ "$branch" = "release" ]
  then
    # This is a x.y.0 release
    src=$REPOS/R/tags/R-${release_ver}-${patch_ver}
  elif [ "$branch" = "patch" ]
  then
    # Current release branch aka patch x.y.z
    src=$REPOS/branches/R-${release_ver}-branch
  elif [ "$branch" = "devel" ]
  then
    # Development branch (trunk aka R-devel)
    src=$REPOS/trunk
  fi
  echo $src
}

do_setup()
{
  apt-get install gcc
  apt-get install g++
  apt-get install gfortran
  apt-get install texlive
  apt-get install texlive-fonts-extra
  apt-get install default-jdk
  apt-get install libreadline6-dev
  apt-get install make
}

do_build()
{
  branch=$1
  cd $RTOP/$branch
  tools/rsync-recommended
  ./configure --with-x=no
  make
}

get_sources()
{
  for branch in release patch devel
  do
    src=$(get_branch $branch)
    svn co $src $branch
  done
}

# Think about a directory service for R source packages
get_package()
{
  name=$1
}

while getopts "su" opt 
do
  case $opt in
  s) setup=yes;;
  u) update=yes;;
  esac
done

[ -n "$setup" ] && do_setup
[ -n "$update" ] && get_sources

for build in release patch devel
do
  do_build $build
done
