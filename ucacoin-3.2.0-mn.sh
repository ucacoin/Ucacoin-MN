#!/bin/bash
# UCACoin Masternode Setup Script V3.2.0 for Ubuntu LTS
#
# Script will attempt to autodetect primary public IP address
# and generate masternode private key unless specified in command line
#
# Usage:
# bash ucacoin.autoinstall.sh
#

#Color codes
RED='\033[0;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#TCP port
PORT=33210
RPC=33211

#Clear keyboard input buffer
function clear_stdin { while read -r -t 0; do read -r; done; }

#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1 seconds...${NC}"; sleep "$1"; }

#Stop daemon if it's already running
function stop_daemon {
    if pgrep -x 'ucacoind' > /dev/null; then
        echo -e "${YELLOW}Attempting to stop ucacoind${NC}"
        ucacoin-cli stop
        sleep 30
        if pgrep -x 'ucacoind' > /dev/null; then
            echo -e "${RED}ucacoind daemon is still running!${NC} \a"
            echo -e "${RED}Attempting to kill...${NC}"
            sudo pkill -9 ucacoind
            sleep 30
            if pgrep -x 'ucacoind' > /dev/null; then
                echo -e "${RED}Can't stop ucacoind! Reboot and try again...${NC} \a"
                exit 2
            fi
        fi
    fi
}

#Process command line parameters
genkey=$1
clear

echo -e "${GREEN} ------- UCACoin MASTERNODE INSTALLER v3.2.0--------+
 |                                                  |
 |                                                  |::
 |       The installation will install and run      |::
 |        the masternode under a user ucacoin.         |::
 |                                                  |::
 |        This version of installer will setup      |::
 |           fail2ban and ufw for your safety.      |::
 |                                                  |::
 +------------------------------------------------+::
   ::::::::::::::::::::::::::::::::::::::::::::::::::S${NC}"
echo "Do you want me to generate a masternode private key for you?[y/n]"
read DOSETUP

if [[ $DOSETUP =~ "n" ]] ; then
          read -e -p "Enter your private key:" genkey;
              read -e -p "Confirm your private key: " genkey2;
    fi

#Confirming match
  if [ $genkey = $genkey2 ]; then
     echo -e "${GREEN}MATCH! ${NC} \a" 
else 
     echo -e "${RED} Error: Private keys do not match. Try again or let me generate one for you...${NC} \a";exit 1
fi
sleep .5
clear

# Determine primary public IP address
dpkg -s dnsutils 2>/dev/null >/dev/null || sudo apt-get -y install dnsutils
publicip=$(dig +short myip.opendns.com @resolver1.opendns.com)

if [ -n "$publicip" ]; then
    echo -e "${YELLOW}IP Address detected:" $publicip ${NC}
else
    echo -e "${RED}ERROR: Public IP Address was not detected!${NC} \a"
    clear_stdin
    read -e -p "Enter VPS Public IP Address: " publicip
    if [ -z "$publicip" ]; then
        echo -e "${RED}ERROR: Public IP Address must be provided. Try again...${NC} \a"
        exit 1
    fi
fi
if [ -d "/var/lib/fail2ban/" ]; 
then
    echo -e "${GREEN}Packages already installed...${NC}"
else
    echo -e "${GREEN}Updating system and installing required packages...${NC}"

sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y install wget nano
sudo apt-get install unzip
fi

#Generating Random Password for  JSON RPC
rpcuser=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

#Create 2GB swap file
if grep -q "SwapTotal" /proc/meminfo; then
    echo -e "${GREEN}Skipping disk swap configuration...${NC} \n"
else
    echo -e "${YELLOW}Creating 2GB disk swap file. \nThis may take a few minutes!${NC} \a"
    touch /var/swap.img
    chmod 600 swap.img
    dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
    mkswap /var/swap.img 2> /dev/null
    swapon /var/swap.img 2> /dev/null
    if [ $? -eq 0 ]; then
        echo '/var/swap.img none swap sw 0 0' >> /etc/fstab
        echo -e "${GREEN}Swap was created successfully!${NC} \n"
    else
        echo -e "${RED}Operation not permitted! Optional swap was not created.${NC} \a"
        rm /var/swap.img
    fi
fi
 
#Installing Daemon
cd ~
rm -rf /usr/local/bin/ucacoin*
wget https://github.com/ucacoin/Ucacoin2/releases/download/v3.2.0/ucacoind-3.2.0-daemon-ubuntu.tar.gz
tar -xzvf ucacoind-3.2.0-daemon-ubuntu.tar.gz
sudo chmod -R 755 ucacoin-cli
sudo chmod -R 755 ucacoind
cp -p -r ucacoind /usr/local/bin
cp -p -r ucacoin-cli /usr/local/bin

 ucacoin-cli stop
 sleep 5
 #Create datadir
 if [ ! -f ~/.ucacoin/ucacoin.conf ]; then 
 	sudo mkdir ~/.ucacoin
 fi

cd ~
clear
echo -e "${YELLOW}Creating ucacoin.conf...${NC}"

# If genkey was not supplied in command line, we will generate private key on the fly
if [ -z $genkey ]; then
    cat <<EOF > ~/.ucacoin/ucacoin.conf
rpcuser=$rpcuser
rpcpassword=$rpcpassword
EOF

    sudo chmod 755 -R ~/.ucacoin/ucacoin.conf

    #Starting daemon first time just to generate masternode private key
    ucacoind -daemon
sleep 7
while true;do
    echo -e "${YELLOW}Generating masternode private key...${NC}"
    genkey=$(ucacoin-cli createmasternodekey)
    if [ "$genkey" ]; then
        break
    fi
sleep 7
done
    fi
    
    #Stopping daemon to create ucacoin.conf
    ucacoin-cli stop
    sleep 5
cd ~/.ucacoin/ && rm -rf blocks chainstate sporks
cd ~/.ucacoin/ && wget http://95.216.173.155/bootstrap.tar.gz
cd ~/.ucacoin/ && tar -xzvf bootstrap.tar.gz
sudo rm -rf ~/.ucacoin/bootstrap.tar.gz
	
# Create ucacoin.conf
cat <<EOF > ~/.ucacoin/ucacoin.conf
rpcuser=$rpcuser
rpcpassword=$rpcpassword
rpcallowip=127.0.0.1
rpcport=$RPC
port=$PORT
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
masternode=1
externalip=$publicip:$PORT
bind=$publicip:$PORT
masternodeaddr=$publicip:$PORT
masternodeprivkey=$genkey
addnode=167.71.245.49
addnode=178.128.98.125 
addnode=142.93.175.145
addnode=135.181.37.92
addnode=95.217.21.41


 
EOF
    ucacoind -daemon
#Finally, starting daemon with new ucacoin.conf
printf '#!/bin/bash\nif [ ! -f "~/.ucacoin/ucacoin.pid" ]; then /usr/local/bin/ucacoind -daemon ; fi' > /root/ucacoinauto.sh
chmod -R 755 /root/ucacoinauto.sh
#Setting auto start cron job for ucacoin
if ! crontab -l | grep "ucacoinauto.sh"; then
    (crontab -l ; echo "*/5 * * * * /root/ucacoinauto.sh")| crontab -
fi

echo -e "========================================================================
${GREEN}Masternode setup is complete!${NC}
========================================================================
Masternode was installed with VPS IP Address: ${GREEN}$publicip${NC}
Masternode Private Key: ${GREEN}$genkey${NC}
Now you can add the following string to the masternode.conf file 
======================================================================== \a"
echo -e "${GREEN}ucacoin_mn1 $publicip:$PORT $genkey TxId TxIdx${NC}"
echo -e "========================================================================
Use your mouse to copy the whole string above into the clipboard by
tripple-click + single-click (Dont use Ctrl-C) and then paste it 
into your ${GREEN}masternode.conf${NC} file and replace:
    ${GREEN}ucacoin_mn1${NC} - with your desired masternode name (alias)
    ${GREEN}TxId${NC} - with Transaction Id from getmasternodeoutputs
    ${GREEN}TxIdx${NC} - with Transaction Index (0 or 1)
     Remember to save the masternode.conf and restart the wallet!
To introduce your new masternode to the ucacoin network, you need to
issue a masternode start command from your wallet, which proves that
the collateral for this node is secured."

clear_stdin
read -p "*** Press any key to continue ***" -n1 -s

echo -e "Wait for the node wallet on this VPS to sync with the other nodes
on the network. Eventually the 'Is Synced' status will change
to 'true', which will indicate a comlete sync, although it may take
from several minutes to several hours depending on the network state.
Your initial Masternode Status may read:
    ${GREEN}Node just started, not yet activated${NC} or
    ${GREEN}Node  is not in masternode list${NC}, which is normal and expected.
"
clear_stdin
read -p "*** Press any key to continue ***" -n1 -s

echo -e "
${GREEN}...scroll up to see previous screens...${NC}
Here are some useful commands and tools for masternode troubleshooting:
========================================================================
To view masternode configuration produced by this script in ucacoin.conf:
${GREEN}cat ~/.ucacoin/ucacoin.conf${NC}
Here is your ucacoin.conf generated by this script:
-------------------------------------------------${GREEN}"
echo -e "${GREEN}ucacoin_mn1 $publicip:$PORT $genkey TxId TxIdx${NC}"
cat ~/.ucacoin/ucacoin.conf
echo -e "${NC}-------------------------------------------------
NOTE: To edit ucacoin.conf, first stop the ucacoind daemon,
then edit the ucacoin.conf file and save it in nano: (Ctrl-X + Y + Enter),
then start the ucacoind daemon back up:
to stop:              ${GREEN}ucacoin-cli stop${NC}
to start:             ${GREEN}ucacoind${NC}
to edit:              ${GREEN}nano ~/.ucacoin/ucacoin.conf${NC}
to check mn status:   ${GREEN}ucacoin-cli getmasternodestatus${NC}
========================================================================
To monitor system resource utilization and running processes:
                   ${GREEN}htop${NC}
========================================================================
"