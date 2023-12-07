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
bash Miniconda3-latest-Linux-x86_64.sh -bfp /usr/local/miniconda3
export PATH=/usr/local/miniconda3/bin:$PATH

echo "Creating conda environment"
conda create -n habitat python=3.6
conda activate habitat
echo "Done"
cd /usr/local
ls
cd
ls

cd /content/
ls
