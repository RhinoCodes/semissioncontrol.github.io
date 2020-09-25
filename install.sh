# Functions
function installDirectory {
    # Create /semc
    mkdir /semc

    mkdir /semc/bin
    echo 'export PATH=$PATH:/semc/bin' >> ~/.bashrc
    echo "Updated PATH"

    # Clone core
    mkdir /semc/src
    cd /semc/src
    git clone https://github.com/semissioncontrol/core
}

# Version
echo "SEMC installer v0.1.0"

# Confirmation from user
read -p "Install SEMC on this device? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo

# Sanity checks
wget -q --spider http://github.com

if [ $? -eq 0 ]; then
    echo "Good: Internet Connection found."
else
    echo "Error: Internet Connection not found!"
    exit
fi

if [ "$EUID" -ne 0 ]
  then echo "Error: Please run as root."
  exit
fi
echo "Good: Root access found"

# Check if semcOS is being used
if ! command -v semc-install &> /dev/null
then
    read -p "semcOS not found. Proceed to install on this OS? " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
    
    # semcOS is not being used, but user wants to proceed
    installDirectory
    
    # Initialize core installer
    bash /semc/src/core/actions/install/installer.sh

    exit 0
fi

# User is indeed using semcOS
xbps-install -Suv
installDirectory
bash /semc/src/core/actions/install/installer.sh
