For building steps, generally follow the WLinux building guide [here](https://github.com/WhitewaterFoundry/WLinux/blob/master/BUILDING.md).

.diff:

create-targz-x64.sh must be run on an existing enterprise Linux build instead of Debian.

Because the building process uses libvrtd and that is currently unsupported on WSL running create-targz-x64.sh on bare metal is required.