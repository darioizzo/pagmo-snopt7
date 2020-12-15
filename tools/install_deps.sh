#!/usr/bin/env bash

# Echo each command
set -x

# Exit on error.
set -e

# For the non manylinux builds (i.e. pip) we use conda and thus install and activate a conda environment
if [[ "${PAGMO_PLUGINS_NONFREE_BUILD}" != manylinux* ]]; then
    if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
        wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh;
    else
        wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
    fi
    export deps_dir=$HOME/local
    export PATH="$HOME/miniconda/bin:$PATH"
    export PATH="$deps_dir/bin:$PATH"

    bash miniconda.sh -b -p $HOME/miniconda
    conda config --add channels conda-forge --force

    # All builds will need these
    conda_pkgs="boost cmake pagmo-devel cxx-compiler"

    # Only Python builds will need these
    if [[ "${PAGMO_PLUGINS_NONFREE_BUILD}" == "Python37" ]]; then
        conda_pkgs="$conda_pkgs python=3.7 pygmo" 
    fi

    if [[ "${PAGMO_PLUGINS_NONFREE_BUILD}" == *Python* ]]; then
        conda_pkgs="$conda_pkgs graphviz doxygen sphinx breathe pybind11"
    fi

    # We create the conda environment and activate it
    conda create -q -p $deps_dir -y $conda_pkgs
    source activate $deps_dir
fi

set +e
set +x