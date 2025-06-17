ICT171 Cloud WordPress Server Project

Student Name: Tyrone Steele
Student ID: 35500984

Live Server URL: https://thepottersclay.com.au/
Global IP Address: 54.206.238.201
Server Recording Explainer: https://youtu.be/2IQlAw7lDHk

Project Overview:

This repository is my last-ditched effort attempt to make a functioning server, knowing I'll potentially loose marks for non-creativity. My original plan was to have a server running apache2 and nginx as a reverse proxy because running wordpress with the ability to run static&dynamic content seamlessly is brilliant. However, after being stuck in troubleshooting loops for 3 days, I made the executove decision to restart, the simple route (probably where I should've started), using just nginx.
I could, and probably will go back and configure apache later. For now however, I must submit where I'm at because time has run short.
In my eyes this is an absolute dissapointment of an assignment AND a server, maybe thats just my expectations, maybe it's reality, I'll find out when I have my marks.
Thank you James for making this semester great!

1. AWS EC2 Instance & Initial Server Setup

This phase details the provisioning of the virtual server instance and its foundational operating system configuration.
1.1 AWS EC2 Instance 

    Purpose: To create the virtual server (EC2 instance) that will host the WordPress website.
    Actions:
        Launched an EC2 instance via the AWS Management Console.
        Selected Ubuntu Server 24.04 LTS (HVM), SSD Volume Type as the Amazon Machine Image (AMI) and t2.micro as the instance type (Free Tier eligible).
        Created a new Key Pair (ICT171-key) for secure SSH access and downloaded the .pem file.
        Configured network settings, creating a new Security Group (WordPress-ICT171).
        Defined Inbound Security Group Rules to allow:
            SSH (Port 22) from 0.0.0.0/0 for initial setup (Security reasons dictate that I should change to My IP only post-setup).
            HTTP (Port 80) from 0.0.0.0/0 .
            HTTPS (Port 443) from 0.0.0.0/0 .
  ![image](https://github.com/user-attachments/assets/b9587a35-8f61-4492-b24f-78317b09735c)

    

1.2 Initial Server Setup & OS Updates

    Purpose: To establish secure shell (SSH) connectivity to the newly launched EC2 instance and update its operating system packages to the latest versions.
  
    # SSH into EC2 instance 
    ssh -i "ICT171.pem" ubuntu@ec2-54-206-238-201.ap-southeast-2.compute.amazonaws.com

    # Update System Packages (Good practice and ensures that systems ecurity is up-to-date)
    sudo apt update
    sudo apt upgrade -y

1.3 Create Website Document Root Directory

    Purpose: To establish the dedicated directory structure (/var/www/html/yourdomain.com/public) where the WordPress website files will reside and to set the appropriate ownership for the web server processes.
 

    # Create the directory structure 
    sudo mkdir -pv /var/www/html/thepottersclay.com.au/public

    # Set initial ownership for the web server user (www-data)
    sudo chown -R www-data:www-data /var/www/html/thepottersclay.com.au

  ![image](https://github.com/user-attachments/assets/75789ecf-a2ab-4826-a53e-765e20eb585f)
    

2. DNS (Elastic IP & Route 53) Setup

This section includes the configuration of the DNS to point toward the domain (thepottersclay.com.au)
2.1 Assigning a Static Elastic IP Address

    Purpose: To ensure your EC2 instance has a static, unchanging public IP address, which is crucial for reliable domain name resolution.
    Actions:
        Access the EC2 Dashboard in the AWS Management Console.
        Navigate to "Elastic IPs" under "Network & Security".
        Allocate a new Elastic IP address.
        Associate the newly allocated Elastic IP with the EC2 instance.
  ![image](https://github.com/user-attachments/assets/210f852b-aefc-4717-be1f-2c94fc248581)

2.2 Creating a Hosted Zone in Route 53

    Purpose: To create a container within AWS's highly available DNS service where your domain's DNS records will be managed.
    Actions:
        Navigate to Route 53 in the AWS Management Console.
        Click "Create hosted zone".
        Enter thepottersclay.com.au as the domain name and selected "Public hosted zone".
        Record the four unique Name Server (NS) addresses provided by Route 53 for the new hosted zone.
  ![image](https://github.com/user-attachments/assets/7b5dbb93-591d-4740-b015-745481ca5d2b)


2.3 Updating Squarespace Name Servers

    Purpose: To instruct all internet DNS resolvers that Amazon Route 53, and not Squarespace, is the authoritative source for your domain's DNS information.
    Actions:
        Logged into the Squarespace account and navigated to domain management for thepottersclay.com.au.
        Located the Name Server settings within Squarespace.
        Deleted any existing Squarespace default Name Servers.
        Carefully entered the four Name Server addresses obtained from Route 53 (from Step 2.2).
        Deleted any conflicting default Squarespace A or CNAME records to ensure full delegation.
  ![image](https://github.com/user-attachments/assets/474f3870-f694-4d32-8e07-0f93a3b1c18f)


2.4 Configuring DNS Records (A and CNAME) in Route 53

    Purpose: To define how requests for your domain (thepottersclay.com.au) and its 'www' subdomain will be routed to your EC2 instance's Elastic IP.
    Actions:
        Accessed the thepottersclay.com.au Hosted Zone in Route 53.
        Created an 'A' record for the root domain (leaving the name blank) pointing to the EC2 instance's Elastic IP address.
        Created a 'CNAME' record for the 'www' subdomain pointing to thepottersclay.com.au.
  ![image](https://github.com/user-attachments/assets/cc39ccfe-4096-4fac-a1f8-1ef3a0ca13bf)


2.5 Verifying Global DNS Propagation

    Purpose: To confirm that the domain name is successfully resolving across the internet to the Elastic IP address.
    Actions:
        Use dnschecker.or to verify global propagation of the Name Server (NS) and 'A' records.
        Clear browser cache and flush local DNS (ipconfig /flushdns).
        Access http://thepottersclay.com.au in a web browser(Chrome, Firefox, Edge, Brave, OperaGX).
    Expected Result: "Unable to connect" error will show but this tells that the DNS is working, we just don't have a webserver (yet).
  ![image](https://github.com/user-attachments/assets/bc0c3f42-57f5-4ada-9b18-0db7e3df85ea)
  ![image](https://github.com/user-attachments/assets/dba99839-f912-49ef-9e2d-5eb94b3473c9)

3. Database (MariaDB) Setup

This phase establishes the MariaDB database server (WordPress will utilize this for data storage).
3.1 Install MariaDB Server

    Purpose: To install the MariaDB database server.


    sudo apt update
    sudo apt install mariadb-server mariadb-client -y

    Outputs: Expected installation confirmation.
  ![image](https://github.com/user-attachments/assets/86da4932-a67d-4c27-863b-e06c89e7631e)

3.2 Secure MariaDB Installation

    Purpose: To enhance the security of the MariaDB installation by configuring a root password (optional for Ubuntu), removing default insecure configurations, and tightening access.


    sudo mysql_secure_installation

    Actions: Follow prompts:
        Press ENTER for the current root password (as it's a new installation).
        Type N and press ENTER when asked "Set root password?" (as recommended by Ubuntu for system integration).
        Type Y and press ENTER for all subsequent security questions (removing anonymous users, disallowing remote root logins, removing test database, reloading privileges).


3.3 Create WordPress Database and User

    Purpose: To create a dedicated database for WordPress and a specific database user with appropriate privileges to interact with it.


    sudo mariadb -u root
    # (Enter MariaDB root password if set, otherwise press Enter)
    CREATE DATABASE YOUR_WORDPRESS_DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
    CREATE USER 'YOUR_WORDPRESS_USER'@'localhost' IDENTIFIED BY 'YOUR_WORDPRESS_PASSWORD';
    GRANT ALL PRIVILEGES ON YOUR_WORDPRESS_DB_NAME.* TO 'YOUR_WORDPRESS_USER'@'localhost';
    FLUSH PRIVILEGES;
    EXIT;

    Outputs: Expected SQL query confirmation messages (e.g., "Query OK").
    Important Note: Securely record YOUR_WORDPRESS_DB_NAME, YOUR_WORDPRESS_USER, and YOUR_WORDPRESS_PASSWORD. They are integral to WordPress install.
   ![Screenshot 2025-06-17 141416](https://github.com/user-attachments/assets/fc236f35-6147-48f1-946f-0c51932070bb)

4. Web Server (Nginx) & PHP 8.3 Setup

This phase installs and configures Nginx and PHP-FPM, forming the core web server stack for WordPress.
4.1 Install Nginx

    Purpose: To install the high-performance Nginx web server.
 

    sudo apt install nginx -y

    Outputs: Expected installation confirmation.
  ![Screenshot 2025-06-17 141441](https://github.com/user-attachments/assets/e4fcb694-ef09-4a93-be31-9b89919728c7)
  

4.2 Install PHP 8.3 (with PHP-FPM) and Extensions

    Purpose: To install the PHP interpreter (PHP-FPM) and necessary PHP extensions that WordPress requires for its functionality.
 

    sudo apt install php8.3 php8.3-fpm php8.3-mysql php8.3-cli php8.3-curl php8.3-gd php8.3-mbstring php8.3-xml php8.3-xmlrpc php8.3-soap php8.3-intl php8.3-zip unzip -y

    Outputs: Expected installation confirmation.
  ![Screenshot 2025-06-17 141624](https://github.com/user-attachments/assets/7ed128eb-567b-4e06-b3f9-7cdb831de622)
  

4.3 Configure Nginx Global Settings

    Purpose: To apply global optimizations for Nginx's performance and security, including setting up the FastCGI caching zone.
  

sudo nano /etc/nginx/nginx.conf

Actions: Inside the http { ... } block, uncomment, adjust, or add the following directives:

    worker_processes auto;
    multi_accept on;
    keepalive_timeout 15;
    server_tokens off;
    client_max_body_size 64m;
    gzip on;
    gzip_proxied any;
    gzip_comp_level 2;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    Add FastCGI cache path and key (CRITICAL for PHP performance):
    Nginx

        fastcgi_cache_path /usr/share/nginx/fastcgi_cache levels=1:2 keys_zone=phpcache:100m max_size=10g inactive=60m use_temp_path=off;
        fastcgi_cache_key "$scheme$request_method$host$request_uri";

  ![image](https://github.com/user-attachments/assets/778a18ed-73ef-4c05-b165-8c923688ee26)
  ![image](https://github.com/user-attachments/assets/5ca7e4e7-d312-49f6-9f60-3c7b3f991b42)


4.4 Configure Nginx Catch-All Block

    Purpose: To define how Nginx handles requests that do not match any specific server_name, ensuring these requests (like direct IP access) are redirected to HTTPS.
    

sudo nano /etc/nginx/nginx.conf

Actions: Locate the default_server block within nginx.conf and ensure it's configured EXACTLY as follows:


    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name _; # This catches requests that don't match other server_names

        # Permanent redirect all HTTP requests on this default server to (https://thepottersclay.com.au)
        return 301 https://thepottersclay.com.au$request_uri; 
    }

  ![image](https://github.com/user-attachments/assets/7b8c1d31-62b5-419f-aba0-be7b8dcd278c)


4.5 Configure Nginx Site for WordPress

    Purpose: To define how Nginx serves your thepottersclay.com.au domain, handling static files and passing PHP requests to PHP-FPM.
   

sudo rm -f /etc/nginx/sites-available/default
sudo rm -f /etc/nginx/sites-enabled/default
sudo nano /etc/nginx/sites-available/thepottersclay.com.au.conf

Actions: Ensure that this is what your file looks like (make neccessary changes)


    server {
        listen 80;
        listen [::]:80;
        server_name thepottersclay.com.au www.thepottersclay.com.au;
        root /var/www/html/thepottersclay.com.au/public;
        index index.php index.html index.htm;

        charset utf-8;

        # Protect .user.ini files
        location ~ ^/\.user\.ini {
            deny all;
        }

        # Handle static SVG files
        location ~* \.(svg|svgz)$ {
            types {}
            default_type image/svg+xml;
        }

        # Handle favicon and robots.txt
        location = /favicon.ico {
            log_not_found off;
            access_log off;
        }
        location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
        }

        # Pass PHP requests to PHP-FPM (TCP Socket)
        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass 127.0.0.1:9000; # <<< IMPORTANT: USE TCP SOCKET AS PREVIOUSLY RESOLVED
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;

            fastcgi_cache phpcache;
            fastcgi_cache_valid 200 301 302 60m;
            fastcgi_cache_use_stale error timeout updating invalid_header http_500 http_503;
            fastcgi_cache_min_uses 1;
            fastcgi_cache_lock on;
            add_header X-FastCGI-Cache $upstream_cache_status;
        }

        # WordPress permalinks (handle missing files by passing to index.php)
        location / {
            try_files $uri $uri/ /index.php?$args;
        }

        # Deny access to hidden files
        location ~ /\. {
            deny all;
            access_log off;
            log_not_found off;
        }
    }

  ![image](https://github.com/user-attachments/assets/2cad2ad7-4c8e-4b7b-b114-488aad8c6dd7)


4.6 Enable and Test Nginx Configuration

    Purpose: To activate the WordPress site configuration and verify its syntax.


    sudo ln -s /etc/nginx/sites-available/thepottersclay.com.au.conf /etc/nginx/sites-enabled/thepottersclay.com.au.conf
    sudo nginx -t
    sudo systemctl restart nginx

    Outputs: Expected "syntax is ok" and "test is successful" outputs, and successful service restart.
  ![Screenshot 2025-06-17 144441](https://github.com/user-attachments/assets/8e028077-9c9c-4040-8e1a-eb484b857f1a)


4.7 Test Nginx and PHP-FPM Functionality

    Purpose: To confirm Nginx correctly serves files and passes PHP requests to PHP-FPM, verifying phpinfo() displays.
 

    sudo nano /var/www/html/thepottersclay.com.au/public/test.php
    Add: <?php phpinfo(); ?> 
    Save and Exit
    sudo chown www-data:www-data /var/www/html/thepottersclay.com.au/public/test.php
    sudo chmod 644 /var/www/html/thepotpottersclay.com.au/public/test.php

    Actions:
        Clear browser cache.
        Navigate to http://thepottersclay.com.au/test.php in a web browser.
    Expected Result: The phpinfo() page displays successfully.


5. WordPress Core Installation
5.1 Download and Extract WordPress

        Purpose: To place the WordPress core files into your document root.
        
        cd /tmp
        sudo rm -rf wordpress/ # Clean up /tmp/wordpress if it exists
        wget https://wordpress.org/latest.zip
        sudo unzip latest.zip
        sudo mv wordpress/* /var/www/html/thepottersclay.com.au/public/
        sudo rm -rf wordpress # Clean up empty directory in /tmp
    
        Outputs: Expected successful download, extraction, and move.
   ![image](https://github.com/user-attachments/assets/5bd2c383-06a8-43cd-a6b6-f0825cee4a33)


5.2 Configure WordPress wp-config.php

    Purpose: To configure WordPress with database credentials and proxy awareness.
    

    cd /var/www/html/thepottersclay.com.au/public/
    sudo mv wp-config-sample.php wp-config.php
    sudo nano wp-config.php

Actions:

    Edit Database Settings: Replace placeholders with your MariaDB credentials (DB_NAME, DB_USER, DB_PASSWORD, DB_HOST).
    Add Authentication Unique Keys and Salts (from https://api.wordpress.org/secret-key/1.1/salt/).
    Add Proxy Awareness and URL Definitions (before /* That's all, stop editing! */):



        if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) {
            $_SERVER['HTTPS'] = 'on';
        }
        define('WP_HOME','http://thepottersclay.com.au');
        define('WP_SITEURL','http://thepottersclay.com.au');

  ![image](https://github.com/user-attachments/assets/83cc03b5-234c-4046-a3be-73767b816741)


5.3 Set WordPress File Permissions (Final)

    Purpose: To ensure Nginx and PHP-FPM have proper read/write access for WordPress operation and updates.

    sudo chown -R www-data:www-data /var/www/html/thepottersclay.com.au/public
    sudo find /var/www/html/thepottersclay.com.au/public -type d -exec chmod 755 {} \;
    sudo find /var/www/html/thepottersclay.com.au/public -type f -exec chmod 644 {} \;

    Outputs: Expected permission change outputs.

5.4 Complete WordPress Web-based Installation

    Purpose: To finalize the WordPress setup via the browser.
    Actions:
        Clear browser cache. Flush local DNS.
        Navigate to http://thepottersclay.com.au in a web browser.
        Follow prompts: Language, Site Title, Admin Username/Password, Email.
    Expected Result: WordPress "Success!" screen.
  ![Screenshot 2025-06-16 160657](https://github.com/user-attachments/assets/683c6b6d-2623-48f4-9832-9af44d0ce7ca)

6. SSL/TLS (HTTPS) Installation
6.1 Install Certbot

        Purpose: To install Certbot for managing SSL certificates.
  
        sudo apt install snapd -y
        sudo snap install core
        sudo snap refresh core
        sudo snap install --classic certbot
        sudo ln -s /snap/bin/certbot /usr/bin/certbot
    
        Outputs: Expected installation confirmations.
   ![Screenshot 2025-06-17 163659](https://github.com/user-attachments/assets/5afc5116-489b-41e6-b843-da31fa04b875)


6.2 Obtain and Install SSL Certificate

    Purpose: To get a free SSL certificate for your domain(s) and configure Nginx for HTTPS.
  

    sudo certbot --nginx -d thepottersclay.com.au -d www.thepottersclay.com.au

    Actions: Follow prompts: Email, Agree to ToS, Share email (optional), Redirect HTTP to HTTPS (Option 2).
    Outputs: Expected successful certificate issuance.
  ![Screenshot 2025-06-17 163938](https://github.com/user-attachments/assets/6523890a-d0d0-4812-988a-ad44049bc7c7)


6.3 Configure WordPress for HTTPS

    Purpose: To instruct WordPress to use https:// for its internal links.
 

    sudo nano /var/www/html/thepottersclay.com.au/public/wp-config.php

Actions: Modify WP_HOME and WP_SITEURL to https://.
PHP

    define('WP_HOME','https://thepottersclay.com.au');
    define('WP_SITEURL','https://thepottersclay.com.au');

  ![image](https://github.com/user-attachments/assets/e30f9d6c-4879-469b-899c-a2808bf1746d)


6.4 Verify SSL Certificate and Automatic Renewal

    Purpose: To confirm HTTPS is active and auto-renewal is set up.
  

    sudo systemctl status snap.certbot.renew.service
    sudo certbot renew --dry-run

    Actions: Test https://thepottersclay.com.au in browser.
    Expected Result: Green padlock in browser, certbot renew --dry-run shows success.
  ![image](https://github.com/user-attachments/assets/0d4c00e6-f4bd-4ccd-99f5-929869a7a9cc)
![Screenshot 2025-06-17 164825](https://github.com/user-attachments/assets/547bcfc4-7a0f-4c71-b757-11379bcbca29)


7. Scripting
7.1 Develop Script
Script for backup was heavily inspired by (and with few changes) GitHub User: maheshpalamuttath
https://gist.github.com/maheshpalamuttath/482f1e43bc170d822fc4b19f368cd655



   nano /home/ubuntu/wordpress_backup.sh


   chmod +x /home/ubuntu/wordpress_backup.sh


7.2 Document and Verify Script Output

    Purpose: To prove the script's functionality.
  

    /home/ubuntu/wordpress_backup.sh
    ls -lh /home/ubuntu/backups/
    cat /home/ubuntu/backups/(eg. wp-backup-17-06-2025-10.48.51.log) 

    Outputs: Expected success messages and file listings.
  ![image](https://github.com/user-attachments/assets/9a404a6a-822a-41b1-a1dd-45014a5a8ac2)








