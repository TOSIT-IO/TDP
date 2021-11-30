# TDP Deployment Requirements

## Hardware

The following hardware requirements are given as a reference to reach optimal performance for production-grade Hadoop clusters.

Of course, testing and QA environments can have lower configurations.

### Minimal requirements per node type

Bare metal cluster (eg: prod):

| Role   | Qtt | RAM  | CPUs       | Disks                             | NICs      |
| ------ | --- | ---- | ---------------------------------------------- | --------- |
| Worker |  5  | 64GB | 16 threads | 2x 500GB RAID 1 (OS+logs)         | 2x10 Gbps |
|        |     |      |            | 6x 2TB JBOD (HDFS)                |           |
| Master |  3  | 64GB | 16 threads | 2x 500GB RAID 1 (OS+logs)         | 2x10 Gbps |
|        |     |      |            | 2x 2TB RAID 1 (HDFS)              |           |
|        |     |      |            | 2x 2TB RAID 1 (RDBMS)             |           |
|        |     |      |            | 2x 2TB RAID 1 (ZooKeeper)         |           |
| Edge   |  2  | 16GB | 4 threads  | 2x 1TB RAID 1 (OS+logs+user data) | 2x10 Gbps |

Note, by thread we mean logical threads and not physical cores.

Virtualized cluster (eg: dev, testing):

| Role   | Qtt | RAM | CPUs       | Disks                             |
| ------ | --- | --- | ---------- | --------------------------------- |
| Worker |  2  | 4GB | 2 threads  | 1x 500GB RAID 1 (OS+logs)         |
|        |     |     |            | 6x 2TB JBOD (HDFS)                |
| Master |  3  | 6GB | 1 threads  | 2x 500GB RAID 1 (OS+logs)         |
|        |     |     |            | 2x 2TB RAID 1 (HDFS)              |
|        |     |     |            | 2x 2TB RAID 1 (RDBMS)             |
|        |     |     |            | 2x 2TB RAID 1 (ZooKeeper)         |
| Edge   |  1  | 4GB | 1 threads  | 2x 1TB RAID 1 (OS+logs+user data) |

### Minimal switches requirements

## Network

### DNS

Cluster nodes must be able to resolve all the other cluster nodes using forward and reverse DNS; and to connect to all other cluster nodes.

### Cluster isolation and access configuration

It is important to isolate the Hadoop cluster so that external network traffic does not affect the performance of the cluster. In addition, isolation allows the Hadoop cluster to be managed independently from its users, ensuring that the cluster administrator is the only person able to make changes to the cluster configuration.

It is recommended deploying ResourceManager, NameNode, and Worker nodes on their own private Hadoop cluster subnet.

Refers to the Big Data reference architecture of your constructor and stricly respect its recommandation.

#### Single-racks configuration

Two ToR switches are specified in each rack for high performance and redundancy. Each provides fast uplinks, for example 40GbE, that can be used to connect to the desired network or, in a multi-rack configuration, to another pair of ToR switches that are used for aggregation.

The other ports connect every nodes present inside the rack, commonly with a 10GbE. Each node configures network bonding with two 10 GbE server ports, for up to a max 20 GbE throughput.

#### Multi-racks configuration

The architecture for the multi-rack solution borrows from the single-rack design.

### Internet Access

The machine used for TDP compilation needs full internet access to build the Docker image and download Maven dependencies.

## System

### OS

TDP has been tested for the following Operating Systems:

- RHEL 7
- CentOS 7

### Swap

Turn off disk swappiness or to min=5, for example:

```bash
# Disable VM swappiness
echo '0' > /proc/sys/vm/swappiness
```

#### Limits

The `nproc` limit (max number of opened files) has to be set to `65536` or `262144`.

### File System

Supported file systems:

- ext3
- ext4
- XFS

### Partitioning

All cluster nodes must have:

- 1 root partition (`/`) for OS and software

For worker nodes, each Hadoop dedicated disk should be mounted on a `/grid/[0-N]` partition without using LVM.

### Protocols and Firewalls

Internal connections:

The following network components have to be disabled inside of the cluster:

- IPv6 disabled
- IPTables disabled
- SELinux disabled

External connection:

- ZooKeeper:

- HDFS
  The HDFS client must be able to reach every Hadoop DataNode in the cluster in order to stream blocks of data to the filesystem.

- YARN

- HBase

- Hive

- Knox

- Oozie

- Ranger

- Spark

### Hadoop Users and Groups

TDP will create Hadoop users and groups if they do not exist without any control on the UID/GID.

| User        | Groups                |
| ----------- | --------------------- |
| `hdfs`      | `hdfs`, `hadoop`      |
| `yarn`      | `yarn`, `hadoop`      |
| `mapred`    | `mapred`, `hadoop`    |
| `hbase`     | `hbase`, `hadoop`     |
| `hive`      | `hive`, `hadoop`      |
| `knox`      | `knox`, `hadoop`      |
| `oozie`     | `oozie`, `hadoop`     |
| `ranger`    | `ranger`, `hadoop`    |
| `spark`     | `spark`, `hadoop`     |
| `zookeeper` | `zookeeper`, `hadoop` |

It is recommanded to create the users prior to installation in order to control the UID/GID used and prevent any potential collision with the existing AD/LDAP directory.

## Software

### TDP Compilation Host

The compilation of TDP is done using a Docker image. The machine used for compilation requires:

- `docker-ce`
- `docker-ce-cli`
- `containerd.io`

See [Install Docker Engine on RHEL](https://docs.docker.com/engine/install/rhel/#install-using-the-repository).

### Cluster hosts

Packages that have to be installed on all cluster hosts:

- `yum`
- `rpm`
- `scp`
- `curl`
- `unzip`
- `tar`
- `wget`
- `gcc`
- `ntp` or `chrony` enabled
- OpenSSL (v1.01, build 16 or later)
- `krb5-workstation`
- `java-1.8.0-openjdk`
- `rngd`
- `ssh`
- Python 2.7+/3.4+

Extra packages for the Ansible host:

- `ansible>=2.9`

### Databases

For Hive, Oozie and Ranger, the following databases are supported:

| Database   | Supported versions |
| ---------- | ------------------ |
| OracleDB   | 19, 12             |
| PostgreSQL | 11, 10             |
| MySQL      | 5.7                |
| MariaDB    | 10.2               |

## Security

### Kerberos

- TDP currently requires the presence of a KDC and that appropriately configured kerberos-clients are available on each node in the cluster
- A Kerberos admin principal should exist before any deployment (the admin credentials and realm will be used to automate service principal creation)
- A `krb5.conf` file with this KDC's information should be available on the ansible host at `files/krb5.conf`

### Certificate Authority

- The files directory on the ansible host project root must contain CA public certificate at `files/root.pem`, and `files/<fqdn>.pem` `files/<fqdn>.key` key and signed certificate for each node in the cluster.

## Additionnal information

* [HP Reference Architecture for Hortonworks Data Platform 2.1](https://www.suse.com/partners/alliance/hpe/hp-reference-architecture.pdf)   
  See appendix B: Hadoop cluster tuning/optimization
