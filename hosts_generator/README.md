## Host file to be used for adhell3

The aim of this host file has been to keep the amount of hosts as small as possible. Bigger isn't always better, especially with the effective use of wildcards and pruning of dead hosts.

https://gitlab.com/fusionjack/hosts/raw/master/hosts

This host file has been created specifically for use with adhell3; It is based on the following sources:

* [Dan Pollock](http://someonewhocares.org/hosts/hosts)
* [Adguard Mobile Filter](https://filters.adtidy.org/extension/chromium/filters/11.txt)
* [yoyo.org](https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0)
* [disconnect.me simple ad](https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt)
* [disconnect.me simple malvertising](https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt)
* [disconnect.me simple malware](https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt)
* [disconnect.me simple tracking](https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt)

#### Blacklist recommendations
These domains are annoyances that cannot be included in the main host-file due to issues that may arise as a result of blocking them.
* **graph.facebook.com** (Facebook Ad Choices; can break Facebook login etc.)

#### Whitelist recommendations
These domains may need to be whitelisted for certain sites to function correctly.
* **analytics.twitter.com** (reports of broken twitter links)

#### Credits
https://github.com/mmotti/mmotti-host-file