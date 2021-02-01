#!/bin/bash -e
################################################################################
##  File:  haskell.sh
##  Desc:  Installs Haskell
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/etc-environment.sh

export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
export GHCUP_INSTALL_BASE_PREFIX=/usr/local
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
export PATH="$GHCUP_INSTALL_BASE_PREFIX/.ghcup/bin:$PATH"
echo 'export PATH="$PATH:$GHCUP_INSTALL_BASE_PREFIX/.ghcup/bin"' | tee -a /etc/skel/.bashrc

availableVersions=$(ghcup list -t ghc -r | grep -v "prerelease" | awk '{print $2}')

minorMajorVersions=$(echo "$availableVersions" | cut -d"." -f 1,2 | uniq | tail -n3)
for majorMinorVersion in $minorMajorVersions; do
    fullVersion=$(echo "$availableVersions" | grep "$majorMinorVersion." | tail -n1)
    echo "install ghc version $fullVersion..."
    ghcup install $fullVersion
    ghcup set $fullVersion
done

echo "install cabal..."
ghcup install-cabal

# Install the latest stable release of haskell stack
curl -sSL https://get.haskellstack.org/ | sh

invoke_tests "Haskell"