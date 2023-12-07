#!/bin/bash
set -e
shopt -s extglob
shopt -s globstar

#Checks if in Google Colab and does not run installation if it is not
python -c 'import google.colab' 2>/dev/null || exit
#Don't run again if it's already installed
[ -f /content/habitat_sim_installed ] && echo "Habitat is already installed. Aborting..." >&2 && exit
trap 'catch $? $LINENO' EXIT # Installs trap now
catch() {
  if [ "$1" != "0" ]; then
    echo "An error occured during the installation of Habitat-sim or Habitat-Lab." >&2
  fi
}
#Install Miniconda
cd /content/
wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -bfp /usr/local

#Adds the conda libraries directly to the colab path.
ln -s /usr/local/lib/python3.10/dist-packages /usr/local/lib/python3.10/site-packages

##Install Habitat-Sim and Magnum binaries
conda config --set default_threads 4 #Enables multithread conda installation
NIGHTLY="${NIGHTLY:-false}" #setting the ENV $NIGHTLY to true will install the nightly version from conda
CHANNEL="${CHANNEL:-aihabitat}"
if ${NIGHTLY}; then
  CHANNEL="${CHANNEL}-nightly"
fi
conda install -y --prefix /usr/local -c "${CHANNEL}" -c conda-forge habitat-sim headless withbullet python=3.6

#Shallow GIT clone for speed
echo "We reached here ..."
git clone https://github.com/facebookresearch/habitat-lab/tree/v0.1.6 --depth 1
git clone https://github.com/facebookresearch/habitat-sim/tree/v0.1.6 --depth 1
echo "Done..."
pwd
ls
