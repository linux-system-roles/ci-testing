#!/bin/bash -l

set -euxo pipefail

exec 2>&1

for file in /etc/yum.repos.d/CentOS-*.repo; do
  if ! grep '^baseurl=.*vault[.]centos[.]org' "$file"; then
    sed -i -e 's,^mirrorlist,#mirrorlist,' \
           -e 's,^#baseurl=,baseurl=,' \
           -e 's,mirror.centos.org/centos/$releasever,vault.centos.org/6.10,' \
           "$file"
  fi
done

yum install -y epel-release git
yum install -y python-pip
echo home
ls -alrtF $HOME
pip install --upgrade pip
echo more
ls -alrtF $HOME/.cache $HOME/.cache/pip || :
ip install 'tox<3' 'virtualenv==15.*' 'pluggy==0.5.*' "$TOX_LSR"
lsr_ci_preinstall
tox -e py26,coveralls,custom
