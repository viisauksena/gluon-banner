some tools for Freifunk Gluon to enhance ssh logins with many infos and some miniscripts and maintainance, for example

```
alfredcheck  autoupdater-status  clientwifi  fastd-status  geoguess_legacy  hop_penalty  location  meshwifi  MoW       nodename  sshkeys  uplinkif
alt          branch              contact     geoguess      help             lat          lon       MoL       nodeinfo  snping    status   v4up		 wginfo

```

supersimple example of php for geoguess
(because small freifunk router cannot connect to https ... so you have to be tricky)
```
<?php

function IsValid($mac)
{
  return (preg_match('/([a-fA-F0-9]{2}[:|\-]?){6}$/', $mac) == 1);
}

# validate and append all macs
foreach($_GET as $mac=>$val)
  { if(IsValid($val)) { $full .= "{\\\"macAddress\\\": \\\"$val\\\"}," ; } };
# remove last ","
$full = rtrim($full, ",");
# substr($full,0,-1);

system("wget -qO- \"https://location.services.mozilla.com/v1/geolocate?key=test\" --post-data=\"{ \\\"wifiAccessPoints\\\": [$full],\\\"considerIp\\\": \\\"false\\\"}\" ");

?>

```

## add some lines to site.mk (i.e. gluon-banner) and modules like :
```
GLUON_SITE_FEEDS=' ...  banner ... '
PACKAGES_BANNER_REPO=https://github.com/viisauksena/gluon-banner.git
PACKAGES_BANNER_COMMIT=4f91b48c81d964d84aac6156fa41c01270a8e2fb
PACKAGES_BANNER_BRANCH=lede

```
