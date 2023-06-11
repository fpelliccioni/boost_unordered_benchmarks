#!/bin/bash

# sudo dnf install libcgroup-tools

set -x
set -e

export GITHUB_WORKSPACE=/home/fernando/boost/boost_unordered_benchmarks
# export GITHUB_WORKSPACE=/home/fernando/dev/boost/boost_unordered_benchmarks-fpelliccioni

export ARCHITECTURE="-m64 -march=native"
export VCPKGTRIPLET=x64-linux
export SOURCEFILE=parallel_load.cpp
# export COMPILEROPTIONS="-std=c++2a -O3 -DNDEBUG -DCFOA_NO_EMBEDDED_GROUP_ACCESS"
export COMPILEROPTIONS="-std=c++2a -O3 -DNDEBUG"
export OUTPUTFILE=benchmark
export REPORTDIR=gcc-x64
# install: g++-11 curl zip unzip tar pkg-config

# export COMMAND="sudo cset shield --exec -- nice -n -20 sudo -u gha ./benchmark"
# export COMMAND="sudo cgexec -g memory,cpu:shield sudo -u gha ./benchmark"
# export COMMAND="./benchmark"
export COMMAND="sudo cgexec -g memory,cpu:shield ./benchmark"

# export NUM_THREADS=128
export NUM_THREADS=64

# # Prepare Repo
# git clone https://github.com/fpelliccioni/boost_unordered_benchmarks.git
# cd boost_unordered_benchmarks
# git pull
# # git checkout parallel_hashmap_benchmark
# git checkout boost_concurrent_flat_map

# #  Install Boost
# cd $GITHUB_WORKSPACE
# git clone https://github.com/boostorg/boost.git boost-root
# cd boost-root
# git checkout develop
# git submodule update --init
# ./bootstrap.sh
# ./b2 -d0 headers

#  Update Boost
cd $GITHUB_WORKSPACE
cd boost-root
git checkout develop
git pull
git submodule update --init
# ./bootstrap.sh
# ./b2 -d0 headers

# Install Boost.Unordered branch feature/cfoa
cd $GITHUB_WORKSPACE
rm -rf boost_unordered-root
git clone -b feature/cfoa https://github.com/boostorg/unordered.git boost_unordered-root

# # Install oneTBB
# cd $GITHUB_WORKSPACE
# mkdir -p .vcpkg
# touch .vcpkg/vcpkg.path.txt
# cd $GITHUB_WORKSPACE
# git clone https://github.com/Microsoft/vcpkg.git
# cp x86-linux.cmake vcpkg/triplets
# cd vcpkg
# ./bootstrap-vcpkg.sh -disableMetrics
# ./vcpkg integrate install
# ./vcpkg install tbb:${VCPKGTRIPLET}

# # Install gtl
# cd $GITHUB_WORKSPACE
# git clone https://github.com/greg7mdp/gtl.git gtl-root

#  Compile
cd $GITHUB_WORKSPACE
g++ --version
g++ ${SOURCEFILE} ${ARCHITECTURE} ${COMPILEROPTIONS} -o ${OUTPUTFILE} -DNUM_THREADS=${NUM_THREADS} -I$GITHUB_WORKSPACE/boost_unordered-root/include -I$GITHUB_WORKSPACE/boost-root -I$GITHUB_WORKSPACE/vcpkg/installed/${VCPKGTRIPLET}/include -I$GITHUB_WORKSPACE/gtl-root/include -L$GITHUB_WORKSPACE/vcpkg/installed/${VCPKGTRIPLET}/lib -pthread -ltbb -ltbbmalloc

# Set reportfile name
export REPORT_FILE="${REPORTDIR}/${SOURCEFILE}.csv"

echo "running benchmarks and saving to ${REPORT_FILE}"
${COMMAND} | tee ${REPORT_FILE}

#  Push benchmark results to repo
# git config --global user.name 'joaquintides'
# git config --global user.email 'joaquintides@users.noreply.github.com'
# git add ${REPORT_FILE}
# git stash -- ${REPORT_FILE}
# git pull
# git stash pop
# git add ${REPORT_FILE}
# git commit -m "updated benchmark results"
# git push



# final:

# # Install Python packages
# python -m pip install --upgrade pip
# pip install openpyxl

# # Fast-forward repo
# git pull

# # Run data feeding script
# ./insert_data.sh

# # Push modified Excel files to repo
# # git config --global user.name 'joaquintides'
# # git config --global user.email 'joaquintides@users.noreply.github.com'
# git commit -am "updated Excel files"
# git push
