# Automated setup for initial deployment and crash recovery

This project was designed to be an automation solution for a range of server setup and crash recovery.

Available setup:

    - Automatic NodeJS server
        - NGINX reverse proxy (Required)
        - PM2 Service Manager (Recommended)
        - SSL Registration and Setup (Optional)

    - Automatic dotnet core server (Under work under dotNetCoreSetup branch)
        - NGINX reverse proxy (Required)
        - Service manager (To be determined)
        - SSL Registration and Setup (Optional)
        
# How to use:
    cd ~
    git clone https://github.com/ioniq-io/automated-server-setup.git
    
    cd automated-server-setup/setup/
    chmod +x build.sh
    
    ./build.sh [OPTIONS/FLAGS]

# Options:

    TODO
