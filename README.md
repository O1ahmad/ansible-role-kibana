Ansible Role :microscope: :stars: Kibana
=========
[![Galaxy Role](https://img.shields.io/ansible/role/45337.svg)](https://galaxy.ansible.com/0x0I/kibana)
[![Downloads](https://img.shields.io/ansible/role/d/45337.svg)](https://galaxy.ansible.com/0x0I/kibana)
[![Build Status](https://travis-ci.org/0x0I/ansible-role-kibana.svg?branch=master)](https://travis-ci.org/0x0I/ansible-role-kibana)

**Table of Contents**
  - [Supported Platforms](#supported-platforms)
  - [Requirements](#requirements)
  - [Role Variables](#role-variables)
      - [Install](#install)
      - [Config](#config)
      - [Launch](#launch)
  - [Dependencies](#dependencies)
  - [Example Playbook](#example-playbook)
  - [License](#license)
  - [Author Information](#author-information)

Ansible role that installs and configures Kibana, an analytics and visualization platform designed to operate with Elasticsearch.

##### Supported Platforms:
```
* Debian
* Redhat(CentOS/Fedora)
* Ubuntu
```

Requirements
------------

Requires the `unzip/gtar` utility to be installed on the target host. See ansible `unarchive` module [notes](https://docs.ansible.com/ansible/latest/modules/unarchive_module.html#notes) for details.

Role Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _install_
* _config_
* _launch_

#### Install

`kibana`can be installed using OS package management systems (e.g `apt`, `yum`) or compressed archives (`.tar`, `.zip`) downloaded and extracted from various sources.

_The following variables can be customized to control various aspects of this installation process, ranging from software version and source location of binaries to the installation directory where they are stored:_

`install_type: <package | archive>` (**default**: archive)
- **package**: supported by Debian and Redhat distributions, package installation of Kibana pulls the specified package available from the respective package management repositories.
  - Note that the installation directory is determined by the package management system and currently defaults to `/usr/share` for both distros.
- **archive**: compatible with both **tar and zip** formats, archived installation binaries can be obtained from local and remote compressed archives either from the official [download/releases](https://www.elastic.co/downloads/kibana) site or those generated from development/custom sources.

`default_install_dir: </path/to/installation/dir>` (**default**: `/opt/kibana`)
- path on target host where the `kibana` binaries should be extracted to. *ONLY* relevant when `install_type` is set to **archive**.

`archive_url: <path-or-url-to-archive>` (**default**: see `defaults/main.yml`)
- address of a compressed **tar or zip** archive containing `kibana` binaries. This method technically supports installation of any available version of `kibana`. Links to official versions can be found [here](https://www.elastic.co/downloads/past-releases#kibana). *ONLY* relevant when `install_type` is set to **archive**

`archive_checksum: <path-or-url-to-checksum>` (**default**: see `defaults/main.yml`)
- address of a checksum file for verifying the data integrity of the specified archive. While recommended and generally considered a best practice, specifying a checksum is *not required* and can be disabled by providing an empty string (`''`) for its value. *ONLY* relevant when `install_type` is set to **archive**.

`package_url: <path-or-url-to-package>` (**default**: see `defaults/main.yml`)
- address of a **Debian or RPM** package containing `kibana` source and binaries. Note that the installation layout is determined by the package management systems. Consult Elastic's official documentation for both [RPM](https://www.elastic.co/guide/en/kibana/current/rpm.html) and [Debian](https://www.elastic.co/guide/en/kibana/current/deb.html) installation details. *ONLY* relevant when `install_type` is set to **package**

`package_checksum: <path-or-url-to-checksum>` (**default**: see `vars/...`)
- address of a checksum file for verifying the data integrity of the specified package. While recommended and generally considered a best practice, specifying a checksum is *not required* and can be disabled by providing an empty string (`''`) for its value. *ONLY* relevant when `install_type` is set to **package**.

`checksum_format: <string>` (**default**: see `sha512`)
- hash algorithm used for file verification associated with the specified archive or package checksum. Reference [here](https://en.wikipedia.org/wiki/Cryptographic_hash_function) for more information about checksums/cryptographic hashes.

#### Config

Configuration of `kibana` is expressed within a single YAML configuration file, `kibana.yml`. This file is located in an application config directory designated by the environment variable `KIBANA_HOME`, the value of which depends on whether or not the installation is from an archive distribution (tar.gz or zip) or a package distribution (Debian or RPM packages).

For additional details, reference Elastic's official Kibana [configuration](https://www.elastic.co/guide/en/kibana/current/settings.html) documentation.

_The following variables can be customized to manage the location and content of this configuration file:_

`default_config_dir: </path/to/configuration/dir>` (**default**: `/opt/kibana/config`)
- path on target host where the aforementioned configuration file should be stored

`config: <hash-of-kibana-settings>` **default**: {}

- Set of Kibana configuration key-value pairs which determine the behaviour of the associated server instance. These settings are generally node-specific (such as server instance name and persistent data paths), or are required by a node to be able to join a cluster. Any configuration setting/value key-pair supported by `kibana` should be expressible within the hash and properly rendered within the associated YAML config.

Values can be expressed in typical _yaml/ansible_ form (e.g. Strings, numbers and true/false values should be written as is and without quotes).

  Keys of the `config` hash can be either nested or delimited by a '.':
  ```yaml
  config:
    server.name: example-node
    path:
      data: /mnt/data/kibana
  ```

A list of configurable settings can be found [here](https://github.com/elastic/kibana/blob/master/config/kibana.yml).

`default_data_dir: </path/to/data/dir>` (**default**: `/var/data/kibana`)
- path on target host where persistent data generated by the Kibana service (e.g. saved visualizations, etc) should be stored

`default_log_dir: </path/to/log/dir>` (**default**: `stdout`)
- path on target host where logs generated by the Kibana service should be stored

#### Launch

Running the `kibana` analytics and visualization service along with its API server is accomplished utilizing the [systemd](https://www.freedesktop.org/wiki/Software/systemd/) service management tool for both *package* and *archive* installations. Launched as background processes or daemons subject to the configuration and execution potential provided by the underlying management framework, launch of `kibana` can be set to adhere to system administrative policies right for your environment and organization.

_The following variables can be customized to manage the service's **systemd** service unit definition and execution profile/policy:_

`extra_run_args: <kibana-cli-options>` (**default**: `[]`)
- list of `elasticsearch` commandline arguments to pass to the binary at runtime for customizing launch. Supporting full expression of `kibana`'s cli, this variable enables the launch to be customized according to the user's specification.

`custom_unit_properties: <hash-of-systemd-service-settings>` (**default**: `[]`)
- hash of settings used to customize the [Service] unit configuration and execution environment of the Elasticsearch **systemd** service.

```yaml
custom_unit_properties:
  Environment: "KIBANA_HOME={{ install_dir }}"
  LimitNOFILE: infinity
```

Reference the [systemd.service](http://man7.org/linux/man-pages/man5/systemd.service.5.html) *man* page for a configuration overview and reference.

Dependencies
------------

- 0x0i.systemd

Example Playbook
----------------
default example:
```
- hosts: all
  roles:
  - role: 0xOI.kibana
```

install specific archive version:
```
- hosts: all
  roles:
  - role: 0xOI.kibana
    vars:
      archive_url: https://download.elastic.co/kibana/kibana/kibana-3.0.0.tar.gz
      archive_checksum: https://download.elastic.co/kibana/kibana/kibana-3.0.0.tar.gz.sha1.txt
      checksum_format: sha1
```

customize Elasticsearch hosts to connect to:
```
- hosts: all
  roles:
  - role: 0xOI.kibana
    vars:
      config:
        elasticsearch.hosts: http://es1.cluster.domain:9200,http://es2.cluster.domain:9200
```

modify default logging (STDOUT) behaviour by writing to file on disk:
```
- hosts: all
  roles:
  - role: 0xOI.kibana
    vars:
      config:
        logging.dest: /var/log/kibana/kibana.log
```

adjust settings for easier debugging/troubleshooting:
```
- hosts: all
  roles:
  - role: 0xOI.kibana
    vars:
      config:
        logging.verbose: true
        server.host: 0.0.0.0
        ops.interval: 1000
      extra_run_args: ['--verbose']
```

License
-------

Apache, BSD, MIT

Author Information
------------------

This role was created in 2019 by O1.IO.
