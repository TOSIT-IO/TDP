# Build Environment

Building components written in Python has different requirements than the ones written in Java. They are so to speak not really compiled, however they are still packaged in a Python wheel or a tar.gz file.

The image being used is a manylinux2014 image originally based on CentOS 7 and compatible with many Linux OSs. It moreover has several different Python versions pre-installed on it.

## Build the image

The image can be built and tagged with:

```bash
docker build . -t tdp-builder-python
```

## Start the container

Contrary to the `tdp-builder` container where components are compiled with maven putting the jar files in the `.m2` cache it is not the case here and therefore volumes, working directories and even users are different for each component.

Check the documentation of the concerned component for the command to start the container. 
