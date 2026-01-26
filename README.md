# Trunk Data Platform

![](static/tdp_logo.png)

[Trunk Data Platform](https://www.trunkdataplatform.io) is an Open Source, free, Hadoop distribution built from Apache projects source code.

## Authors

This distribution is built by EDF (French electricity provider) & DGFIP (Tax Office by the French Ministry of Finance), through an association called [TOSIT](https://tosit.fr/) (The Open source I Trust).

## Local build environment for components

In order to build the TDP components, two distinct images have been made:

- [tdp-builder]((build-env/README.md)) containing Maven for Java compilation of the Apache Hadoop environment components.
- [tdp-builder-python](build-env-python/README.md) containing a manylinux2014 image with different Python versions for the packaging of JupyterHub, Jupyterlab, Sparkmagic and Hue.

### tdp-builder

Run the following script to build the image, open the container and be ready to compile the components with Maven:

```sh
./bin/start-build-env.sh
```

The components' versions and their repositories are found in [tdp-core](https://www.trunkdataplatform.io/en/discover/stacks/tdp2-0) and must be compiled in the follwing order:

- Zookeeper
- Hadoop
- Tez
- Spark3
- Hive
- HBase
- Ranger
- Phoenix
- Phoenix-queryserver
- Knox
- HBase Operator tools
- Iceberg

The Maven compilation commands of the different components can be found in the `tdp/README.md` file of each project.

### tdp-builder-python

Although the python coded components use the same [tdp-builder-python](build-env-python/README.md) image, they must be packaged seperately in different containers since each component needs its own envrionment:

- [JupyterHub](https://github.com/TOSIT-IO/jupyterhub/tree/branch-2.3.1-basic/tdp)
- [JupyterLab](https://github.com/TOSIT-IO/jupyterlab/tree/branch-3.2.9-basic/tdp)
- [Sparkmagic](https://github.com/TOSIT-IO/sparkmagic/tree/branch-0.21.0-basic/tdp)
- [Hue](https://github.com/TOSIT-IO/hue/tree/branch-4.11.0-fix/tdp)

### Special case for the Apache Livy compilation

Apache Incubator Livy has its own compilation environment with its own instrsuctions which can be found in the [Incubator Livy project](https://github.com/TOSIT-IO/incubator-livy/tree/branch-0.9.0-fix/tdp).

## Contributing

Contributions are always welcome!

See [CONTRIBUTING.md](./CONTRIBUTING.md) for ways to get started.
