Due to Fedora Remix is a Remix the dnf copr enable messes up with the distribution name so we must specify it.

Instead of running like this:

`sudo dnf copr enable copr_username/copr_projectname`

Type this:

`(source /etc/os-release && sudo dnf copr enable copr_username/copr_projectname ${ID}-${VERSION_ID}-$(uname -m))`

For example:

`(source /etc/os-release && sudo dnf copr enable wslutilities/wslu ${ID}-${VERSION_ID}-$(uname -m))`
