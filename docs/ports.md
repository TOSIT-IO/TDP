

# Ports and protocols used by TDP

## System

- SSH
  Port: 22
  Protocol: SSH
  External access:
  - All nodes for administrators and deployment scripts
  - Edges nodes for user access to a working pre-configured environment

## HDFS

- NameNode

  - Metadata HTTPS service

    Port: 9871

    Protocol: HTTPS

    Property: `dfs.namenode.https-address`

    External access: yes

    The namenode secure HTTP server address and port. It provides access to the HDFS web UI.

  - Metadata RPC service

    Port: 9820

    Protocol: IPC

    Property: `fs.defaultFS`

    External access: yes

    Main RPC port used by client to communicate with HDFS using a binary protocol. The port is embedded in the URI, eg `hdfs://nn1.domain.com:9820/`.

- ZKFC

  - RPC access

    Port: 8019

    Protocol: IPC

    Property: `dfs.ha.zkfc.port`

    External access: no

    RPC port used by Zookeeper Failover Controller.

- DataNode

  - Secure data transfert

    Port: 1004 (privileged port) or ?50010? (SASL based IPC, non-privilege port)

    Protocol: IPC

    Property: `dfs.datanode.address`

    External access: no

    The datanode server address and port for data transfer.  The value depends on the usage of SASL to authenticate data transfer protocol instead of running the DataNode as root, learn more about [securing the DataNode](https://cwiki.apache.org/confluence/display/HADOOP/Secure+DataNode).

  - Metadata HTTPS service

    Port: 9865

    Protocol: HTTPS

    Property: `dfs.datanode.https.address`

    External access: yes

    The datanode secure HTTP server address and port. It is used to access the status, logs, etc, and file data                                operations when using [WebHDFS](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/WebHDFS.html) or [HttpFS](https://hadoop.apache.org/docs/current/hadoop-hdfs-httpfs/index.html) (was [HFTP](https://hadoop.apache.org/docs/r1.2.1/hftp.html) in prior versions). The NameNode UI redirect the user to the DataNode server when browsing files.

  - Metadata RPC service

    Port: 9867

    Protocol: IPC

    Property: `dfs.datanode.ipc.address`

    External access: ?no?

    The DataNode RCP server address and port used for metadata information.

- JournalNode

  - RPC server

    Port: 8485

    Protocol: IPC

    Property: `dfs.journalnode.rpc-address`

    External access: no

    The JournalNode RPC server address and port.

  - HTTPS server

    Port: 8481

    Protocol: HTTPS

    Property: `dfs.journalnode.https-address`

    External access: no

    The address and port the JournalNode HTTPS server listens on. If the port is 0 then the server will start on a free port.  

## YARN

- ResourceManager

  - Ressource tracker

    Port: 8025

    Protocol: IPC

    Property: `yarn.resourcemanager.resource-tracker.address`

    External access: no

    This is used by the Node Manager to register/nodeHeartbeat/unregister with the ResourceManager.

  - RPC server

    Port: 8050

    Protocol: IPC

    Property: `yarn.resourcemanager.address.{id}`

    External access: yes

    The address of the applications manager interface in the RM. It is used to submit jobs.

  - HTTPS server

    Port: 8090

    Protocol: HTTPS

    Property: `yarn.resourcemanager.webapp.https.address`

    External access: yes

    The HTTPS adddress of the RM web UI application. It is used to monitor applications.

  - Admin RPC server

    Port: 8141

    Protocol: RPC

    Property: `yarn.resourcemanager.admin.address`

    External access: yes

    It is used by administrators and developers.

  - Scheduler

    Port: 8030

    Protocol: RPC

    Property: `yarn.resourcemanager.scheduler.address`

    External access: no

    It is used by administrators and developers.

- NodeManager

  - Container Manager

    Port: 45454

    Protocol: RPC

    Property: `yarn.nodemanager.address`

    External access: yes

    The address of the container manager in the NodeManager. Access is typically granted to admins, and Dev/Support teams.

  - Localizer

    Port: 8040

    Protocol: RPC

    Property: `yarn.nodemanager.localizer.address`

    External access: no

    Address where the localizer IPC is. It is responsible for downloading and copying remote resources on the local filesystem.

  - HTTPS server

    Port: 8044

    Protocol: HTTPS

    Property: `yarn.nodemanager.webapp.https.address`

    External access: yes

    WebUI server of the NodeManager for administrator and developers.

  - ApplicationMaster

    Port: large range

    Protocol: HTTP

    Property: 

    External access: no

    Ephemeral HTTPS port are open by each ApplicationMaster and cannot be restricted. The port are required to coordinates YARN tasks. They don't need to be accessible outside of the cluster. The YARN RessourceManager route the requests.

- App Timeline Server

  - RPC server

    Port: 10200

    Protocol: RPC

    Property: `yarn.timeline-service.address`

    External access: yes

    This address for the timeline server to start the RPC server. It addresses the storage and retrieval of application’s current and historic information in a generic fashion.

  - HTTPS server

    Port: 8190

    Protocol: RPC

    Property: `yarn.timeline-service.webapp.https.address`

    External access: yes

    The web UI of the timeline server.

## MapReduce Job History Server

- Job History RPC server

  Port: 10020

  Protocol: RPC

  Property: `mapreduce.jobhistory.address`

  External access: yes

  Server where client applications submit MapReduce jobs, `{FQDN}:{PORT}`.

- Job History WebUI

  Port: 19889

  Protocol: HTTPS

  Property: `mapreduce.jobhistory.webapp.https.address`

  External access: yes

  The MapReduce JobHistory Server Web UI, `{FQDN}:{PORT}`. It is used by administrators and developers.

- Shuffle Handler

  Port: 13562

  Protocol: RPC

  Property: `mapreduce.shuffle.port`

  External access: no

  Default port that the ShuffleHandler will run on. ShuffleHandler is a service run at the NodeManager to facilitate transfers of intermediate Map outputs to requesting Reducers.

- RPC admin server

  Port: 10033

  Protocol: RPC

  Property: `mapreduce.jobhistory.admin.address`

  External access: no

  The address of the History server admin interface.

## ZooKeeper

- Client connections

  Port: 2181

  Protocol: RPC

  Property: `zookeeper.port`

  External access: no

  Server dedicated to client connections.

- Leader server

  Port: 2888

  Protocol: RPC

  Property: `zookeeper.peer_port`

  External access: no

  Peers use the former port to connect to other peers, for example, to agree upon the order of updates. More specifically, a ZooKeeper server uses this port to connect followers to the leader.

- Client connections

  Port: 3888

  Protocol: RPC

  Property: `zookeeper.leader_port`

  External access: no

  Server connections used during the leader election phase.

## Hive

- [Hive Metastore](https://cwiki.apache.org/confluence/display/hive/design#Design-Metastore)

  Port: 9083

  Protocol: RPC

  Property: `hive.metastore.uris`

  External access: yes

  Store metadata information to expose data storage into a relational model.

- [Hive Server 2](https://cwiki.apache.org/confluence/display/hive/setting+up+hiveserver2)

  Port: 10001

  Protocol: RPC

  Property: `hive.server2.thrift.port`

  External access: yes

  The JDBC/ODBC interface to the Hive Metastore.

- [Web User Interface (UI)](https://cwiki.apache.org/confluence/display/hive/setting+up+hiveserver2#SettingUpHiveServer2-WebUIforHiveServer2)

  Port: 10002

  Protocol: HTTPS

  Property: `hive.server2.webui.port`

  External access: yes

  Port the the web UI to provides configuration, logging, metrics and active session information.

## Ranger

- Policy Manager

  Port: 6182

  Protocol: HTTPS

  Property: `ranger.service.https.port`

  External access: yes

  Port for Ranger secured admin web UI.

## Oozie

- Web UI

  Port: 11443

  Protocol: HTTPS

  Property: `OOZIE_HTTPS_PORT`

  External access: yes

  Port for the secured Oozie web UI.

- Admin

  Port: 11001

  Protocol: HTTPS

  Property: `OOZIE_ADMIN_PORT`

  External access: no

  The admin port Oozie server runs. It may be opened externally if job submissions are accepted from outside the cluster.

## Knox

- Gateway

  Port: 8443

  Protocol: HTTPS

  Property: `gateway.port`

  External access: yes

  The port of Knox main gateway to internal cluster services.

## Additionnal resources

- [CDH ports](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/cdh_ports.html)
- [HDFS default configuration](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)
- [YARN default configuration](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)
- [MapReduce default configuration](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)
