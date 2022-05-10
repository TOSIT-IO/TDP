# Trunk Data Platform

![](static/tdp_logo.png)

## Trunk Data Platform Release TDP-0.1.0 components version

| Component                   | Version | Apache Git branch                                                          | TDP Git Branch                                                                  | TDP commits                                                                           |
| --------------------------- | ------- | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Apache ZooKeeper            | 3.4.6   | release-3.4.6                                                              | XXX                                                                             | X.X.X                                                                                 |
| Apache Hadoop               | 3.1.1   | [rel/release-3.1.1](https://github.com/apache/hadoop/commits/branch-3.1.1) | [branch-3.1.1-TDP](https://github.com/TOSIT-IO/hadoop/commits/branch-3.1.1-TDP) | [compare](https://github.com/TOSIT-IO/hadoop/compare/branch-3.1.1...branch-3.1.1-TDP) |
| Apache Hive                 | 3.1.3   | [branch-3.1](https://github.com/apache/hive/commits/branch-3.1)            | [branch-3.1-TDP](https://github.com/TOSIT-IO/hive/commits/branch-3.1-TDP)       | [compare](https://github.com/TOSIT-IO/hive/compare/branch-3.1...branch-3.1-TDP)       |
| Apache Hive 1               | 1.2.3   | [branch-1.2](https://github.com/apache/hive/commits/branch-1.2)            | [branch-1.2-TDP](https://github.com/TOSIT-IO/hive/commits/branch-1.2-TDP)       | [compare](https://github.com/TOSIT-IO/hive/compare/branch-1.2...branch-1.2-TDP)       |
| Apache Tez                  | 0.9.1   | [branch-0.9.1](https://github.com/apache/tez/commits/branch-0.9.1)         | [branch-0.9.1-TDP](https://github.com/TOSIT-IO/tez/commits/branch-0.9.1-TDP)    | [compare](https://github.com/TOSIT-IO/tez/compare/branch-0.9.1...branch-0.9.1-TDP)    |
| Apache Spark                | 2.3.5   | [branch-2.3](https://github.com/apache/spark/commits/branch-2.3)           | [branch-2.3-TDP](https://github.com/TOSIT-IO/spark/commits/branch-2.3-TDP)      | [compare](https://github.com/TOSIT-IO/spark/compare/branch-2.3...branch-2.3-TDP)      |
| Apache Spark 3              | 3.2.2   | [branch-3.2](https://github.com/apache/spark/commits/branch-3.2)           | [branch-3.2-TDP](https://github.com/TOSIT-IO/spark/commits/branch-3.2-TDP)      | [compare](https://github.com/TOSIT-IO/spark/compare/branch-3.2...branch-3.2-TDP)      |
| Apache Ranger               | 2.0.1   | [ranger-2.0](https://github.com/TOSIT-IO/ranger/tree/ranger-2.0)           | [ranger-2.0-TDP](https://github.com/TOSIT-IO/ranger/tree/ranger-2.0-TDP)        | [compare](https://github.com/TOSIT-IO/ranger/compare/ranger-2.0...ranger-2.0-TDP)     |
| Apache HBase                | 2.1.10  | [branch-2.1](https://github.com/TOSIT-IO/hbase/commits/branch-2.1)         | [branch-2.1-TDP](https://github.com/TOSIT-IO/hbase/commits/branch-2.1-TDP)      | [compare](https://github.com/TOSIT-IO/hbase/compare/branch-2.1...branch-2.1-TDP)      |
| Apache Phoenix              | 5.1.3   | [5.1](https://github.com/TOSIT-IO/phoenix/commits/5.1)                     | [5.1-TDP](https://github.com/TOSIT-IO/phoenix/commits/5.1-TDP)                  | [compare](https://github.com/TOSIT-IO/phoenix/compare/5.1...5.1-TDP)                  |
| Apache Phoenix Query Server | 6.0.0   | [6.0.0](https://github.com/TOSIT-IO/phoenix-queryserver/commits/6.0.0)     | [6.0.0-TDP](https://github.com/TOSIT-IO/phoenix-queryserver/commits/6.0.0-TDP)  | [compare](https://github.com/TOSIT-IO/phoenix-queryserver/compare/6.0.0...6.0.0-TDP)  |
| Apache Knox                 | 1.6.1   | [v1.6.1](https://github.com/TOSIT-IO/knox/commits/v1.6.1)                  | [v1.6.1-TDP](https://github.com/TOSIT-IO/knox/commits/v1.6.1-TDP)               | [compare](https://github.com/TOSIT-IO/knox/compare/v1.6.1...v1.6.1-TDP)               |

Versions are approximately based on the [HDP 3.1.5 release](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.5/release-notes/content/hdp_relnotes.html).

**Note**: For some projects, the Apache foundation maintains sometimes a branch with this the components on which are backported fixes and features. We will be using these branches as much as possible if they are maintained and compatible.

## TDP Components release

Every TDP initial release is built from a reference branch on the Apache Git repository according to the above table. The main change from the original branches is the version declaration in the pom.xml files.

## Building / Testing environment

The builds / unit testing of the Maven Java projects of each component above can be run in Kubernetes pods which are scheduled by a Jenkins installation also running on Kubernetes.
Kubernetes pods scheduling allows for **truly** reproducible and isolated builds. Jenkins' strong integration with the Java ecosystem is a perfect match to build the components of the distribution.

### Kubernetes

Kubernetes was installed on Ubuntu 20.04 Virtual Machines with [kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).

**Note:** It is strongly recommended to deploy a Storage Class in order to have persistence on the Kubernetes cluster (useful for Jenkins among others). In our case, we are using [Rook](https://rook.io/) on physical drives attached to the Kubernetes cluster's VMs.

### Jenkins

Jenkins is used to trigger the builds which is the same process for every component of the stack:

- Git clone the sources
- Build the project
- Run the unit tests
- Publish the artifacts to a remote repository

Jenkins was installed on the Kubernetes cluster with the official [jenkinsci Helm chart](https://github.com/jenkinsci/helm-charts).

### Nexus / Docker registry

The building environment needs multiple registries:

- Maven to host the compiled Jars
- Docker to host the images that we use to build the projects
- File registry to host the .tar.gz files with the binaries and jars for every compiled projects.

Nexus Repository OSS can assume all three roles, is free and open source.

Nexus OSS was install on the Kubernetes cluster with the [helm chart](https://github.com/Oteemo/charts/tree/master/charts/sonatype-nexus) provided by [Oteemo](https://github.com/Oteemo).

## Local build environment

It is possible to run a local environment for building / small scale testing.

Prerequisite:

- Docker installed and available to your local user

You can start a local building environment with the `bin/start-build-env.sh` script.

**Note:** See `build-env/README.md` for details.

To build TDP component binaries, attach to the running `tdp-builder-<user>` container and `git clone` the TDP component repository to it. Each TDP component's `tdp/README.md` has custom instructions to launch the build process.
Assign a directory path to the `TDP_HOME` variable in the `bin/start-build-env.sh` to control the local path of built TDP binaries.
