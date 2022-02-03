# TDP Deployment Requirements

## Hardware

The following hardware requirements are given as a reference to reach optimal performance for production-grade Hadoop clusters.

Testing and QA environments share lower configuration requirements.

### Recommended requirements per node type

Bare metal cluster (eg: prod):

| Role   | Qtt | RAM  | CPUs       | Disks                             | NICs      |
| ------ | --- | ---- | ---------- | --------------------------------- | --------- |
| Worker | 5   | 64GB | 16 threads | 2x 500GB RAID 1 (OS+logs)         | 2x10 Gbps |
|        |     |      |            | 6x 2TB JBOD (HDFS)                |           |
| Master | 3   | 64GB | 16 threads | 2x 500GB RAID 1 (OS+logs)         | 2x10 Gbps |
|        |     |      |            | 2x 500GB SSD RAID 1 (HDFS)        |           |
|        |     |      |            | 2x 500GB SSD RAID 1 (RDBMS)       |           |
|        |     |      |            | 2x 500GB SSD RAID 1 (ZooKeeper)   |           |
| Edge   | 2   | 16GB | 4 threads  | 2x 1TB RAID 1 (OS+logs+user data) | 2x10 Gbps |

Note, by thread we mean logical threads and not physical cores.

Virtualized cluster (eg: dev, testing):

| Role   | Qtt | RAM | CPUs      | Disks |
| ------ | --- | --- | --------- | ----- |
| Worker | 2   | 4GB | 2 threads | 30GB  |
| Master | 3   | 6GB | 1 threads | 30GB  |
| Edge   | 1   | 4GB | 1 threads | 5GB   |

TDP compilation host:

| RAM | CPUs      | Disks |
| --- | --------- | ----- |
| 8GB | 4 threads | 50GB  |

### CPU

Depending on your workload, the optimal ration cost/performance is usually achieved on worker nodes with mid-range CPUs. For master nodes, mid-range CPUs with slighly higher performances are good candidates.

### Disks

Sata disks are a popular and cost effective choice offering large storage possibilities. For usecases requiring frequent IO disk access on smaller dataset, SSD is a reasonble alternative. [Heterogeneous storage](https://hadoop.apache.org/docs/r3.1.1/hadoop-project-dist/hadoop-hdfs/ArchivalStorage.html) in HDFS combine multiple types of disks to answer different workloads.

### Asymetric architecture

Asymetric architectures separate storage from compute. HDFS DataNodes are not collocated with YARN NodeManagers. Such architectures provides greater flexibility to scale in and out the hardware independently depending on the usage at the cost of preventing short-circuit optimisations.

Asymetric architecture are known to work but are not tested at the moment with TDP. Thus, they are not yet supported.

## Network

### Cluster isolation and access configuration

It is important to isolate the Hadoop cluster so that external network traffic does not affect the performance of the cluster. In addition, isolation allows the Hadoop cluster to be managed independently from its users, ensuring that the cluster administrator is the only person able to make changes to the cluster configuration.

It is recommended to deploy master and worker nodes inside their own private cluster subnet.

Refer to the Big Data reference architecture of your constructor and stricly respect its recommandations.

#### Single-racks configuration

It is recommanded to place two ToR switches in each rack for high performance and redundancy. Each provides fast uplinks, for example 40GbE, that can be used to connect to the desired network or, in a multi-rack configuration, to another pair of ToR switches that are used for aggregation.

The other ports connect every nodes present inside the rack, commonly with a 10GbE. Each node configures network bonding with two 10 GbE server ports, for up to a max 20 GbE throughput.

#### Multi-racks configuration

The architecture for the multi-rack solution borrows from the single-rack design and extends the existing infrastructure. Each rack is assembled with the same ToR switches connected to a pair of aggregation switches with a fast connection, for example 40GbE.

### DNS

Cluster nodes must be able to resolve all the other cluster nodes using forward and reverse DNS and to connect to all other cluster nodes.

```bash
FQDN='my.domain.com'
IP='10.10.10.10'
dig $FQDN +short | grep -x $IP
dig -x $IP +short | grep -x $FQDN
```

### DNS cache

Caching DNS name resolution and static resolution is beneficial. Be warned, RedHat [discourages the usage of NSCD and SSSD](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system-level_authentication_guide/usingnscd-sssd) conjointly: SSSD is not designed to be used with the NSCD daemon [...] using both services can their usage results in unexpected behavior.

### Internet Access

The machine used for TDP compilation needs full internet access to build the Docker image and download build dependencies (Maven, NPM, Ruby, etc.).

## External services

- KDC
  A Working Kerberos server is required. Popular solutions include ActiveDirectory, FreeIPA and MIT Kerberos server.
- LDAP
  A Working LDAP server is required. Popular solutions include ActiveDirectory, FreeIPA and OpenLDAP.
- RDBMS
  A Working relationnal database is required. Supported solutions include PostgreSQL, MariaDB and MySQL.
- SSL/TLS
  Public and private keys must be provided for each node of the cluster inside a local folder.

### Protocols and Firewalls

Internal connections:

The following network components have to be disabled inside of the cluster:

- IPv6 disabled
- IPTables disabled or configured properly for necessary ports of the TDP components (see [Ports and protocols used by TDP](./ports.md)).

## System

### OS

TDP has been tested using the following operating systems:

- RHEL 7
- CentOS 7

## SELinux

SELinux has not been tested in the context of TDP. While theorically possible, activating SELinux is a daunting tasks and will not be supported.

## Service daemons

- SSSD
- Time service
  A clock synchronization service is required to coordinate the system. NTP and chrony are popular services in the Linux eco-system.

### Swap

Turn off disk swappiness or to min=5, for example:

```bash
# Disable VM swappiness
echo '0' > /proc/sys/vm/swappiness
```

#### Limits

The `nproc` limit (max number of opened files) has to be set to `65536` or `262144`.

### Partitioning

All cluster nodes must have 1 root partition (`/`) for OS and software. It is recommanded to replicate the system partition, for example using RAID 1.

For worker nodes, each Hadoop dedicated disk should be mounted on a `/data/[0-N]` partitions. Do not use LVM or similar technologies.

### HDFS and YARN disks format

Worker nodes define their storage on multiple JBOD disks. Both HDFS DataNodes and YARN NodeManagers create and manage a directory on each disks. Their configuration impact the overall system performances.

Supported file systems:

- ext3 (not recommanded)
- ext4
- XFS

```
mkfs -t ext4 -m 1 -O -T largefile \
  sparse_super,dir_index,extent,has_journal \
  /dev/sdb1
```

Here is some help to interpret the command:

- `T largefile`: one inode per Mb
- `-m 1`: 1% of the blocks reserved for root.
- `sparse_super`: limit the number of superblocks
- `dir_index`: use b_tree index
- `extent`: extent based allocation
- `has_journal`: journaling activation

Read access is optimized by disabling the native Linux optimization to access records metadata. When mounting ext4 and XFS partitions, pass the `notime` flag in `/etc/fstab`:

```bash
/dev/sdb1 /data/1 ext4 defaults,noatime 0 0
```

Call `mount` to apply the changes:

```bash
mount -o remount /data/1
```

Mounting NFS and NAS partitions is not supported to store DataNode directories, even when using asymetric architectures separating storage from compute.

Note, activating the `noexec` flag on `/tmp` mounted partitions causes knows issues and is discouraged.

### Hadoop Users and Groups

TDP create Hadoop users and groups if they do not exist without any control on the UID/GID.

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

### TDP compilation node

The compilation of TDP is done using a Docker image. The machine used for compilation requires:

- `docker-ce`
- `docker-ce-cli`
- `containerd.io`

See [Install Docker Engine on RHEL](https://docs.docker.com/engine/install/rhel/#install-using-the-repository).

The compilation node will need access to the TDP GitHub repositories:

- TDP (Docker image): [https://github.com/TOSIT-FR/TDP](https://github.com/TOSIT-FR/TDP)
- Hadoop: [https://github.com/TOSIT-FR/hadoop](https://github.com/TOSIT-FR/hadoop)
- Hive: [https://github.com/TOSIT-FR/hive](https://github.com/TOSIT-FR/hive)
- Tez: [https://github.com/TOSIT-FR/tez](https://github.com/TOSIT-FR/tez)
- Spark: [https://github.com/TOSIT-FR/spark](https://github.com/TOSIT-FR/spark)
- Ranger: [https://github.com/TOSIT-FR/ranger](https://github.com/TOSIT-FR/ranger)
- Oozie: [https://github.com/TOSIT-FR/oozie](https://github.com/TOSIT-FR/oozie)
- HBase: [https://github.com/TOSIT-FR/hbase](https://github.com/TOSIT-FR/hbase)
- Phoenix: [https://github.com/TOSIT-FR/phoenix](https://github.com/TOSIT-FR/phoenix)
- Phoenix Query Server: [https://github.com/TOSIT-FR/phoenix-queryserver](https://github.com/TOSIT-FR/phoenix-queryserver)
- Knox: [https://github.com/TOSIT-FR/knox](https://github.com/TOSIT-FR/knox)

Access to the official Apache ZooKeeper repo is also needed to download release 3.4.6: [https://archive.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz](https://archive.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz)

### Cluster hosts

The following packages are expected to be installed on all cluster nodes:

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
- `rngd`
- `ssh`
- `python 2.7+/3.5+`

Extra packages for the Ansible host:

- `ansible >= 2.9`
- `python 2.7+/3.5+`

### Java versions

Oracle JDK 8 and OpenJDK 8 are supported. The YUM package `java-1.8.0-openjdk` is available on RHEL and CentOS system to install OpenJDK.

JDK 7 and lower are not supported. JDK versions 9 and above are not supported.

Some specific versions and version ranges are known to be incompatible with TDP.

The [Hadoop wiki](https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions) lists known versions compatible with the various Hadoop services:

- 1.8.0_242: The visibility of sun.nio.ch.SocketAdaptor is changed from public to package-private. TestIPC#testRTEDuringConnectionSetup is affected.
- 1.8.0_242: Kerberos Java client will fail by "Message stream modified (41)" when the client requests a renewable ticket and the KDC returns a non-renewable ticket. If your principal is not allowed to obtain a renewable ticket, you must remove "renew_lifetime" setting from your krb5.conf.
- 1.8.0_191: All DES cipher suites were disabled. If you are explicitly using DES cipher suites, you need to change cipher suite to a strong one.
- 1.8.0_171: In Apache Hadoop 2.7.0 to 2.7.6, 2.8.0 to 2.8.4, 2.9.0 to 2.9.1, 3.0.0 to 3.0.2, and 3.1.0, KMS fails by java.security.UnrecoverableKeyException due to Enhanced KeyStore Mechanisms. You need to set the system property "jceks.key.serialFilter" to the following value to avoid this error:  
  `java.lang.Enum;java.security.KeyRep;java.security.KeyRep$Type;javax.crypto.spec.SecretKeySpec;org.apache.hadoop.crypto.key.JavaKeyStoreProvider$KeyMetadata;!*"`

[Cloudera](https://docs.cloudera.com/documentation/enterprise/6/release-notes/topics/rg_java_requirements.html) list the following issues:

> - JDK 8u271, JDK 8u281, and JDK 8u291 may cause socket leak issues due to JDK-8245417 and JDK-8256818. Pay attention to the build version of your JDK because some later builds are fixed as described in [JDK-8256818](https://bugs.openjdk.java.net/browse/JDK-8256818).  
>   Workaround: Consider using a more recent version of the JDK like 8u282, or builds of the JDK where the issue is fixed.
> - JDK 8u40, 8u45, and 8u60 are not supported due to JDK issues impacting CDH functionality:
>   - JDK 8u40 and 8u45 are affected by JDK-8077155, which affects HTTP authentication for certain web UIs.
>   - JDK 8u60 is incompatible with the AWS SDK, and causes problem with DistCP. For more information, see the KB article.
> - [Oozie Workflow Graph Display](http://gethue.com/improved-oozie-workflow-graph-display-in-hue-4-3/) in Hue does not work properly with JDK versions lower than 8u40.
> - For JDK 8u241 and higher versions running on Kerberized clusters, you must disable referrals by setting sun.security.krb5.disableReferrals=true.

### Databases

For Hive, Oozie and Ranger, the following databases are supported:

| Database   | Supported versions |
| ---------- | ------------------ |
| OracleDB   | 19, 12             |
| PostgreSQL | 11, 10             |
| MySQL      | 5.7                |
| MariaDB    | 10.2               |

### Ansible node

The Ansible roles used to deploy TDP are available in the repository [https://github.com/TOSIT-FR/ansible-tdp-roles](https://github.com/TOSIT-FR/ansible-tdp-roles).

## Security

### Kerberos

- TDP currently requires the presence of a KDC and appropriately configured Kerberos clients on each node of the cluster.
- A Kerberos admin principal should exist before any deployment (the admin credentials and realm will be used to automate service principal creation).
- A `krb5.conf` file with this KDC's information should be available on the ansible host. The default location is `files/krb5.conf`.

### Certificate Authority

All external communication are encrypted using SSL/TLS. Deploying certificates is a TDP requirement.

Both signed and unsigned authorities are supported. TDP also supports the usage of intermediate certificates. Wildcard certificates are not supported.

The Ansible project used to deploy the cluster provides a `files` directory where certificates are expected to be found. It must contain the certificate authority (CA) under `files/root.pem` and, for each node, their public certificate under `files/${FQDN}.pem` and their respective private certificate under `files/${FQDN}.key`.

## Additionnal resources

- [HP Reference Architecture for Hortonworks Data Platform 2.1](https://www.suse.com/partners/alliance/hpe/hp-reference-architecture.pdf)  
  See appendix B: Hadoop cluster tuning/optimization
- [HP Verified Reference Architecture for Hortonworks HDP 2.4 on HP ProLiant DL380 DL380 Gen9 servers](https://d3kex6ty6anzzh.cloudfront.net/uploads/68/681b3b64ad8ec76dbbf77db6460aba0156167b90.pdf)
- [Ready Solutions for Data Analytics, Hortonworks Hadoop 3.0](https://www.delltechnologies.com/asset/ja-jp/solutions/business-solutions/industry-market/h17561-hortonworks-hadoop-v3-ra.pdf) from Dell
- [Cisco UCS Integrated Infrastructure for Big Data and Analytics with Hortonworks Data Platform 3.0](https://www.cisco.com/c/en/us/td/docs/unified_computing/ucs/UCS_CVDs/Cisco_UCS_Integrated_Infrastructure_for_Big_Data_with_Hortonworks_28node.html)
