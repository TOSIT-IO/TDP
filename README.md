# Trunk Data Platform

![](static/tdp_logo.png)

Trunk Data Platform is an Open Source, free, Hadoop distribution.

This distribution is built by EDF (French electricity provider) & DGFIP (Tax Office by the French Ministry of Finance), through an association called TOSIT (The Open source I Trust).

TDP is built from Apache projects source code.

## TDP repositories

The TDP project is composed of multiple repositories:
- [tdp-collection](https://github.com/TOSIT-IO/tdp-collection): main Ansible collection to deploy TDP core components.
- [tdp-collection-extras](https://github.com/TOSIT-IO/tdp-collection-extras): Ansible collection to deploy extra components that are not part of TDP core.
- [tdp-collection-prerequisites](https://github.com/TOSIT-IO/tdp-collection-prerequisites): Ansible collection to deploy prerequisite components to a TDP installation (i.e.: KDC, PostgreSQL, etc.).
- [tdp-lib](https://github.com/TOSIT-IO/tdp-lib): Python library to configure, manage and deploy TDP.
- [tdp-server](https://github.com/TOSIT-IO/tdp-server): REST API for tdp-lib orchestration.
- [tdp-ui](https://github.com/TOSIT-IO/tdp-ui): Web UI for TDP clusters deployment and configuration, uses tdp-server.
- [tdp-getting-started](https://github.com/TOSIT-IO/tdp-getting-started): A ready to deploy TDP virtual environment based of Vagrant showcasing how to use every component of TDP.

Each component of TDP also has its own repository.

## Trunk Data Platform Release TDP-1.0 components version

### TDP Core

The following table shows the core components of TDP as well as the Apache branch they were based on and the TDP branch which serves as base for our releases.

| Component                   | Version    | Apache Git release                                                             | TDP Git Branch                                                                  | TDP commits                                                                           |
| --------------------------- | ---------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Apache ZooKeeper            | 3.4.14-0.0      | [rel/release-3.4.14](https://github.com/apache/zookeeper/commits/release-3.4.14)| [branch-3.4.14-TDP](https://github.com/alliage-io/zookeeper/commits/branch-3.4.14-TDP) (release needs to be created) | [compare](https://github.com/TOSIT-IO/hadoop/compare/branch-3.1.4...branch-3.1.4-TDP)
| Apache Hadoop               | 3.1.4-1.0  | [rel/release-3.1.4](https://github.com/apache/hadoop/commits/rel/release-3.1.4)    | [branch-3.1.4-TDP](https://github.com/TOSIT-IO/hadoop/commits/branch-3.1.4-TDP)  (release needs to be created) | [compare](https://github.com/TOSIT-IO/zookeeper/compare/branch-3.4.14...branch-3.4.14-TDP)|
| Apache Hive                 | 3.1.3-2.0  | [rel/release-3.1.3](https://github.com/apache/hive/commits/rel/release-3.1.3)               | [branch-3.1.3-TDP](https://github.com/TOSIT-IO/hive/commits/branch-3.1.3-TDP)   | [compare](https://github.com/TOSIT-IO/hive/compare/branch-3.1...branch-3.1.3-TDP)       |
| Apache Hive 2 (for Spark 3) | 2.3.9-2.0  | [rel/release-2.3.9](https://github.com/apache/hive/commits/rel/release-2.3.9)               | [branch-2.3.9-TDP](https://github.com/TOSIT-IO/hive/commits/branch-2.3.9-TDP)       | [compare](https://github.com/TOSIT-IO/hive/compare/branch-2.3...branch-2.3.9-TDP)       |
| Apache Hive 1 (for Spark 2) | 1.2.3-1.0  | [Last commit of branch-1.2](https://github.com/apache/hive/commits/6002c510113d9a6aa87159c7386f2a8a4747405b)               | [branch-1.2-TDP](https://github.com/TOSIT-IO/hive/commits/branch-1.2.3-TDP)       | [compare](https://github.com/TOSIT-IO/hive/compare/branch-1.2...branch-1.2.3-TDP)       |
| Apache Tez                  | 0.9.1-2.0  | [branch-0.9.1](https://github.com/apache/tez/commits/rel/release-0.9.1)            | [branch-0.9.1-TDP](https://github.com/TOSIT-IO/tez/commits/branch-0.9.1-TDP)    | [compare](https://github.com/TOSIT-IO/tez/compare/branch-0.9.1...branch-0.9.1-TDP)    |
| Apache Spark                | 2.3.5-1.0  | [Last commit of branch-2.3](https://github.com/apache/spark/commits/75cc3b2da9ee0b51ecf0f13169f2b634e36a60c4)              | [branch-2.3-TDP](https://github.com/TOSIT-IO/spark/commits/branch-2.3.5-TDP)      | [compare](https://github.com/TOSIT-IO/spark/compare/branch-2.3...branch-2.3.5-TDP)      |
| (WIP: NOT REBASED) Apache Spark 3              | 3.2.4-1.0  | [v3.2.4](https://github.com/apache/spark/commits/v3.2.4)              | [branch-3.2-TDP](https://github.com/TOSIT-IO/spark/commits/branch-3.2-TDP)      | [compare](https://github.com/TOSIT-IO/spark/compare/branch-3.2...branch-3.2-TDP)      |
| Apache Ranger               | 2.0.0-2.0  | [Last commit of branch ranger-2.0](https://github.com/apache/ranger/commits/8d617c626b949cdadf8d914259f78d050556cc5d)             | [ranger-2.0-TDP](https://github.com/TOSIT-IO/ranger/commits/ranger-2.0-TDP)     | [compare](https://github.com/TOSIT-IO/ranger/compare/ranger-2.0...ranger-2.0-TDP)     |
| Apache Solr (for Ranger)    | 7.7.3      | 7                                                    | XXX                                                                             | X.X.X                                                                                 |
| Apache HBase                | 2.1.10-1.0 | [Last commit of branch-2.1](https://github.com/apache/hbase/commits/9f7e856a5f84a6f52d0197a03b7a56e1a3f0446c)              | [branch-2.1-TDP](https://github.com/TOSIT-IO/hbase/commits/branch-2.1-TDP)      | [compare](https://github.com/TOSIT-IO/hbase/compare/branch-2.1...branch-2.1-TDP)      |
| Apache Phoenix              | 5.1.3-1.0  | [5.1.3](https://github.com/apache/phoenix/commits/5.1.3)                          | [5.1.3-TDP](https://github.com/TOSIT-IO/phoenix/commits/5.1.3-TDP)              | [compare](https://github.com/TOSIT-IO/phoenix/compare/5.1...5.1.3-TDP)                |
| Apache Phoenix Query Server | 6.0.0-0.0  | [6.0.0](https://github.com/apache/phoenix-queryserver/commits/6.0.0)          | [6.0.0-TDP](https://github.com/TOSIT-IO/phoenix-queryserver/commits/6.0.0-TDP)  | [compare](https://github.com/TOSIT-IO/phoenix-queryserver/compare/6.0.0...6.0.0-TDP)  |
| Apache Knox                 | 1.6.1-0.0  | [v1.6.1](https://github.com/apache/knox/commits/v1.6.1-release)                       | [v1.6.1-TDP](https://github.com/TOSIT-IO/knox/commits/v1.6.1-TDP)               | [compare](https://github.com/TOSIT-IO/knox/compare/v1.6.1...v1.6.1-TDP)               |
| Apache HBase Connectors     | 1.0.0-0.0  | [rel/1.0.0](https://github.com/apache/hbase-connectors/commits/rel/1.0.0)     | [branch-2.3.4-1.0.0-TDP](https://github.com/TOSIT-IO/hbase-connectors/commits/branch-2.3.4-1.0.0-TDP) | [compare](https://github.com/TOSIT-IO/hbase-connectors/compare/1.0.0...branch-2.3.4-1.0.0-TDP)      |
| Apache HBase Operator tools | 1.1.0-0.0  | [rel/1.1.0](https://github.com/apache/hbase-operator-tools/commits/rel/1.1.0) | [branch-1.1.0-TDP](https://github.com/TOSIT-IO/hbase-operator-tools/commits/branch-1.1.0-TDP)         | [compare](https://github.com/TOSIT-IO/hbase-operator-tools/compare/branch-1.1.0...branch-1.1.0-TDP) |

Versions are approximately based on the [HDP 3.1.5 release](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.5/release-notes/content/hdp_relnotes.html).

**Note**: For some projects, the Apache foundation maintains sometimes a branch with this the components on which are backported fixes and features. We will be using these branches as much as possible if they are maintained and compatible.

### TDP Extras

"TDP Extras" carries some projects that cannot be integrated to "TDP Core". There can be different reasons that keep the project outside of the core:

- The project is not judged as a key component of the Hadoop ecosystem. This is the case of Airflow.
- The project is not active enough. This is the case of Livy that has not been updated in 2 years.
- The project has some incompatibilities with other "TDP Core" projects' releases. This is the case of Kafka 2.X that relies on ZooKeeper 3.5.X (and cannot use the ZooKeeper 3.4.6 of "TDP Core").

| Component                          | Version | Apache Git branch                                                | TDP Git Branch                                                                       | TDP commits                                                                             |
| ---------------------------------- | ------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| Apache ZooKeeper 3.5.9 (for Kafka) | 3.5.9   | release-3.5.9                                                    | XXX                                                                                  | X.X.X                                                                                   |
| Apache Kafka                       | 2.8.2   | [2.8](https://github.com/TOSIT-IO/kafka/tree/2.8)                | [2.8-TDP](https://github.com/TOSIT-IO/kafka/tree/2.8-TDP)                            | [compare](https://github.com/TOSIT-IO/kafka/compare/2.8...2.8-TDP)                      |
| Apache Livy                        | 0.8.0   | [master](https://github.com/TOSIT-IO/incubator-livy/tree/master) | [branch-0.8.0-TDP](https://github.com/TOSIT-IO/incubator-livy/tree/branch-0.8.0-TDP) | [compare](https://github.com/TOSIT-IO/incubator-livy/compare/master...branch-0.8.0-TDP) |
| Apache Airflow                     | 2.2.2   | 2.2.2                                                            | XXX                                                                                  | X.X.X                                                                                   |

**Note:** A project can graduate from "TDP Extras" to "TDP Core" if enough people are supporting it and/or if it is made compatible with all the other projects of the stack.

## Tested operating system (OS)

Only bare metal and virtual machine deployment are tested. Container based OS may work but are not guaranteed.

- Centos 7
- Rocky 8

Redhat like OS may work but are not guaranteed.

## TDP Components release

Every TDP initial release is built from a reference branch on the Apache Git repository according to the above tables. The main change from the original branches is the version declaration in the pom.xml files.

## Building / Testing environment

The builds / unit testing of the Maven Java projects of each component above can be run in Kubernetes pods which are scheduled by a Jenkins installation also running on Kubernetes.
Kubernetes pods scheduling allows for **truly** reproducible and isolated builds. Jenkins' strong integration with the Java ecosystem is a perfect match to build the components of the distribution.

### Build order

- hadoop
- tez
- hive1
- spark
- hive2
- spark3
- hive
- hbase
- ranger
- phoenix
- phoenix-queryserver
- knox
- hbase-spark-connector
- hbase-operator-tools

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

To build TDP component binaries, attach to the running `tdp-builder` container and `git clone` the TDP component repository to it. Each TDP component's `tdp/README.md` has custom instructions to launch the build process.
Assign a directory path to the `TDP_HOME` variable in the `bin/start-build-env.sh` to control the local path of built TDP binaries.
