# Pardus Calamares Settings

Calamares settings for the Pardus GNU/Linux distribution. A fork of the debian calamares settings.

## Building Instructions
```
apt update
apt install git devscripts equivs -y
git clone https://github.com/pardusc/pardus-calamares-settings && cd pardus-calamares-settings
mk-build-deps --install
debuild -us -uc -b
```