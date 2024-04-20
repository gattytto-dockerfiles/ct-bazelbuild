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
ENV U_HOME=bazel
ENV BUILDERS_VERSION=v7.1.1
ENV BAZEL_VERSION=7.1.1
RUN usermod -u 1000 -l ${U_HOME} build -d /storage/${U_HOME} -s /bin/bash && \
    chgrp -R 0 /run && chmod -R g+rwX /run && \
    curl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    curl -o- -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xvz -C /usr/local/bin --strip 1 && \
    dnf install -y wget gcc-c++ python3 python3-devel.x86_64 awscli awscli gcc file which unzip findutils nodejs git patch dnf-plugins-core java-11-openjdk.x86_64 && \
    cd /tmp && wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64 && mv bazel-${BAZEL_VERSION}-linux-x86_64 /bin/bazel && chmod +x /bin/bazel && \
    cd /tmp && wget https://github.com/bazelbuild/buildtools/releases/download/${BUILDERS_VERSION}/buildifier-linux-amd64 && chmod 777 buildifier-linux-amd64 && mv buildifier-linux-amd64 /usr/bin/buildifier && \
    cd /tmp && wget https://github.com/bazelbuild/buildtools/releases/download/${BUILDERS_VERSION}/buildozer-linux-amd64 && chmod 777 buildozer-linux-amd64 && mv buildozer-linux-amd64 /usr/bin/buildozer
USER 1000:1000
