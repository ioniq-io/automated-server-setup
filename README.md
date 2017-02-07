# Automated setup for initial deployment and crash recovery

This project was designed to be an automation solution for a range of server setup and crash recovery.

More options will be added. 
NodeJS is fully supported (Nodejs server, NGINX proxy, PM2 service manager, SSl auto registration and setup)
dotnet core is mostly supported (dotnet core server, NGINX proxy, PM2 service manager, SSl not available yet)

Available setup:

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
    
    cd automated-server-setup/setup/
    chmod +x build.sh
    
    ./build.sh [OPTIONS/FLAGS]

# Restart services on server reboot:

    sudo pm2 resurrect

# Options:

    TODO