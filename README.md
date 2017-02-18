# Automated setup for initial deployment and crash recovery

This project was designed to be an automation solution for a range of server setup and crash recovery.

More options will be added. 

NodeJS is fully supported (Nodejs server, NGINX proxy, PM2 service manager, SSl auto registration and setup)

Dotnet is fully supported (dotnet core server, NGINX proxy, PM2 service manager, SSl auto registration and setup)

Available setup:

Ubuntu 16.04 (More OS will be suported at a later date.):

    - Automatic NodeJS server
        - NGINX reverse proxy (Required)
        - PM2 Service Manager (Required)
        - SSL Registration and Setup (Optional)

    - Automatic dotnet core server
        - NGINX reverse proxy (Required)
        - PM2 Service manager (Required)
        - SSL Registration and Setup (Under development)
        
# How to use:

    cd ~
    git clone https://github.com/ioniq-io/automated-server-setup.git
    
    cd automated-server-setup/
    chmod +x build.sh
    
    update configuration file for your requirements (config.cfg)
    
    ./build.sh

# Restart services on server reboot:

    sudo pm2 resurrect

# Options:

    TODO
