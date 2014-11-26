crant
=====
The crant toolkit is designed to streamline the package development process.


Workflow
========

Build R, set up package libraries, build your own packages.

Build R
-------
Make sure crant is in your path and then build your instances of R. If you
already have an R instance and don't want to build from source, you can skip
this step (although you still need to have crant in your path).

    export PATH=$PATH:path/to/crant
    buildenv.sh -u

If the OS is brand new, then include the -d option to install dependencies.
These include packages like make, gcc, gfortran, java, etc.

    buildenv.sh -du

The end result is that you will have 3 installations of R built from source
that correspond to the latest minor release (e.g. 2.15), the latest patch
release (e.g. 2.15.2), and the current development source (R-devel).

As the source changes over time, you can re-build the R versions to stay
current. The defaults will change by the maintainer to be current with the
latest point and patch releases.

Installing packages
-------------------
Libraries need to be built once R has been built successfully. These are
typically the package dependencies you have. At a minimum you will probably
want the unit testing packages since these are usually listed as 'suggested',
so will not be downloaded automatically.

    rpackage -R path/to/R RUnit testthat

The rpackage command knows about more than CRAN. You can also specify github 
repositories or private git repos.

    rpackage futile.logger https://github.com/zatonovo/odessa/archive/master.zip https://user:pass@my.private.repo/repo.git

Note that if your R instance is in your path, you do not need to manually
set the path to the R executable. This option is if you have multiple R
installations (e.g. devel, patch, release) in your environment.

Building your package
---------------------
The crant script will build and check your package. If your source is within a
source repository, crant will attempt to export the latest committed version
to a separate directory (export). If you are in a source directory, crant doesn't
require any options.

    crant 

In active development, you might want to use these options:

    crant -SCi

which uses the local modified source code, skips checks, and installs the package
after building.

### ROxygen
If your documentation is inline with ROxygen, use the `-x` or `-X` options.
The lower case `crant -SCix` variant will build the source along with the 
documentation, while the upper case variant `crant -X` will halt the process. 
This is useful if you need to test formatting. Once documentation is generated,
it is more efficient to not regenerate it on subsequent builds.

NOTE: If you use the `-x` or `-X` option on a project that does not use
ROxygen, your `man` directory will become corrupted.

### Version Numbers
Crant will automatically increment version numbers or you can specify it
manually.

    crant -v 1.0.0 

To ignore the repository version and pull the latest working copy use the `-S`
option.

If testing your package just before uploading to CRAN, it is wise to test 
against the three versions of R you built before. Use the same `-R` option as
before.

    crant -v 1.0.0 -R path/to/R your.package

Note that crant will automatically update the version and date in the
`DESCRIPTION`, `man/*-package.Rd` and `R/*-package.R` files for you.
In addition, for the files `NEWS`, `NEWS.md` and `ChangeLog`, if a corresponding
file with the extension `.tmpl` exists, its contents are prepended to the file
(placeholders `$VERSION` and `$BUILDDATE` are substituted).

### Other Options

+ `-s` - Do not autocommit, allow dirty working copy
+ `-S` - Build against uncommitted source. Implies `-s`
+ `-i` - Install the package after building
+ `-I` - Copy (overwrite) the package `.tar.gz` to the parent directory after building
+ `-r` - Run the CRAN checks
+ `-C` - Do not run `R CMD check`
+ `-V` - Do not build vignettes, even not when running CRAN checks
+ `-M` - Do not build manual, even not when running CRAN checks
+ `-u #` - Increment version number at specific position, # = 1..4 (instead of `-v`)
+ `-d DATE` - Specify build date
+ `-x` - Roxygenize
+ `-X` - Roxygenize and exit
+ `-R /path/to/R` - Use specific R interpreter
+ `-b` - Build binary package
+ `-h HOSTNAME` - Build binary package on Windows host `HOSTNAME`
    + SSH service and bash is assumed to be installed on remote Windows host
    + Package is assumed to be located in directory `$WORKSPACE` on remote host
+ `-e` Export to CRAN (not yet implemented)
    + `-D` - Use `--resave-data` when executing `R CMD build`

Mac OS X Notes
==============
Since Mac OS X comes from a BSD lineage, the versions of base utility
commands have different syntax. This causes a lot of problems. The
workaround is to install ```coreutils```, which installs the GNU 
variants of all the commands. The crant script detects a Darwin platform
and will substitute the ```g``` variants for the standard commands.

In addition, the `mktemp` utility is coerced to use the proper options 
depending on platform.


