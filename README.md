# Aioz-cli-node

This is a script to automatically install AIOZ edge cli node and configure systemd service


Run script directly:
```
sh "(curl -L https://raw.githubusercontent.com/Karjack182/Aioz-cli-node/main/install.sh)"
```

Uninstall  :
```
sudo systemctl stop aioznode && sudo systemctl disable aioznode
sudo rm -rf /opt/aioznode
```
