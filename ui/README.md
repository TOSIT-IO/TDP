# Tosit Data Platform UI

Purpose of TDP is to be used in production environment.
For that, we need a nice and effective UI, here it is.

## API

API is written in python, it uses flask. All output is returned in the UI. It uses OpenAPI. The API controls SERVICES and COMPONENTS. Using the API is and must forever be an option! It means all ansible roles and playbooks must remind 100% functionnal if you manipulate them manually.

Here are the key function of the API:
- Deploy a service or component
- List the services or components
- Delete a service or component
- Start a service or component
- Stop a service or component
- CRUD configurations
- Rolling restart
- CRUD config groups

An instance of this API will only manage one cluster

REACT or VUE.js must be chosen

## SUPERVISION

In V0, there will be no historical.
Supervision must not use any kind of agent.

LEVEL 0 : Uses NC or Systemctl
LEVEL 1 : Uses CURL or RPC or JMX
LEVEL 2 : Service Check
LEVEL 3 : Auto resolves all issues :)

All the previous features are implemented service and component on the API

## STOP / START / ROLLING

Prerequisites : All the following things are supposed to be setup and in a functionnal state:
- KDC
- LDAP
- RDBMS
- SSSD
- SSL
- Hadoop cluster must have already been deployed

Here are services dependancies

<pre>
                                            ZK
                                             |
                                             |
                                       Ranger Admin
                                             |
                                             |
                                            JN
                                             |
                                             |
                                           ZKFC
                                             |
                                             |
              ___________________________ NN + DN____________________________ 
             |                               |                               |
             |                               |                               |
         SPARK HS                    YNM + YRM + YATS                   HBASE MASTER
             |                               |                               |
             |                               |                        HBASE RS + REST
             |                           HS2 + HSM                           |
             |                               |                           PHOENIX QS
             |____________________________   |  _____________________________|
                                           OOZIE
                                             |
                                             |
                                           KNOX
</pre>

## CONFIGURATIONS MANAGEMENT

Playbook orchestration, versionning
LEVEL 0 : Hadoop cluster must have already been deployed
LEVEL 1 : No existing Hadoop cluster

### GIT REPO for OPS, VARS, TOPOLOGIES

Git repo is synchronized, the API server is the only instance that can push to the remote
On the GIT, only vars are stored, not XML files
Rule is : 1 modification = 1 commit
We use an RDBMS instance in order to store this historic of deployment actions
When we deploy:
- 0 : We choose the commit
- 1 : We do the deployment action
- 2 : We write the action in the RDBMS

If a Rollback is needed -> Git revert (1 and only 1 commit)

Configuration management scope is the whole cluster (1 and only 1 ops repo)

### GIT REPO for Ansible Collections

.

## METROLOGY

### UI
UI = GRAFANA
Backend = Prometheus
Is there any kind of feature for time-frame merging in Prometheus ?
If not, let's have a look at a solution with GRAPHITE + an agent

### Logs
We log services like this
<pre>
                                         Log file
                                             |
                                             |
                                          Fluentd
                                             |
                                             |
                                      Elasticsearch
</pre>
