# Tosit Data Platform

## Tosit Data Platform Release TDP-0.1.0 components version

| Component          | Version       | Apache Git branch |  TDP Git Branch    |
| -------------------|---------------|-------------------|--------------------|
| Apache ZooKeeper   | 3.4.6         | release-3.4.6     |  XXX               |
| Apache Hadoop      | 3.1.1         | rel/release-3.1.1 |  branch-3.1.1-TDP  |
| Apache Hive        | 3.1.0         | branch-3.1        |  XXX               |
| Apache Tez         | 0.9.1         | branch-0.9.1      |  XXX               |
| Apache Oozie       | 4.3.1         | branch-4.3        |  XXX               |

## TDP Components release

Every TDP initial release is built from a reference branch on the Apache Git repository according to the above table. The only additional change from the original branches is the version declaration in the pom.xml files.

## Kubernetes based Building / Testing environment

The builds / unit testing of the Maven Java projects of each component above can be run in Kubernetes pods which are scheduled by a Jenkins installation also running on Kubernetes.
Kubernetes pods scheduling allows for **truly**  reproducible and isolated builds. Jenkins' strong integration with the Java ecosystem is a perfect match to build the components of the distribution.

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

It is possible to run a local environment for  building / small scale testing.

Prerequisite:
- Docker installed and available to your local user

You can start a local building environment with the `bin/start-build-env.sh` script.

**Note:** See `build-env/README.md` for details.
