Introduction:
-------------

**ATTENTION** Since v7.10.4 the Gitlab guys started to publish their own *.deb repositories which probably makes this script useless at all. I looked if the script can easily be adapted - but found out that's not as easy as I thougt at first. Since this script basically was just a helper to easily keep a Gitlab-Omnibus-Installation current, it's not needed anymore in this setup: **I consider the published packages as the way to go now! This project is not maintained further from now on.**

Details on how to switch to the official Debian/Ubuntu packages can be found here: https://about.gitlab.com/upgrade-to-package-repository/



This is just a small script to update an existing Gitlab instance to a newer version. Basically it just executes the commands from the Gitlab documentation, but in an automated way (hint: automation).

This is tested on Ubuntu 14.04 with GiLab Omnibus 7.3.x


How to update GitLab?
---------------------

Just grab the script, make it executable and run it like this::

	sudo /path/to/update-gitlab-omnibus.sh


Thanks
------

While it was an idea on it's own to create this script, I also looked for existing solutions. The script is somewhat inspired by the work of https://github.com/heichblatt/gitlab-omnibus-update - thanks!

License
-------

Licensed under the permissive MIT license, see LICENSE file. Enjoy!
If you want to give something back, have a look at http://rimann.org/support
