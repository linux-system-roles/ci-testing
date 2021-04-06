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

LSR_EXTRA_PACKAGES_YUM="${LSR_EXTRA_PACKAGES_YUM:-} libffi-devel openssl-devel dbus-devel python-devel"

yum install -y epel-release git $LSR_EXTRA_PACKAGES_YUM
yum install -y python-pip
echo home
ls -alrtF $HOME
#pip install --upgrade pip
echo more
ls -alrtF $HOME/.cache $HOME/.cache/pip || :
mkdir -p $HOME/.cache/pip/http
pip install 'tox<3' 'virtualenv==15.*' 'pluggy==0.5.*' 'py<1.5' "$TOX_LSR"
tox -e py26,coveralls,custom
