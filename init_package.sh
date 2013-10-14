#!/bin/bash

date=$(date +%Y-%m-%d)
package=${PWD##/*/}
# TODO: Specify RUnit or testthat
testlib=testthat

setup_directories() {
  mkdir R man tests
  mkdir -p inst/tests
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
