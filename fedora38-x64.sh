#!/bin/bash

set -x
set -e

export GITHUB_WORKSPACE=/home/fernando/boost/boost_unordered_benchmarks
# export GITHUB_WORKSPACE=/home/fernando/dev/boost/boost_unordered_benchmarks

# name: gcc-x64
# compiler: g++-11
export ARCHITECTURE="-m64 -march=native"
export VCPKGTRIPLET=x64-linux
export SOURCEFILE=main.cpp
export DATAFILES="http://mattmahoney.net/dc/enwik9.zip"
export COMPILEROPTIONS="-std=c++2a -O3 -DNDEBUG -DCFOA_NO_EMBEDDED_GROUP_ACCESS"
export OUTPUTFILE=benchmark
export REPORTDIR=gcc-x64
# os: [self-hosted, linux, x64]
# install: g++-11 curl zip unzip tar pkg-config

# export COMMAND="sudo cset shield --exec -- nice -n -20 sudo -u gha ./benchmark"
export COMMAND="./benchmark"

# - uses: actions/checkout@v3
# git clone https://github.com/fpelliccioni/boost_unordered_benchmarks.git
# cd boost_unordered_benchmarks
# git checkout parallel_hashmap_benchmark


# - name: Install packages
# if: matrix.install
# run: |
#     # sudo -E apt-add-repository -y ppa:ubuntu-toolchain-r/test
#     if uname -p | grep -q 'x86_64'; then sudo dpkg --add-architecture i386 ; fi
#     sudo apt-get update
#     sudo apt-get install -y ${{matrix.install}}


# - name: Download large data files
# cd $GITHUB_WORKSPACE
# for URL in "${DATAFILES}"; do
#     FILENAME="${URL##*/}"
#     curl $URL --output $FILENAME
#     unzip $FILENAME
#     rm $FILENAME
# done

# # - name: Install Boost
# cd $GITHUB_WORKSPACE
# git clone https://github.com/boostorg/boost.git boost-root
# cd boost-root
# git checkout develop
# git submodule update --init
# ./bootstrap.sh
# ./b2 -d0 headers

# # - name: Install Boost.Unordered branch feature/cfoa
# cd $GITHUB_WORKSPACE
# git clone -b feature/cfoa https://github.com/boostorg/unordered.git boost_unordered-root

# # - name: Install oneTBB
# cd $GITHUB_WORKSPACE
# git clone https://github.com/Microsoft/vcpkg.git
# cp x86-linux.cmake vcpkg/triplets
# cd vcpkg
# ./bootstrap-vcpkg.sh -disableMetrics
# ./vcpkg integrate install
# ./vcpkg install tbb:${VCPKGTRIPLET}

# # - name: Install libcuckoo
# cd $GITHUB_WORKSPACE
# git clone https://github.com/efficient/libcuckoo.git libcuckoo-root

# # - name: Install gtl
# cd $GITHUB_WORKSPACE
# git clone https://github.com/greg7mdp/gtl.git gtl-root

# - name: Compile
cd $GITHUB_WORKSPACE
g++ --version
g++ ${SOURCEFILE} ${ARCHITECTURE} ${COMPILEROPTIONS} -o ${OUTPUTFILE} -I$GITHUB_WORKSPACE/boost_unordered-root/include -I$GITHUB_WORKSPACE/boost-root -I$GITHUB_WORKSPACE/vcpkg/installed/${VCPKGTRIPLET}/include -I$GITHUB_WORKSPACE/libcuckoo-root/libcuckoo -I$GITHUB_WORKSPACE/gtl-root/include -L$GITHUB_WORKSPACE/vcpkg/installed/${VCPKGTRIPLET}/lib -pthread -ltbb -ltbbmalloc

# - name: Set reportfile name
# echo "REPORT_FILE=${REPORTDIR}/${SOURCEFILE}.txt" >> $GITHUB_ENV
export REPORT_FILE="${REPORTDIR}/${SOURCEFILE}.txt"

# - name: Run benchmarks
# if [ -n "${COMMAND}" ]; then
#     echo "running benchmarks and saving to "${REPORT_FILE}
#     ${COMMAND} | tee ${REPORT_FILE}
# else
#     echo "running benchmarks and saving to "${REPORT_FILE}
#     ./${OUTPUTFILE} | tee ${REPORT_FILE}
# fi

echo "running benchmarks and saving to ${REPORT_FILE}"
${COMMAND} | tee ${REPORT_FILE}


# - name: Push benchmark results to repo
# git config --global user.name 'joaquintides'
# git config --global user.email 'joaquintides@users.noreply.github.com'
# git add ${REPORT_FILE}
# git stash -- ${REPORT_FILE}
# git pull
# git stash pop
# git add ${REPORT_FILE}
# git commit -m "updated benchmark results"
# git push

