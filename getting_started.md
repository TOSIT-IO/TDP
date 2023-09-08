# TDP Manager getting started

Le TDP Manager est un ensemble d'outils conçus pour faciliter la gestion de l'installation et de la reconfiguration d'un cluster TDP.

Le déploiement de TDP est effectué en utilisant Ansible, en utilisant les collections suivantes :

- [tdp-collection](https://github.com/TOSIT-IO/tdp-collection)
- [tdp-collection-extras](https://github.com/TOSIT-IO/tdp-collection-extras)
- [tdp-observability](https://github.com/TOSIT-IO/tdp-observability)

Ces collections peuvent être utilisées telles quelles pour installer un cluster TDP.

Pour reconfigurer un cluster TDP, il est nécessaire de redémarrer les composants qui en dépendent. Par exemple, lors de la reconfiguration d'un composant de HDFS, il est nécessaire de reconfigurer également les composants de HBase qui utilisent HDFS comme backend.

C'est pourquoi un autre outil est nécessaire pour piloter cette reconfiguration : [tdp-lib](https://github.com/TOSIT-IO/tdp-lib).

Afin que cet outil puisse connaître les dépendances entre les composants, un [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph) est généré en lisant les fichiers correspondants dans les collections. Chaque collection définit le DAG des composants qu'elle déploie.

La configuration des composants est stockée dans les "TDP vars". Des variables par défaut sont définies dans les collections. Chaque collection définit les variables des composants qu'elle déploie.

Pour interagir avec `tdp-lib`, un CLI est disponible après son installation. Ce CLI nécessite un accès aux collections de TDP et un environnement Ansible fonctionnel.

`tdp-server` permet d'exposer une API HTTP REST pour effectuer les actions de `tdp-lib` avec une authentification. Cependant, il n'est actuellement pas fonctionnel avec la version en développement de `tdp-lib`.

`tdp-ui` permet d'avoir une interface web en utilisant l'API HTTP de `tdp-server`. Cependant, il n'est actuellement pas fonctionnel avec la version en développement de `tdp-lib`.

Une collection de prérequis ([tdp-collection-prerequisites](https://github.com/TOSIT-IO/tdp-collection-prerequisites)) permet, entre autres, d'installer PostgreSQL, LDAP et Kerberos. Les playbooks de cette collection ne sont pas lancés par TDP Manager.

## Prérequis

- Python 3.9 avec le module `venv` pour la création d'environnements virtuels.

**Optionnel :** Si vous souhaitez afficher le DAG de manière graphique via `tdp dag`, il est nécessaire d'installer `graphviz`.

Ouvrez un terminal et positionnez-vous dans un répertoire vide. Toutes les commandes doivent être exécutées dans ce répertoire, sauf indication contraire.

## Création de l'environnement virtuel Python

Ajoutez un fichier `requirements.txt` avec le contenu suivant :

```
tdp-lib[visualization]@https://github.com/TOSIT-IO/tdp-lib/tarball/master
```

Créez un environnement virtuel Python, ce qui entraînera la création d'un répertoire `venv`.

```bash
python3 -m venv venv
source ./venv/bin/activate
pip install -U pip
pip install -U setuptools wheel
pip install -r requirements.txt
```

Ansible est installé dans cet environnement virtuel par dépendance.

## Configuration d'Ansible

Étant donné que l'installation de TDP se fait via des collections Ansible, il est nécessaire de configurer Ansible.

TDP Manager nécessite l'appel de la commande `ansible-playbook`, et celle-ci doit pouvoir être lancée sans option et sans interaction de l'utilisateur. Pour cela, un fichier de configuration Ansible est nécessaire.

Ajoutez un fichier `ansible.cfg` avec le contenu suivant :

```
[defaults]
inventory=inventory
any_errors_fatal=True
display_skipped_hosts=False
collections_paths=ansible_dependencies
roles_path=ansible_dependencies/ansible_roles

[inventory]
cache = true
cache_plugin = jsonfile
cache_timeout = 7200
cache_connection = .cache

[tdp]
vars = tdp_vars

[privilege_escalation]
become=True
become_user=root
```

- `inventory` (**obligatoire**) permet de définir le répertoire de l'inventaire Ansible.
- `any_errors_fatal` (**recommandé**) permet d'arrêter l'exécution d'Ansible dès qu'il y a une erreur et empêche Ansible de continuer sur les hôtes restants.
- `display_skipped_hosts` (**recommandé**) permet de ne pas afficher les tâches Ansible qui sont *skipped* pour éviter d'encombrer les logs.
- `collections_paths` (**recommandé**) permet de définir les chemins pour les collections. Le premier chemin de cette liste sera celui utilisé pour les dépendances téléchargées avec `ansible-galaxy`.
- `roles_path` (**recommandé**) permet de définir les chemins pour les rôles. Le premier chemin de cette liste sera celui utilisé pour les dépendances téléchargées avec `ansible-galaxy`.

L'activation du cache pour l'inventaire permet d'accélérer considérablement le lancement des playbooks (**recommandé**), car l'installation de TDP implique de nombreux appels à la commande `ansible-playbook`.

La section `tdp` (**obligatoire**) avec `vars = tdp_vars` permet d'activer le plugin `tdp_vars`, qui construit les variables utilisées par les collections Ansible de TDP.

La section `privilege_escalation` (**obligatoire**) permet d'activer le passage à l'utilisateur `root` pour toutes les tâches Ansible.

## Téléchargement des dépendances de collections et de rôles Ansible

Ajoutez un fichier `requirements.yml` avec le contenu suivant :

```
---
collections:
  - name: ansible.posix
    version: 1.5.4
  - name: community.crypto
    version: 2.14.0
  - name: community.general
    version: 7.1.0
  - name: community.grafana
    version: 1.5.4
  - name: community.postgresql
    version: 2.4.2

  # Obligatoire
  - name: https://github.com/TOSIT-IO/tdp-collection
    type: git
    version: master
  # Optionnel (composants supplémentaires)
  - name: https://github.com/TOSIT-IO/tdp-collection-extras
    type: git
    version: master
  # Optionnel (composants supplémentaires)
  - name: https://github.com/TOSIT-IO/tdp-observability
    type: git
    version: main
  # Optionnel si les pré-requis sont déjà installés.
  - name: https://github.com/TOSIT-IO/tdp-collection-prerequisites
    type: git
    version: master
```

Pour exécuter les commandes Ansible, vous devez activer l'environnement virtuel créé précédemment en utilisant la commande `source ./venv/bin/activate`.

Ensuite, exécutez la commande suivante pour installer les dépendances :

```
ansible-galaxy install -r requirements.yml
```

Si TDP Observability a été installé, il est nécessaire d'installer les dépendances supplémentaires :

```
pip install -r ansible_dependencies/ansible_collections/tosit/tdp_observability/requirements.txt
ansible-galaxy install -r ansible_dependencies/ansible_collections/tosit/tdp_observability/requirements.yml
```

## Création de la structure d'Ansible

Créez la structure de l'inventaire Ansible en exécutant les commandes suivantes :

```
mkdir -p inventory/{group_vars,topologies}
```

Activez le plugin `tdp_vars` en ajoutant le fichier `inventory/tdp_vars.yml` avec le contenu suivant :

```
plugin: tosit.tdp.tdp_vars
```

Des variables **doivent** être définies sur tous les hôtes. Pour ce faire, créez un fichier `inventory/group_vars/all.yml` avec le contenu suivant :

```
---
domain: tdp
realm: TDP.LOCAL
kerberos_admin_principal: "admin/admin@{{ realm }}"
kerberos_admin_password: admin123
kadmin_principal: "{{ kerberos_admin_principal }}"
kadmin_password: "{{ kerberos_admin_password }}"
```

- `domain` correspond au domaine des machines.
- `realm` est le nom du *realm* Kerberos.
- `kerberos_admin*`: TODO
- `kadmin*`: TODO

Les fichiers de topologies permettent de définir le placement des composants sur les différents hôtes. Ce sont des fichiers d'inventaire Ansible.

Des fichiers exemples sont disponibles dans chaque collection, dans lesquels tous les composants sont attribués à des hôtes.

```
cp ansible_dependencies/ansible_collections/tosit/tdp/topology.ini inventory/topologies/01_tdp
```

`tdp-collection` est la collection principale, et son fichier de topologie doit être lu en premier. C'est pourquoi un numéro est ajouté au début du nom du fichier. Les topologies des autres collections utilisent les noms des groupes définis dans cette topologie.

Si les autres collections sont installées, il faut également ajouter leurs topologies :

```
cp ansible_dependencies/ansible_collections/tosit/tdp_extra/topology.ini inventory/topologies/tdp_extra
cp ansible_dependencies/ansible_collections/tosit/tdp_observability/topology.ini inventory/topologies/tdp_observability
cp ansible_dependencies/ansible_collections/tosit/tdp_prerequisites/topology.ini inventory/topologies/tdp_prerequisites
```

Modifiez les fichiers de topologie situés dans le répertoire `inventory/topologies` pour refléter le placement des composants sur les hôtes souhaités.

## Création du fichier de configuration pour tdp-lib

La configuration de `tdp-lib` se fait via des variables d'environnement. Le fichier `.env` du répertoire courant est lu par `tdp-lib` et agit donc comme un fichier de configuration.

Créez un fichier `.env` avec le contenu suivant :

```
export TDP_COLLECTION_PATH=ansible_dependencies/ansible_collections/tosit/tdp:ansible_dependencies/ansible_collections/tosit/tdp_extra:ansible_dependencies/ansible_collections/tosit/tdp_observability
export TDP_RUN_DIRECTORY=.
export TDP_VARS=./tdp_vars
export TDP_DATABASE_DSN=sqlite:///sqlite.db
```

- `TDP_COLLECTION_PATH` contient une liste de chemins séparés par le séparateur de chemin de votre système d'exploitation (vous pouvez le vérifier avec la commande `python -c "import os; print(os.pathsep)"`).
- `TDP_RUN_DIRECTORY` est le répertoire dans lequel les commandes Ansible seront exécutées.
- `TDP_VARS` est le répertoire contenant les variables du cluster et sera créé par `tdp-lib`.
- `TDP_DATABASE_DSN` permet d'indiquer la base de données utilisée par `tdp-lib`.

## Création des machines du cluster

Pour déployer TDP, il est nécessaire de disposer de machines configurables via Ansible.

Si vous disposez déjà de machines, passez à la section suivante pour créer l'inventaire des hôtes.

Il est possible de tester les fonctionnalités de TDP Manager sans machine en ajoutant `export TDP_MOCK_DEPLOY=True` dans le fichier `.env`. Dans ce cas, toutes les commandes Ansible ne seront pas exécutées et seront considérées comme réussies.

### Création de machines de test avec Vagrant (Optionnel)

Des machines de test peuvent être créées via [Vagrant](https://www.vagrantup.com/). Pour ce faire, suivez ces étapes :

```
wget https://github.com/TOSIT-IO/tdp-vagrant/tarball/0.1 -O tdp-vagrant.tar.gz
mkdir tdp-vagrant
tar --strip-components=1 -C tdp-vagrant -xf tdp-vagrant.tar.gz
ln -s tdp-vagrant/Vagrantfile
```

Si vous souhaitez modifier la configuration des machines, copiez d'abord le fichier de configuration dans le répertoire courant :

```
cp tdp-vagrant/vagrant.yml .
```

Ensuite, éditez le fichier `vagrant.yml` du répertoire courant selon vos besoins.

Un fichier README est disponible dans le répertoire `tdp-vagrant` pour expliquer son utilisation.

Pour démarrer les machines, utilisez la commande `vagrant up`.

L'inventaire des hôtes Ansible est créé par Vagrant à l'emplacement `.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory`.

### Création du fichier d'inventaire des hôtes

Un fichier d'inventaire minimal est nécessaire, contenant la liste des hôtes ainsi que des groupes obligatoires utilisés par les topologies :

- `edge`
- `master`
- `master1`
- `master2`
- `master3`
- `worker`

Si vous avez utilisé Vagrant conformément à la section précédente, ajoutez un lien symbolique vers l'inventaire Vagrant avec la commande suivante :

```
ln -s ../.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory inventory/hosts
```

Si vous disposez de votre propre infrastructure, créez un fichier `inventory/hosts` avec le contenu suivant :

```
[edge]
edge-01

[master]
master-01
master-02
master-03

[master1]
master-01

[master2]
master-02

[master3]
master-03

[worker]
worker-01
worker-02
worker-03
```

Modifiez ce fichier en fonction de votre infrastructure.

## Installer les prérequis (PostgreSQL, LDAP, Kerberos)

Avant d'installer le cluster avec TDP Manager, il est nécessaire d'installer les prérequis qui ne sont pas gérés par TDP Manager. Pour cela, une collection Ansible ([tdp-collection-prerequisites](https://github.com/TOSIT-IO/tdp-collection-prerequisites)) permet de le faire. Cependant, pour un cluster de production, il est recommandé de ne pas utiliser cette collection et d'avoir un cluster PostgreSQL, LDAP et Kerberos hautement disponible.

Exécutez la commande suivante pour installer les prérequis :

```
ansible-playbook ansible_dependencies/ansible_collections/tosit/tdp_prerequisites/playbooks/all.yml
```

Un avertissement concernant les `tdp_vars` peut s'afficher. La collection de prérequis n'utilise pas les `tdp_vars`, vous pouvez donc ignorer cet avertissement.

## Initialisation des tdp_vars et de la base de données de TDP Manager

Les variables du cluster sont stockées dans le répertoire indiqué via la variable `TDP_VARS`, configurée dans une [section précédente](#création-du-fichier-de-configuration-pour-tdp-lib). La connexion à la base de données est définie via la variable `TDP_DATABASE_DSN`. Cette base de données stocke les déploiements réalisés ainsi que la version de la configuration déployée.

Vous pouvez créer un dossier contenant des fichiers de surcharge pour les `tdp_vars` par défaut. Pour cela, créez un répertoire avec la même arborescence que les `tdp_vars_default` disponibles dans les collections et utilisez l'option `--overrides` pour la commande `tdp init`.

Exécutez la commande suivante pour initialiser les `tdp_vars` :

```
tdp init
```

## Primo déploiement du cluster

Le déploiement avec TDP Manager se fait en deux étapes : un "plan" pour planifier une liste d'opérations, puis un "déploiement" qui lance cette liste d'opérations.

Pour générer un plan, exécutez la commande suivante :

```
tdp plan dag
```

Le plan est créé en suivant l'ordre du DAG. Vous pouvez voir tous les déploiements et les plans via `tdp browse`, ou pour voir le plan en détail, utilisez `tdp browse --plan`.

Pour lancer l'exécution du plan, utilisez la commande suivante :

```
tdp deploy
```

Cela lance l'exécution du plan, c'est-à-dire l'exécution des commandes `ansible-playbook` dans le bon ordre pour déployer le cluster TDP.
