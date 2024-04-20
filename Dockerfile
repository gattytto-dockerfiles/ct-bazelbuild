# Copyright (c) 2019 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation

FROM python3:3.10-bookworm

ENV KUBECTL_VERSION v1.29.4
ENV HELM_VERSION v3.14.4
ENV U_HOME=bazel
ENV BUILDERS_VERSION=v7.1.1
ENV BAZEL_VERSION=7.1.1
RUN groupadd -g 1000 build && useradd -u 1000 -g 1000 -l ${U_HOME} build -d /storage/${U_HOME} -s /bin/bash && \
    apt update && apt install -y wget g++ awscli file which unzip nodejs git default-jdk && \
    cd /tmp && wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64 && mv bazel-${BAZEL_VERSION}-linux-x86_64 /bin/bazel && chmod +x /bin/bazel && \
    cd /tmp && wget https://github.com/bazelbuild/buildtools/releases/download/${BUILDERS_VERSION}/buildifier-linux-amd64 && chmod 777 buildifier-linux-amd64 && mv buildifier-linux-amd64 /usr/bin/buildifier && \
    cd /tmp && wget https://github.com/bazelbuild/buildtools/releases/download/${BUILDERS_VERSION}/buildozer-linux-amd64 && chmod 777 buildozer-linux-amd64 && mv buildozer-linux-amd64 /usr/bin/buildozer
USER 1000:1000
