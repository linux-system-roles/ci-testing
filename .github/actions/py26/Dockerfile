FROM registry.centos.org/centos:6
COPY entrypoint.sh /entrypoint.sh
RUN set -euo pipefail; \
    for file in /etc/yum.repos.d/CentOS-*.repo; do \
      if ! grep '^baseurl=.*vault[.]centos[.]org' "$file"; then \
        sed -i -e 's,^mirrorlist,#mirrorlist,' \
               -e 's,^#baseurl=,baseurl=,' \
               -e 's,mirror.centos.org/centos/$releasever,vault.centos.org/6.10,' \
               "$file"; \
      fi; \
    done
ENTRYPOINT ["/entrypoint.sh"]
