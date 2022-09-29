# balena-obfs4-bridge

Create a tor bridge from a small Raspberry Pi using the Balena cloud, creating a free Internet with low electricity costs. If you use your oldest Raspberry Pi (v1), which is no longer suitable for anything sensible, you've got it at virtually no cost. 

## Getting started

The most important thing is to provide access from the Internet to the Raspberry Pi on UDP ports 65533 and 65532, see [docker-compose.yml](torproject.rpi/docker-compose.yml) This is done differently on different routers, for Mikrotik for example as follows:

```
/ip firewall nat
add action=dst-nat chain=dstnat comment="Tor to Raspberry" dst-port=65533 in-interface-list=WAN protocol=tcp to-addresses=192.168.2.252 to-ports=65533
add action=dst-nat chain=dstnat dst-port=65532 in-interface-list=WAN protocol=tcp to-addresses=192.168.2.252 to-ports=65532
```

## Setup and configuration

Running this project is as simple as deploying it to a balenaCloud application. You can do it in just one click by using the button below:

[![deploy button](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://gitlab.torproject.org/hufhendr/balena-obfs4-bridge&defaultDeviceType=raspberry-pi)

## Highlights
The setup is pre-designed for Broadband, it assumes a consumption of around 3Mbps, a volume that no one should miss on either the download or upload side. In practice, there is no problem watching high-speed streams with this at the same time. However, you want to test it individually and adjust the speed if necessary.