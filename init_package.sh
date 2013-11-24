#!/bin/bash
# Usage is as follows.
# In R:
#   package.skeleton('package-name', code_files='*.R', force=TRUE)
# Then:
#   cd package-name
#   init_platform.sh
# 
# Alternatively if you already have most of a package and want 
# test harnesses, ignore files, etc, then just run init_platform.sh
# in the root of the package directory.

date=$(date +%Y-%m-%d)
package=${PWD##/*/}
# TODO: Specify RUnit or testthat
testlib=testthat

setup_directories() {
  for dir in R man tests inst/tests
  do
    [ ! -d "$dir" ] && mkdir -p $dir
  done
}

setup_testthat() {
  [ ! -f 'tests/run_tests.R' ] && echo "library(testthat)
library_if_available($package)
test_package('$package')" > tests/run_tests.R
}

setup_description() {
  [ ! -f 'DESCRIPTION' ] && echo "Package: $package
Type: Package
Title: ~~
Version: 1.0.0
Date: $date
Author: 
Maintainer: 
Imports:
Suggests:
    $testlib
Description: ~~
License: LGPL-3
LazyLoad: yes
Collate:
" > DESCRIPTION
}

setup_namespace() {
  [ ! -f 'NAMESPACE' ] && echo 'exportPattern("^[^\\.]")' > NAMESPACE
}

setup_package_rd() {
  [ ! -f "R/$package-package.R" ] && echo "# :vim set filetype=R
#' TITLE
#'
#' DESCRIPTION
#'
#' \tabular{ll}{
#' Package: \tab ${package}\cr
#' Type: \tab Package\cr
#' Version: \tab 1.0.0\cr
#' Date: \tab ${date}\cr
#' License: \tab LGPL-3\cr
#' LazyLoad: \tab yes\cr
#' }
#'
#' @name $package-package
#' @aliases $package-package $package
#' @docType package
#' @exportPattern \"^[^\\.]\"
#' @import lambda.r
#' @author AUTHOR <AUTHOR@@DOMAIN.COM>
#' @seealso \code{\link{other.package}}
#' @keywords package
NULL" > R/$package-package.R
}

setup_r_ignore() {
  [ ! -f ".Rbuildignore" ] && echo "^.*\.Rproj$
^\.Rproj\.user$
^rename$
^\.gitignore$
^README.md$
^LICENSE$
^tools$
^.travis.yml$
" > .Rbuildignore
}

setup_git_ignore() {
  [ ! -f ".gitignore" ] && echo "# History files
.Rhistory
.RData

# Example code in package build process
*-Ex.R" > .gitignore
}

setup_travis() {
  [ ! -f ".travis.yml" ] && cat > .travis.yml <<EOM
# it is not really python, but there is no R support on Travis CI yet
language: python

# environment variables
env:
  - R_LIBS_USER=~/R

# install dependencies
install:
  - sudo apt-add-repository -y 'deb http://cran.rstudio.com/bin/linux/ubuntu precise/'
  - sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
  - sudo apt-add-repository -y ppa:marutter/c2d4u
  - sudo apt-get update
  - sudo apt-get install --no-install-recommends libcurl4-openssl-dev
      r-base-dev r-cran-xml r-cran-rcurl r-cran-mass r-cran-codetools 
      r-cran-lattice r-cran-matrix r-cran-nlme r-cran-survival r-cran-boot
      r-cran-cluster r-cran-foreign r-cran-kernsmooth r-cran-rpart 
      r-cran-class r-cran-nnet r-cran-spatial r-cran-mgcv
      qpdf texinfo texlive-latex-recommended texlive-latex-extra lmodern 
      texlive-fonts-recommended texlive-fonts-extra
  - "[ ! -d ~/R ] && mkdir ~/R"
  - R --version
  - R -e '.libPaths(); sessionInfo()'
  - R --vanilla -e 'options(repos = c("http://rforge.net", "http://cran.rstudio.org"))'
      -e 'install.packages(c("devtools","testthat"))'
      -e 'library(devtools)'
      -e 'install_github("lambda.r","zatonovo")'
      -e 'install()'
  - git clone https://github.com/muxspace/crant.git ~/crant

# run tests
script:
  - ~/crant/rant -S
EOM
}


setup_directories
setup_description
setup_namespace
setup_package_rd
setup_r_ignore
setup_git_ignore
setup_testthat
setup_travis

echo "To complete initialization be sure to complete R/$package-package.R"
