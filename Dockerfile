# Copyright (c) 2019 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation

FROM quay.io/buildah/stable:latest

ENV KUBECTL_VERSION v1.29.4
ENV HELM_VERSION v3.14.4
ENV HOME=/home/whatever
ENV BUILDERS_VERSION=v7.1.1
ENV BAZEL_VERSION=7.1.1
RUN mkdir -p ${HOME} && \
    # Change permissions to let any arbitrary user
    for f in "${HOME}" "/etc/passwd"; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done && \
    # buildah login requires writing to /run
    chgrp -R 0 /run && chmod -R g+rwX /run && \
    curl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    curl -o- -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xvz -C /usr/local/bin --strip 1 && \
    # 'which' utility is used by VS Code Kubernetes extension to find the binaries, e.g. 'kubectl'
    dnf install -y wget gcc-c++ python3 awscli awscli gcc file which unzip findutils nodejs git patch dnf-plugins-core java-11-openjdk.x86_64 
    #dnf install -y python310 python https://rpmfind.net/linux/fedora/linux/updates/31/Everything/x86_64/Packages/b/binutils-gold-2.32-31.fc31.x86_64.rpm
    #dnf copr enable -y vbatts/bazel && \
    #dnf install -y bazel2

RUN cd /tmp && wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64 && mv bazel-${BAZEL_VERSION}-linux-x86_64 /bin/bazel && chmod +x /bin/bazel

RUN cd /tmp && wget https://github.com/bazelbuild/buildtools/releases/download/${BUILDERS_VERSION}/buildifier-linux-amd64 && chmod 777 buildifier-linux-amd64 && mv buildifier-linux-amd64 /usr/bin/buildifier

RUN cd /tmp && wget https://github.com/bazelbuild/buildtools/releases/download/${BUILDERS_VERSION}/buildozer-linux-amd64 && chmod 777 buildozer-linux-amd64 && mv buildozer-linux-amd64 /usr/bin/buildozer
