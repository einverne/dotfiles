#!/usr/bin/env bash

rm -rf $HOME/.bin

mkdir -p $HOME/.config/{radarr,sonarr,cloudplow,prowlarr,jellyfin,sabnzbd}

## change version no to update SABNZBD and JELLYFINd

SABNZBD_VERSION=$(curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest | grep -E 'tag_name' | cut -d '"' -f 4)
SABNZBD_URL=$(curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest | grep -E 'browser_download_url' | grep '\-src'  | cut -d '"' -f 4)
JELLYFIN_VERSION=$(curl -s 'https://repo.jellyfin.org/releases/server/linux/stable/combined/' | egrep -m 1 -o "jellyfin_[0-9\.]+_amd64\.tar\.gz" | head -n 1 | cut -d "_" -f2)
## to update ASPDOTNET find new url at https://dotnet.microsoft.com/en-us/download/dotnet/5.0
ASPDOTNET_URL="https://download.visualstudio.microsoft.com/download/pr/f56adf04-e4a8-48bf-b2e2-722e7206a4f2/7f40d4ebeff281120ba76e7b091356b0/aspnetcore-runtime-5.0.14-linux-x64.tar.gz"

random_open_port(){
LOW_BOUND=10000
UPPER_BOUND=65000
comm -23 <(seq ${LOW_BOUND} ${UPPER_BOUND} | sort -u) <(ss -Htan | awk '{print $4}' | rev | cut -d':' -f1 | rev | sort -u) | shuf | head -n 1
}

SABNZBD_PORT=$(random_open_port)
RADARR_PORT=$(random_open_port)
PROWLARR_PORT=$(random_open_port)
SONARR_PORT=$(random_open_port)
JELLYFIN_PORT=$(random_open_port)
USERNAME=$(whoami)

## kill tmux
kill -9 $(pgrep -f -u ${USERNAME} "tmux") > /dev/null 2>&1

## install cloudplow
installdir="$HOME/.bin/cloudplow"
datadir="$HOME/.config/cloudplow"
python3 -m venv ${installdir}
cd ${installdir}
git clone https://github.com/l3uddz/cloudplow.git > /dev/null 2>&1
source ${installdir}/bin/activate
python -m pip install -U pip > /dev/null 2>&1
python3 -m pip install -r ${installdir}/cloudplow/requirements.txt > /dev/null 2>&1
deactivate

## install sabnzbd
app="sabnzbd"
installdir="$HOME/.bin/sabnzbd"
datadir="$HOME/.config/sabnzbd"
kill -9 $(pgrep -f -u ${USERNAME} "${app}") > /dev/null 2>&1
python3 -m venv ${installdir}
cd ${installdir}
echo "Downloading...${app^^}"
wget ${SABNZBD_URL} -O ${app}.tar.gz > /dev/null 2>&1
mkdir ${app}
tar -xf "${app}.tar.gz" -C ${app} --strip-components=1 > /dev/null 2>&1
rm "${app}.tar.gz" > /dev/null 2>&1
echo "Installation files downloaded and extracted"
source ${installdir}/bin/activate
python -m pip install -U pip > /dev/null 2>&1 
python3 -m pip install -r ${installdir}/${app}/requirements.txt > /dev/null 2>&1 
deactivate
echo "${app^^} Installed"
echo "configuring ${app^^}"
if [ ! -f $datadir/${app}.ini ]; then
cat << EOF > $datadir/${app}.ini
[misc]
port = 8080
url_base = /sabnzbd
host_whitelist = $hostname
EOF
fi
sed -i -E "s#(url_base = ).*#\1/public-${USERNAME}/${app}#" $datadir/${app}.ini
sed -i -E "s#^(port = ).*#\1${SABNZBD_PORT}#" $datadir/${app}.ini
sed -i -E "s#^(host_whitelist = ).*#\1$(hostname)#" $datadir/${app}.ini
echo "${app^^} configured"

## install radarr
app="radarr"
installdir="$HOME/.bin"
datadir="$HOME/.config/${app}"
branch="master"
ARCH=$(dpkg --print-architecture)
kill -9 $(pgrep -f -u ${USERNAME} "${app^}") > /dev/null 2>&1
# get arch
dlbase="https://$app.servarr.com/v1/update/$branch/updatefile?os=linux&runtime=netcore"
case "$ARCH" in
"amd64") DLURL="${dlbase}&arch=x64" ;;
"armhf") DLURL="${dlbase}&arch=arm" ;;
"arm64") DLURL="${dlbase}&arch=arm64" ;;
*)
    echo "Arch not supported"
    exit 1
    ;;
esac
echo ""
echo "Downloading...${app^^}"
cd ${installdir}
wget --content-disposition "$DLURL" > /dev/null 2>&1
tar -xvzf ${app^}.*.tar.gz > /dev/null 2>&1
rm ${app^}.*.tar.gz > /dev/null 2>&1
echo "Installation files downloaded and extracted"
touch "$datadir"/update_required
echo "${app^^} Installed"
echo "configuring ${app^^}"
#tmux new-session -d -s "${app}" "$installdir/${app^}/${app^} -nobrowser -data=$datadir"
#sleep 10
#kill $(lsof -t -i :7878) &> /dev/null || true
if [ ! -f $datadir/config.xml ]; then
cat << EOF > $datadir/config.xml
<Config>
  <UrlBase></UrlBase>
  <Port>7878</Port>
  <BindAddress>*</BindAddress>
</Config>
EOF
fi
sed -i -e "s/\(<Port>\)[^<]*\(<\/Port>\)/\1$RADARR_PORT\2/g" $datadir/config.xml
sed -i -e "s/\(<UrlBase>\)[^<]*\(<\/UrlBase>\)/\1\/public-${USERNAME}\/${app}\2/g" $datadir/config.xml 
sed -i -e "s/\(<BindAddress>\)[^<]*\(<\/BindAddress>\)/\1127.0.0.1\2/g" $datadir/config.xml
echo "${app^^} configured"


## install prowlarr
app="prowlarr"
installdir="$HOME/.bin"
datadir="$HOME/.config/${app}"
branch="develop"
ARCH=$(dpkg --print-architecture)
kill -9 $(pgrep -f -u ${USERNAME} "${app^}") > /dev/null 2>&1
# get arch
dlbase="https://$app.servarr.com/v1/update/$branch/updatefile?os=linux&runtime=netcore"
case "$ARCH" in
"amd64") DLURL="${dlbase}&arch=x64" ;;
"armhf") DLURL="${dlbase}&arch=arm" ;;
"arm64") DLURL="${dlbase}&arch=arm64" ;;
*)
    echo "Arch not supported"
    exit 1
    ;;
esac
echo ""
echo "Downloading...${app^^}"
cd ${installdir}
wget --content-disposition "$DLURL" > /dev/null 2>&1
tar -xvzf ${app^}.*.tar.gz > /dev/null 2>&1
rm ${app^}.*.tar.gz > /dev/null 2>&1
echo "Installation files downloaded and extracted"
touch "$datadir"/update_required
echo "${app^^} Installed"
echo "configuring ${app^^}"
if [ ! -f $datadir/config.xml ]; then
cat << EOF > $datadir/config.xml
<Config>
  <UrlBase></UrlBase>
  <Port>9696</Port>
  <BindAddress>*</BindAddress>
</Config>
EOF
fi
sed -i -e "s/\(<Port>\)[^<]*\(<\/Port>\)/\1$PROWLARR_PORT\2/g" $datadir/config.xml
sed -i -e "s/\(<UrlBase>\)[^<]*\(<\/UrlBase>\)/\1\/public-${USERNAME}\/${app}\2/g" $datadir/config.xml 
sed -i -e "s/\(<BindAddress>\)[^<]*\(<\/BindAddress>\)/\1127.0.0.1\2/g" $datadir/config.xml
echo "${app^^} configured"


## install sonarr
app="sonarr"
installdir="$HOME/.bin"
datadir="$HOME/.config/${app}"
branch="main"
ARCH=$(dpkg --print-architecture)
kill -9 $(pgrep -f -u ${USERNAME} "${app^}") > /dev/null 2>&1
# get arch
dlbase="https://services.$app.tv/v1/download/$branch/latest?version=3&os=linux&runtime=netcore"
ARCH=$(dpkg --print-architecture)
case "$ARCH" in
"amd64") DLURL="${dlbase}&arch=x64" ;;
"armhf") DLURL="${dlbase}&arch=arm" ;;
"arm64") DLURL="${dlbase}&arch=arm64" ;;
*)
    echo "Arch not supported"
    exit 1
    ;;
esac
echo ""
echo "Downloading...${app^^}"
cd ${installdir}
wget --content-disposition "$DLURL" > /dev/null 2>&1
tar -xvzf ${app^}.*.tar.gz > /dev/null 2>&1
rm ${app^}.*.tar.gz > /dev/null 2>&1
echo "Installation files downloaded and extracted"
touch "$datadir"/update_required
echo "${app^^} Installed"
echo "configuring ${app^^}"
if [ ! -f $datadir/config.xml ]; then
cat << EOF > $datadir/config.xml
<Config>
  <Port>8989</Port>
  <UrlBase></UrlBase>
  <BindAddress>*</BindAddress>
</Config>
EOF
fi
sed -i -e "s/\(<Port>\)[^<]*\(<\/Port>\)/\1$SONARR_PORT\2/g" $datadir/config.xml
sed -i -e "s/\(<UrlBase>\)[^<]*\(<\/UrlBase>\)/\1\/public-${USERNAME}\/${app}\2/g" $datadir/config.xml 
#sed -i -e "s/\(<BindAddress>\)[^<]*\(<\/BindAddress>\)/\1127.0.0.1\2/g" $datadir/config.xml
echo "${app^^} configured"


## Jellyfin

## installing aspnetcore
app="aspnetcore"
echo ""
echo "downloading...${app^^}"
echo "to update find latest link from https://dotnet.microsoft.com/en-us/download/dotnet/5.0"
installdir="$HOME/.bin/dotnet"
mkdir -p ${installdir}
cd ${installdir}
wget $ASPDOTNET_URL > /dev/null 2>&1
tar -xvzf *.tar.gz > /dev/null 2>&1
rm *.tar.gz > /dev/null 2>&1
echo "export DOTNET_ROOT=$HOME/.bin/dotnet" >> $HOME/.bashrc
export DOTNET_ROOT=$HOME/.bin/dotnet
echo "Installation files downloaded and extracted"
echo "${app^^} Installed"


## installing jellyfin
app="jellyfin"
installdir="$HOME/.bin"
datadir="$HOME/.config/${app}"
cd ${installdir}
echo ""
echo "Downloading...${app^^}"
wget "https://repo.jellyfin.org/releases/server/portable/stable/combined/${app}_${JELLYFIN_VERSION}.tar.gz" -O ${app}.tar.gz> /dev/null 2>&1
mkdir ${app}
tar -xvzf ${app}.tar.gz -C ${app} --strip-components=2 > /dev/null 2>&1
rm ${app}.tar.gz > /dev/null 2>&1
echo "Installation files downloaded and extracted"
echo "${app^^} Installed"
echo "configuring ${app^^}"
if [ ! -f $datadir/network.xml ]; then
cat << EOF > $datadir/network.xml 
<?xml version="1.0" encoding="utf-8"?>
<NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <EnableUPnP>false</EnableUPnP>
  <PublicPort>8096</PublicPort>
  <UPnPCreateHttpPortMap>false</UPnPCreateHttpPortMap>
  <UDPPortRange />
  <EnableIPV6>false</EnableIPV6>
  <EnableIPV4>true</EnableIPV4>
  <EnableSSDPTracing>false</EnableSSDPTracing>
  <SSDPTracingFilter />
  <UDPSendCount>2</UDPSendCount>
  <UDPSendDelay>100</UDPSendDelay>
  <IgnoreVirtualInterfaces>true</IgnoreVirtualInterfaces>
  <VirtualInterfaceNames>vEthernet*</VirtualInterfaceNames>
  <GatewayMonitorPeriod>60</GatewayMonitorPeriod>
  <TrustAllIP6Interfaces>false</TrustAllIP6Interfaces>
  <HDHomerunPortRange />
  <PublishedServerUriBySubnet />
  <AutoDiscoveryTracing>false</AutoDiscoveryTracing>
  <AutoDiscovery>true</AutoDiscovery>
  <PublicHttpsPort>8920</PublicHttpsPort>
  <HttpServerPortNumber>8096</HttpServerPortNumber>
  <HttpsPortNumber>8920</HttpsPortNumber>
  <EnableHttps>false</EnableHttps>
  <CertificatePath />
  <CertificatePassword />
  <EnableRemoteAccess>true</EnableRemoteAccess>
  <BaseUrl />
  <LocalNetworkSubnets />
  <LocalNetworkAddresses />
  <RequireHttps>false</RequireHttps>
  <RemoteIPFilter />
  <IsRemoteIPFilterBlacklist>false</IsRemoteIPFilterBlacklist>
  <KnownProxies />
</NetworkConfiguration>
EOF
fi
sed -i -e "s/\(<PublicPort>\)[^<]*\(<\/PublicPort>\)/\1$JELLYFIN_PORT\2/g" $datadir/network.xml
sed -i -e "s/\(<HttpServerPortNumber>\)[^<]*\(<\/HttpServerPortNumber>\)/\1$JELLYFIN_PORT\2/g" $datadir/network.xml
sed -i -e "s/<BaseUrl \/>/<BaseUrl><\/BaseUrl>/" $datadir/network.xml 
sed -i -e "s/\(<BaseUrl>\)[^<]*\(<\/BaseUrl>\)/\1\/public-${USERNAME}\/${app}\2/g" $datadir/network.xml 
echo "${app^^} configured"
echo ""

cat << 'EOF' >> $HOME/.bashrc
alias jellyfin='tmux new-session -d -s "jellyfin" "export DOTNET_ROOT=$HOME/.bin/dotnet && export JELLYFIN_DATA_DIR=$HOME/.config/jellyfin && JELLYFIN_LOG_DIR=$HOME/.config/jellyfin/log && nice -n 19 sh -c $HOME/.bin/jellyfin/jellyfin"'
alias sonarr='tmux new-session -d -s "sonarr" "mono $HOME/.bin/Sonarr/Sonarr.exe --data=$HOME/.config/sonarr; exec $SHELL"'
alias radarr='tmux new-session -d -s "radarr" "$HOME/.bin/Radarr/Radarr -nobrowser -data=$HOME/.config/radarr; exec $SHELL"'
alias prowlarr='tmux new-session -d -s "prowlarr" -n "prowlarr" "$HOME/.bin/Prowlarr/Prowlarr -nobrowser -data=$HOME/.config/prowlarr; exec $SHELL"'
alias cloudplow='tmux new-session -d -s "cloudplow" "source $HOME/.bin/cloudplow/bin/activate && python3 $HOME/.bin/cloudplow/cloudplow/cloudplow.py run --config=$HOME/.config/cloudplow/config.json --loglevel=DEBUG --cachefile=$HOME/.config/cloudplow/cache.db --logfile=$HOME/.config/cloudplow/cloudplow.log"'
alias sabnzbd='tmux new-session -d -s "sabnzbd" "source $HOME/.bin/sabnzbd/bin/activate && /usr/bin/nice -n 19 python3 $HOME/.bin/sabnzbd/sabnzbd/SABnzbd.py -b 0 -f $HOME/.config/sabnzbd/sabnzbd.ini"'
EOF


cat << EOF > $HOME/.lighttpd/custom
\$HTTP["url"] =~ "^/sabnzbd($|/)" {
  proxy.server = ( "" => ( (
    "host" => "127.0.0.1",
    "port" => $SABNZBD_PORT
  ) ) ),
  proxy.forwarded = (
    "for" => 1,
    "host" => 1,
    "by" => 1
  ),
  proxy.header = ( "map-urlpath" => (
    "/sabnzbd" => "/public-$USERNAME/sabnzbd"
  ) )
}

\$HTTP["url"] =~ "^/radarr($|/)" {
  proxy.server = ( "" => ( (
    "host" => "127.0.0.1",
    "port" => $RADARR_PORT
  ) ) ),
  proxy.forwarded = (
    "for" => 1,
    "host" => 1,
    "by" => 1
  ),
  proxy.header = ( "map-urlpath" => (
    "/radarr" => "/public-$USERNAME/radarr"
  ) )
}

\$HTTP["url"] =~ "^/prowlarr($|/)" {
  proxy.server = ( "" => ( (
    "host" => "127.0.0.1",
    "port" => $PROWLARR_PORT
  ) ) ),
  proxy.forwarded = (
    "for" => 1,
    "host" => 1,
    "by" => 1
  ),
  proxy.header = ( "map-urlpath" => (
    "/prowlarr" => "/public-$USERNAME/prowlarr"
  ) )
}

\$HTTP["url"] =~ "^/sonarr($|/)" {
  proxy.server  = ( "" => ( (
    "host" => "127.0.0.1",
    "port" => $SONARR_PORT
  ) ) ),
  proxy.forwarded = (
    "for" => 1,
    "host" => 1,
    "by" => 1
  ),
  proxy.header = ( "map-urlpath" => (
    "/sonarr" => "/public-$USERNAME/sonarr"
  ) )
}

\$HTTP["url"] =~ "^/jellyfin($|/)" {
  proxy.server = ( "" =>  ( (
    "host" => "127.0.0.1",
    "port" => $JELLYFIN_PORT
  ) ) ),
  proxy.forwarded = (
    "for" => 1,
    "host" => 1,
    "by" => 1
  ),
  proxy.header = ( "map-urlpath" => (
    "/jellyfin" => "/public-$USERNAME/jellyfin"
  ) )
}
EOF

source ~/.bashrc

echo ""
echo "starting applications"
tmux new-session -d -s "jellyfin" "export DOTNET_ROOT=$HOME/.bin/dotnet && export JELLYFIN_DATA_DIR=$HOME/.config/jellyfin && JELLYFIN_LOG_DIR=$HOME/.config/jellyfin/log && nice -n 19 sh -c $HOME/.bin/jellyfin/jellyfin"
tmux new-session -d -s "sonarr" "mono $HOME/.bin/Sonarr/Sonarr.exe --data=$HOME/.config/sonarr; exec $SHELL"
tmux new-session -d -s "radarr" "$HOME/.bin/Radarr/Radarr -nobrowser -data=$HOME/.config/radarr; exec $SHELL"
tmux new-session -d -s "prowlarr" -n "prowlarr" "$HOME/.bin/Prowlarr/Prowlarr -nobrowser -data=$HOME/.config/prowlarr; exec $SHELL"
tmux new-session -d -s "sabnzbd" "source $HOME/.bin/sabnzbd/bin/activate && /usr/bin/nice -n 19 python3 $HOME/.bin/sabnzbd/sabnzbd/SABnzbd.py -b 0 -f $HOME/.config/sabnzbd/sabnzbd.ini"

echo ""
echo "connect to running application use command 'tmux attach -t <app-name>'"
echo "e.g to attach to radarr 'tmux attach -t radarr'"
echo "exit tmux session by pressing 'CTRL+b' then 'a' "
echo ""
echo "to start application manually use appname as commend"
echo "e.g for SONARR use 'sonarr'"
echo ""
echo "RADARR-URL = https://$(hostname)/public-$USERNAME/radarr/"
echo "SONARR-URL = https://$(hostname)/public-$USERNAME/sonarr/"
echo "PROWLARR-URL = https://$(hostname)/public-$USERNAME/prowlarr/"
echo "SABNZBD-URL = https://$(hostname)/public-$USERNAME/sabnzbd/"
echo "SABNZBD-WIZARD-URL = https://$(hostname)/public-$USERNAME/sabnzbd/wizard/"
echo "JELLYFIN-URL = https://$(hostname)/public-$USERNAME/jellyfin/web/index.html"
echo "JELLYFIN-ALTERNATE-URL" = $(curl -s ifconfig.me):$JELLYFIN_PORT/public-$USERNAME/jellyfin/
echo ""
echo "restarting lighttpd"
killall -9 -u $(whoami) lighttpd; killall -9 -u $(whoami) php-cgi
echo "it may take 1-2 minutes to restart lighttpd"
