# Trunk Data Platform

## Trunk Data Platform - Onboarding

We welcome everyone!\
You can participate in many ways to TDP, depending on your needs/skills/hardware.

| You can be!        | Hardware requirements | Skills requirements |
| -------------------|-----------------------|---------------------|
| Core Developer     | + + + + +             | + + + + +           |
| Cluster Admin      | + + +                 | + + +               |
| End User           | + + +                 | + + +               |
| Sandbox End User   | +                     | +                   |

## TDP Core Developer

First important thing:
Every core development team has it's own build infrastructure.

Hardware requirements:
- Kubernetes cluster
- Jenkins
- Nexus & Docker registry

Skill requirements:
- Java
- Maven
- Linux
- Hadoop eco-system
- Python (for web front)

As core developer, your goal is to:
- Integrate new components
- Integrate new version of existing components
- Create new features
- Fix bugs

In 1 sentence: You create Tarballs containing Jars & binaries.


## TDP Cluster Admin

Hardware requirements:
- Linux boxes
- At least 6 virtual machines (or Bare metal machines)
- Kerberos Domain Controler
- RDBMS
- SSL
- LDAP
- SSSD

Skill requirements:
- Linux
- Network
- Hadoop eco-system
- Kerberos/LDAP
- Ansible

As cluster admin, your goal is to:
- Deploy TDP cluster
- Create new features in existing admin component
- Fix bugs

In 1 sentence: You use TDP tarballs to create cluster.

## TDP End User

Hardware requirements:
- Same as above (Cluster Admin)

Skill requirements:
- A "good" Linux sys-admin
- A "good" Hadoop cluster admin

As an end user, your goal is to:
- Deploy TDP cluster
- Evaluate the product
- Report bugs and issues

In 1 sentence: You setup TDP and use it

## TDP Sandbox End User

Hardware requirements:
- A Linux desktop with 32GB of RAM and internet access.

Skill requirements:
- Linux
- Vagrant
- Virtualbox
- Hadoop

As a sandbox end user, your goal is to:
- Deploy a TDP cluster locally
- Evaluate the product

In 1 sentence: You spend one hour and understand what TDP is :)
