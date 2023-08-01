#!/bin/bash

set -e
set -x

# sync rom
repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-20.0
git clone https://github.com/AyOn9914/android_.repo_local_manifests.git --depth 1 -b aex .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
lunch lineage_begonia-userdebug
make -j$(nproc --all)

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/begonia/*.zip
