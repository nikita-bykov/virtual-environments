#!/bin/bash -e
################################################################################
##  File:  haskell.sh
##  Desc:  Installs Haskell
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/etc-environment.sh

mkdir -p /usr/bin/.ghcup/bin
curl https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup -o /usr/bin/.ghcup/bin/ghcup
chmod +x /usr/bin/.ghcup/bin/ghcup
export PATH="/usr/bin/.ghcup/bin:$PATH"
echo 'export PATH="/usr/bin/.ghcup/bin:$PATH"' | tee -a /etc/skel/.bashrc

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