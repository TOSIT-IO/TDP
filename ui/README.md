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

|                                            ZK
|                                             |
|                                             |
|                                       Ranger Admin
|                                             |
|                                             |
|                                            JN
|                                             |
|                                             |
|                                           ZKFC
|                                             |
|                                             |
|              ___________________________ NN + DN____________________________ 
|             |                               |                               |
|             |                               |                               |
|         SPARK HS                    YNM + YRM + YATS                   HBASE MASTER
|             |                               |                               |
|             |                               |                        HBASE RS + REST
|             |                           HS2 + HSM                           |
|             |                               |                           PHOENIX QS
|             |____________________________   |  _____________________________|
|                                           OOZIE
|                                             |
|                                             |
|                                           KNOX
