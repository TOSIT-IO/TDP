

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

    The namenode secure HTTP server address and port. It provides access to the HDFS web UI.

    Port: 9871

    Protocol: HTTPS

    Property: `dfs.namenode.https-address`

    External access: yes

    [Source](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)
    
    Verified

  - Metadata RPC service

    Main RPC port used by client to communicate with HDFS using a binary protocol. The port is embedded in the URI, eg `hdfs://nn1.domain.com:9820/`.

    Port: 9820

    Protocol: IPC

    Property: `fs.defaultFS`

    External access: yes

    [Source](https://hadoop.apache.org/docs/r3.0.0/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithNFS.html)

    [Source](https://issues.apache.org/jira/browse/HDFS-9427)
    
    Verified

- ZKFC

  - RPC access

    RPC port used by Zookeeper Failover Controller.

    Port: 8019

    Protocol: IPC

    Property: `dfs.ha.zkfc.port`

    External access: no

    [Source](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-hdfs-project/hadoop-hdfs/src/main/java/org/apache/hadoop/hdfs/DFSConfigKeys.java)

    Verified

- DataNode

  - Secure data transfert

    The datanode server address and port for data transfer.  The value depends on the usage of SASL to authenticate data transfer protocol instead of running the DataNode as root, learn more about [securing the DataNode](https://cwiki.apache.org/confluence/display/HADOOP/Secure+DataNode).

    Port: 9866 (SASL based IPC, non-privileged port) 1004 (privileged port) 

    Protocol: IPC

    Property: `dfs.datanode.address`

    External access: no

    [Source privileged port](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SecureMode.html)

    [Source non-privilege port](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-common-project/hadoop-common/src/main/java/org/apache/hadoop/fs/FileContext.java)

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-hdfs-project/hadoop-hdfs/src/main/java/org/apache/hadoop/hdfs/DFSConfigKeys.java)

    [Source](https://issues.apache.org/jira/browse/HDFS-9427)

    Verified

  - Metadata HTTPS service

    The datanode secure HTTP server address and port. It is used to access the status, logs, etc, and file data                                operations when using [WebHDFS](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/WebHDFS.html) or [HttpFS](https://hadoop.apache.org/docs/current/hadoop-hdfs-httpfs/index.html) (was [HFTP](https://hadoop.apache.org/docs/r1.2.1/hftp.html) in prior versions). The NameNode UI redirect the user to the DataNode server when browsing files.

    Port: 9865

    Protocol: HTTPS

    Property: `dfs.datanode.https.address`

    External access: yes

    [Source](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-hdfs-project/hadoop-hdfs/src/main/java/org/apache/hadoop/hdfs/DFSConfigKeys.java)

    Verified

  - Metadata RPC service

    The DataNode RCP server address and port used for metadata information.

    Port: 9867

    Protocol: IPC

    Property: `dfs.datanode.ipc.address`

    External access: (requires Apache Knox) 

    [Source](https://hadoop.apache.org/docs/r3.0.0/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-hdfs-project/hadoop-hdfs/src/main/java/org/apache/hadoop/hdfs/DFSConfigKeys.jav)

    [Source](https://issues.apache.org/jira/browse/HDFS-9427)
    
    Verified
    
- JournalNode

  - RPC server

    The JournalNode RPC server address and port.

    Port: 8485

    Protocol: IPC

    Property: `dfs.journalnode.rpc-address`

    External access: no

    [Source](https://hadoop.apache.org/docs/r3.0.0/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)
    
    [Source](https://github.com/TOSIT-FR/ansible-tdp-roles/blob/cadf02e0a849b878b9510a29c30aa3144d9aa789/roles/hadoop/defaults/main.yaml)
    
    Verified

  - HTTPS server

    The address and port the JournalNode HTTPS server listens on. If the port is 0 then the server will start on a free port. 

    Port: 8481

    Protocol: HTTPS

    Property: `dfs.journalnode.https-address`

    External access: no

    [Source](https://hadoop.apache.org/docs/r3.0.0/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)

    [Source](hadoop-hdfs-project/hadoop-hdfs/src/main/java/org/apache/hadoop/hdfs/DFSConfigKeys.java)

    Verified

## YARN

- ResourceManager

  - Ressource tracker

    This is used by the Node Manager to register/nodeHeartbeat/unregister with the ResourceManager.

    Port: 8031

    Protocol: IPC

    Property: `yarn.resourcemanager.resource-tracker.address`

    External access: no

    [Source](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

    [Source](hadoop-yarn-project/hadoop-yarn/hadoop-yarn-api/src/main/java/org/apache/hadoop/yarn/conf/YarnConfiguration.java)
  
    Verified

  - RPC server

    The address of the applications manager interface in the RM. It is used to submit jobs. In YARN non HA configuration `yarn.resourcemanager.address` uses port 8050. In YARN HA configuration, `yarn.resourcemanager.address` is redundant and instead `yarn.resourcemanager.address.{id}` is resolved and uses port 8032.

    Port: 8032

    Protocol: IPC

    Property: `yarn.resourcemanager.address.{id}`

    External access: yes

    [Source default port](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)
    [Source YARN HA port](https://community.cloudera.com/t5/Support-Questions/What-is-the-default-Yarn-resource-manager-port-Is-it-8032-or/td-p/138143)

    [Source](hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-resourcemanager/src/test/java/org/apache/hadoop/yarn/server/resourcemanager/TestRMHA.java)

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-api/src/main/java/org/apache/hadoop/yarn/conf/YarnConfiguration.java)

    Verified

  - HTTPS server

    The HTTPS adddress of the RM web UI application. It is used to monitor applications.

    Port: 8090

    Protocol: HTTPS

    Property: `yarn.resourcemanager.webapp.https.address`

    External access: yes

    [Source](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

    [Source](https://github.com/TOSIT-FR/ansible-tdp-roles/blob/cadf02e0a849b878b9510a29c30aa3144d9aa789/roles/hadoop/defaults/main.yaml)

    Verified

  - Admin RPC server

    It is used by administrators and developers.

    Port: 8033

    Protocol: RPC

    Property: `yarn.resourcemanager.admin.address`

    External access: yes

    [Source](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xmlhttps://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-common/src/main/resources/yarn-default.xml)

    Verified

  - Scheduler

    It is used by administrators and developers.

    Port: 8030

    Protocol: RPC

    Property: `yarn.resourcemanager.scheduler.address`

    External access: no

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-common/src/main/resources/yarn-default.xml)

    Verified

- NodeManager

  - Container Manager

    The address of the container manager in the NodeManager. Access is typically granted to admins, and Dev/Support teams.

    Port: 0 (default for dynamic port allocation) or 45454 (static port by convention)

    Protocol: RPC

    Property: `yarn.nodemanager.address`

    External access: yes

    [Source](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

    [Source](https://github.com/TOSIT-FR/ansible-tdp-roles/blob/cadf02e0a849b878b9510a29c30aa3144d9aa789/roles/hadoop/defaults/main.yaml)

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-common/src/main/resources/yarn-default.xml)

    Verified

  - Localizer

    Address where the localizer IPC is. It is responsible for downloading and copying remote resources on the local filesystem.

    Port: 8040

    Protocol: RPC

    Property: `yarn.nodemanager.localizer.address`

    External access: no

    [Source](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

    Verified

  - HTTPS server

    WebUI server of the NodeManager for administrator and developers.

    Port: 8044

    Protocol: HTTPS

    Property: `yarn.nodemanager.webapp.https.address`

    External access: yes

    [Source](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

    [Source](https://github.com/TOSIT-FR/ansible-tdp-roles/blob/cadf02e0a849b878b9510a29c30aa3144d9aa789/roles/hadoop/defaults/main.yaml)

    Verified

  - ApplicationMaster

    Ephemeral HTTPS port are open by each ApplicationMaster and cannot be restricted. The port are required to coordinates YARN tasks. They don't need to be accessible outside of the cluster. The YARN RessourceManager route the requests.

    Port: large range

    Protocol: HTTP

    Property: 

    External access: no

- App Timeline Server

  - RPC server

    This address for the timeline server to start the RPC server. It addresses the storage and retrieval of application’s current and historic information in a generic fashion.

    Port: 10200

    Protocol: RPC

    Property: `yarn.timeline-service.address`

    External access: yes

    [Source](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

  - HTTPS server

    The web UI of the timeline server.

    Port: 8190

    Protocol: RPC

    Property: `yarn.timeline-service.webapp.https.address`

    External access: yes

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-common/src/main/resources/yarn-default.xml)

    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-api/src/main/java/org/apache/hadoop/yarn/conf/YarnConfiguration.java)
    
    [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-applicationhistoryservice/src/test/java/org/apache/hadoop/yarn/server/timeline/security/TestTimelineAuthenticationFilterForV1.java)

    Verified
## MapReduce Job History Server

- Job History RPC server

  Server where client applications submit MapReduce jobs, `{FQDN}:{PORT}`.

  Port: 10020

  Protocol: RPC

  Property: `mapreduce.jobhistory.address`

  External access: yes

  [Source](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)

  [Source](https://github.com/TOSIT-FR/ansible-tdp-roles/blob/cadf02e0a849b878b9510a29c30aa3144d9aa789/roles/hadoop/defaults/main.yaml)

  [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-core/src/main/resources/mapred-default.xml)

  Verified

- Job History WebUI

  The MapReduce JobHistory Server Web UI, `{FQDN}:{PORT}`. It is used by administrators and developers.

  Port: 19890

  Protocol: HTTPS

  Property: `mapreduce.jobhistory.webapp.https.address`

  External access: yes

  [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-core/src/main/resources/mapred-default.xml)

  [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-common/src/main/java/org/apache/hadoop/mapreduce/v2/jobhistory/JHAdminConfig.java)

  Verified

- Shuffle Handler

  Default port that the ShuffleHandler will run on. ShuffleHandler is a service run at the NodeManager to facilitate transfers of intermediate Map outputs to requesting Reducers.

  Port: 13562

  Protocol: RPC

  Property: `mapreduce.shuffle.port`

  External access: no

  [Source](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xmlhttps://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-shuffle/src/main/java/org/apache/hadoop/mapred/ShuffleHandler.java)

  [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-shuffle/src/main/java/org/apache/hadoop/mapred/ShuffleHandler.java)

  Verified

- RPC admin server

  The address of the History server admin interface.

  Port: 10033

  Protocol: RPC

  Property: `mapreduce.jobhistory.admin.address`

  External access: no

  [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-core/src/main/resources/mapred-default.xmlhttps://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)

  Verified

## ZooKeeper

- Client connections

  Server dedicated to client connections.

  Port: 2181 (default by convention)

  Protocol: RPC

  Property: `zookeeper.port` (`clientPort` in `zoo.cnf` files)

  External access: no

  [Source](https://zookeeper.apache.org/doc/r3.4.9/zookeeperAdmin.html#sc_configurationhttps://zookeeper.apache.org/doc/r3.4.6/zookeeperAdmin.html#sc_configuration)

  [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-common-project/hadoop-common/src/main/resources/core-default.xml)

  [Source](https://github.com/TOSIT-FR/ansible-tdp-roles/blob/0f62840bd064c7334aa7f89f21e3695ca6952b50/roles/zookeeper/templates/zoo.cfg.j2)

  [Source](https://github.com/TOSIT-FR/hadoop/blob/5b1fa3e1aabb6bd350bf5dbd4f4e49578d94738f/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-applications/hadoop-yarn-services/hadoop-yarn-services-core/src/main/java/org/apache/hadoop/yarn/service/utils/ZookeeperUtils.java)

  Verified

- Leader server

  Peers use the former port to connect to other peers, for example, to agree upon the order of updates. More specifically, a ZooKeeper server uses this port to connect followers to the leader.

  Port: 2888 (default by convention)

  Protocol: RPC

  Property: `zookeeper.peer_port`

  External access: no

  [Source](https://zookeeper.apache.org/doc/r3.4.9/zookeeperAdmin.html#sc_configurationhttps://zookeeper.apache.org/doc/r3.4.6/zookeeperAdmin.html#sc_configuration)

  [Source](https://github.com/TOSIT-FR/ansible-tdp-roles/blob/2d2d97e2e45f89861fcf0dbdd74d5a603df6062c/roles/zookeeper/defaults/main.yml)

  Verified

- Leader election connections

  Server connections used during the leader election phase.

  Port: 3888  (default by convention)

  Protocol: RPC

  Property: `zookeeper.leader_port`

  External access: no

  [Source](https://zookeeper.apache.org/doc/r3.4.9/zookeeperAdmin.html#sc_configurationhttps://zookeeper.apache.org/doc/r3.4.6/zookeeperAdmin.html#sc_configuration)

  [Source](https://github.com/TOSIT-FR/ansible-tdp-roles/blob/2d2d97e2e45f89861fcf0dbdd74d5a603df6062c/roles/zookeeper/defaults/main.yml)

  Verified

## Hive

- [Hive Metastore](https://cwiki.apache.org/confluence/display/hive/design#Design-Metastore)

  Store metadata information to expose data storage into a relational model.

  Port: 9083 

  Protocol: RPC

  Property: `hive.metastore.uris` and `hive.metastore.port`

  External access: yes

  [Source](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties)
  
  [Source](https://github.com/TOSIT-FR/hive/blob/0c5e9e0aae48324335cfeae757e2d37258207b3c/standalone-metastore/src/main/java/org/apache/hadoop/hive/metastore/conf/MetastoreConf.java)

  [Source](https://github.com/TOSIT-FR/hive/blob/0c5e9e0aae48324335cfeae757e2d37258207b3c/common/src/java/org/apache/hadoop/hive/conf/HiveConf.java)

  Verified

- [Hive Server 2](https://cwiki.apache.org/confluence/display/hive/setting+up+hiveserver2)

  The JDBC/ODBC interface to the Hive Metastore.

  Port: 10000

  Protocol: RPC

  Property: `hive.server2.thrift.port`

  External access: yes

  [Source](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties)

  [Source](https://github.com/TOSIT-FR/hive/blob/0c5e9e0aae48324335cfeae757e2d37258207b3c/common/src/java/org/apache/hadoop/hive/conf/HiveConf.java)

  Verified

- [Web User Interface (UI)](https://cwiki.apache.org/confluence/display/hive/setting+up+hiveserver2#SettingUpHiveServer2-WebUIforHiveServer2)

  Port the the web UI to provides configuration, logging, metrics and active session information.

  Port: 10002

  Protocol: HTTPS

  Property: `hive.server2.webui.port`

  External access: yes

  [Source](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties)

  [Source](https://github.com/TOSIT-FR/hive/blob/0c5e9e0aae48324335cfeae757e2d37258207b3c/common/src/java/org/apache/hadoop/hive/conf/HiveConf.java)

  Verified
## Ranger

- Policy Manager

  Port for Ranger secured admin web UI.

  Port: 6182

  Protocol: HTTPS

  Property: `ranger.service.https.port`

  External access: yes

  [Source](https://github.com/apache/ranger/blob/7e80592481306bb0711f7a7544b2c6c64cbebadf/security-admin/src/main/resources/conf.dist/ranger-admin-site.xml)

  [Source](https://github.com/TOSIT-FR/ranger/blob/4992a349905451939951c994b0bb18bd584f59a3/security-admin/scripts/ranger-admin-site-template.xml)

  Verified
## Oozie

- Web UI

  Port for the secured Oozie web UI.

  Port: 11443

  Protocol: HTTPS

  Property: `OOZIE_HTTPS_PORT`

  External access: yes

  [Source](https://github.com/apache/oozie/blob/f1e01a9e155692aa5632f4573ab1b3ebeab7ef45/docs/src/site/markdown/AG_Install.md)

  [Source](https://github.com/TOSIT-FR/oozie/blob/a15fedba1baeb5186ac86f54457a27ef4b738b88/sharelib/oozie/src/test/resources/instrumentation-os-env.json)

  [Source](https://github.com/apache/oozie/blob/f1e01a9e155692aa5632f4573ab1b3ebeab7ef45/core/src/main/resources/oozie-default.xml)

  Verified

- Admin

  The admin port Oozie server runs. It may be opened externally if job submissions are accepted from outside the cluster.

  Port: 11001

  Protocol: HTTPS

  Property: `OOZIE_ADMIN_PORT`

  External access: no

  [Source](https://github.com/TOSIT-FR/oozie/blob/a15fedba1baeb5186ac86f54457a27ef4b738b88/sharelib/oozie/src/test/resources/instrumentation-os-env.json)

  [Source](https://oozie.apache.org/docs/3.3.2/AG_Install.html)
  
  Verified

## Knox

- Gateway

  The port of Knox main gateway to internal cluster services.

  Port: 8443

  Protocol: HTTPS

  Property: `gateway.port`

  External access: yes

  [Source](https://github.com/TOSIT-FR/knox/blob/3c3f23a866d55de563c6574353019858590367d8/gateway-release/home/conf/gateway-site.xml)
  
  Verified

## Additionnal resources

- [CDH ports](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/cdh_ports.html)
- [HDFS default configuration](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)
- [YARN default configuration](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)
- [MapReduce default configuration](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)
- [HDFS should not default to ephemeral ports](https://issues.apache.org/jira/browse/HDFS-9427)
