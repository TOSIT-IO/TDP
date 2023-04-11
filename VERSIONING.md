
# Versioning sofware in the TDP Project
 
This document is to provide guidelines for versioning and releasing software in the TDP Project.

As of April 2023, TDP project includes:

- Stack containing Apache Hadoop Softwares along with building instructions and patches backported by the TOSIT. ([TOSIT-IO/hadoop](https://github.com/TOSIT-IO/hadoop), [TOSIT-IO/hive](https://github.com/TOSIT-IO/hive) ...)
- Ansible collection which installs said software. ([TOSIT-IO/tdp-collection](https://github.com/TOSIT-IO/tdp-collection))
- Library which installs Ansible collections exposing a DAG. ([TOSIT-IO/tdp-lib](https://github.com/TOSIT-IO/tdp-lib))
  - A HTTP Server and web UI are built on top of this library. ([TOSIT-IO/tdp-server](https://github.com/TOSIT-IO/tdp-server), [TOSIT-IO/tdp-ui](https://github.com/TOSIT-IO/tdp-ui))

## TDP Stack

TDP Stack expose a version number that creates a coherent state of its software.

Software version in the stack contains this version as well their base in the Apache upstream repository.

For example:

- TDP Stack in version `1.1` includes HBase forked from `2.1.10`
- HBase version is modified by TOSIT to `2.1.10-1.0`. In the appendix `-1.0`:
  - The first digit is bumped by TOSIT and contains bugfix and/or backport.
  - The second digit is NEVER modified by TOSIT. It is there for any user and vendor to create non cumulative patch to the software. It allows anyone to create its own release of a product without requiring approval from TOSIT association. This patch number is not necessarily cumulative. If appropriate, the content of said patch should be included in the TOSIT repository in the form of a patch that would bump the first digit of the appendix.

Unreleased changes should be tagged `-SNAPSHOT` as per Java Standard.

Upgrading the stack for security bumps the last digit of the stack, whether it's TOSIT patch (included in the last 2 digits) or upgrading a software to a newer Apache upstream version.

## TDP Collection

TDP-Collection is tightly coupled to the TDP Stack it installs.

As an example TDP-Collection 1.0 installs TDP Stack `1.1`. When the stack upgrades to `1.2`, it requires collection to upgrade to `2.0`.

New Features and bugfix in the collection bumps only the second digit as it still installs the same stack.

TDP Collection works with TDP lib by exposing a DAG. A version of TDP Collection defines which version of TDP Lib's DAG it was built for.

## TDP Manager

TDP Lib, Server and UI projects follow [SemVer](https://semver.org/).

Major Version of TDP Lib should be bumped when the interface (the DAG exposed by the collection) have breaking changes.

## Other Products

Other products follow the same principles:

- Software can be versioned by TOSIT but not integrated in the TDP Stack. They should expose a version number as a suffix.
- Ansible collections (e.g: observability, extras) specify which version of the TDP Lib DAG they are built for
