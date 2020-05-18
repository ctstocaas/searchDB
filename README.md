# SearchDB - A sample three tier application setup
This is a sample three tier application that uses Apache Web Server, Tomcat Application Server and MySQL DB server. 
The application looks like following:

### Home page:
![Home page](https://github.com/ctstocaas/searchDB/blob/master/SampleDB-home.JPG)
### Search result page:
![Search Result](https://github.com/ctstocaas/searchDB/blob/master/SampleDB-Search.JPG)

To setup this application we need to setup servers in following sequence:
1. MySQL Server - Installation and DB creation
2. Tomcat Server - Installation, application deployment and connection to MySQL server
3. Apache Web Server - Installation and connection to Tomcat server

This setup is specifically applicable to Ubuntu 16.04. 

A small VM is sufficient for this setup.

Create three VMs with Ubuntu 16.04 with 10GB storage and minimal CPU and RAM.

# MySQL Server setup
## Step 1: Install MySQL Server
Login to SQL server and execute following command

`$ sudo apt-get update`

`$ sudo apt-get install mysql-server`

If prompted for password enter “Passw0rd” as the password for user ID “root”
Enable MySQL service to start at system reboot:

`$ sudo systemctl restart mysql`
### Enable access to MySQL from remote servers: 
By default the MySQL installation allow connection to the MySQL server from the localhost only. But we need to connect to this server remotely. To enable that, edit the MySQL configuration file /etc/mysql/mysql.conf.d as following:

Find the property “bind-address=xxx.xxx.xxx.xxx” in the file and comment or remove this line.
Save and exit.
Restart MySQL service:

`$ sudo systemctl restart mysql`

## Step 2: Create application databases
Login to MySQL server
Login to MySQL

`$ mysql –p –u root`

`$ Enter Password: ***** (Passw0rd)`

Run following SQL commands on mysql prompt:

```
mysql> create database MyNewDatabase;
use MyNewDatabase;
grant all on *.* to root@'%'  identified by 'Passw0rd';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'Passw0rd';
DROP TABLE IF EXISTS Counselor;
DROP TABLE IF EXISTS Subject;
```

```
CREATE TABLE Counselor (
       counselor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
       first_name VARCHAR (50),
       nick_name VARCHAR (50),
       last_name VARCHAR (50),
       telephone VARCHAR (25),
       email VARCHAR (50),
       member_since DATE DEFAULT '1970-01-01',
       PRIMARY KEY (counselor_id)
);

CREATE TABLE Subject (
	subject_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR (50),
	description TEXT,
	counselor_idfk SMALLINT UNSIGNED,
	PRIMARY KEY (subject_id)
);
```
Now the DB is ready to be used by the application. Make a note of MySQL server IP and port (default: 3306). Use these connection details in application context.xml file when application is deployed on Tomcat.

# Tomcat Installation
## Step 1: Install Java
Tomcat requires Java to be installed on the server so that any Java web application code can be executed. We can satisfy that requirement by installing OpenJDK with apt-get.
First, update your apt-get package index:

`$ sudo apt-get update`

Then install the Java Development Kit package with apt-get:

`$ sudo apt-get install default-jdk`

Now that Java is installed, we can create a tomcat user, which will be used to run the Tomcat service.
## Step 2: Create Tomcat User
For security purposes, Tomcat should be run as an unprivileged user (i.e. not root). We will create a new user and group that will run the Tomcat service.
First, create a new tomcat group:

`$ sudo groupadd tomcat`

Next, create a new tomcat user. We’ll make this user a member of the tomcat group, with a home directory of /opt/tomcat (where we will install Tomcat), and with a shell of /bin/false (so nobody can log into the account):

`$ sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat`

Now that our tomcat user is set up, let’s download and install Tomcat.
## Step 3: Install Tomcat
The best way to install Tomcat 8 is to download the latest binary release then configure it manually.
Find the latest version of Tomcat 8 at the Tomcat 8 Downloads page. At the time of writing, the latest version is 8.5.5, but you should use a later stable version if it is available. Under the Binary Distributions section, then under the Core list, copy the link to the “tar.gz”.
Next, change to the /tmp directory on your server. This is a good directory to download ephemeral items, like the Tomcat tarball, which we won’t need after extracting the Tomcat contents:

`$ cd /tmp`

Use curl to download the link that you copied from the Tomcat website:

`$ curl -O http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz`

We will install Tomcat to the /opt/tomcat directory. Create the directory, then extract the archive to it with these commands:

```
$ sudo mkdir /opt/tomcat
$ sudo tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
```
Next, we can set up the proper user permissions for our installation.
## Step 4: Update Permissions
The tomcat user that we set up needs to have access to the Tomcat installation. We’ll set that up now.
Change to the directory where we unpacked the Tomcat installation:

`$ cd /opt/tomcat`

Give the tomcat group ownership over the entire installation directory:

`$ sudo chgrp -R tomcat /opt/tomcat`

Next, give the tomcat group read access to the conf directory and all of its contents, and execute access to the directory itself:

`$ sudo chmod -R g+r conf`

`$ sudo chmod g+x conf`

Make the tomcat user the owner of the webapps, work, temp, and logs directories:

`$ sudo chown -R tomcat webapps/ work/ temp/ logs/`

Now that the proper permissions are set up, we can create a systemd service file to manage the Tomcat process.
## Step 5: Create a systemd Service File
We want to be able to run Tomcat as a service, so we will set up systemd service file.
Tomcat needs to know where Java is installed. This path is commonly referred to as “JAVA_HOME”. The easiest way to look up that location is by running this command:

`$ sudo update-java-alternatives -l`

Output

`java-1.8.0-openjdk-amd64       1081       /usr/lib/jvm/java-1.8.0-openjdk-amd64`

The correct JAVA_HOME variable can be constructed by taking the output from the last column (highlighted in red) and appending /jre to the end. Given the example above, the correct JAVA_HOME for this server would be:

`JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre`

Your JAVA_HOME may be different.
With this piece of information, we can create the systemd service file. Open a file called tomcat.service in the /etc/systemd/system directory by typing:

`$ sudo nano /etc/systemd/system/tomcat.service`

Paste the following contents into your service file. Modify the value of JAVA_HOME if necessary to match the value you found on your system. You may also want to modify the memory allocation settings that are specified in CATALINA_OPTS:

```
/etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target
[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]

WantedBy=multi-user.target
```
When you are finished, save and close the file.
Next, reload the systemd daemon so that it knows about our service file:

`$ sudo systemctl daemon-reload`

Start the Tomcat service by typing:

`$ sudo systemctl start tomcat`

Double check that it started without errors by typing:

`$ sudo systemctl status tomcat`

## Step 6: Configure Tomcat connector to listen and accept connections from Apache Web Server
Edit the server.xml file at <tomcat-installation-directory>/conf/server.xml, in this case file is located at /opt/tomcat/conf/server.xml. Add following lines or edit if connector block already exists. Caution: “secretRequired="false"” is strictly not suggested for secure environments like production environments. It’s used here for testing purpose alone. Refer Tomcat manuals for setting up Tomcat securely. 

```
    <!-- Define an AJP 1.3 Connector on port 8009 -->

    <Connector protocol="AJP/1.3"

               address="0.0.0.0"

               port="8009"

               secretRequired="false"

               redirectPort="8443" />
```
Restart Tomcat: 

`$ sudo systemctl restart tomcat`

## Step 7: Deploy SearchDB application on Tomcat

Download the latest application war file attached above.
Rename the war file to SearchDB.war
Place the file in 

`/opt/tomcat/webapp`

The application will be deployed by Tomcat automatically.

Note: This application will not work until MySQL server is up and running and the IP address of the MySQL server is updated in the application configuration file on Tomcat server. 

## Step 8: Configure SearchDB application on Tomcat to connect to MySQL server
Open the context.xml file at following location:

`/opt/tomcat/webapp/SearchDB/META-INF/context.xml`
Update MySQL IP address and port as following:

```
<?xml version="1.0" encoding="UTF-8"?>

<Context path="/searchDB">
    <Resource name="jdbc/searchDB" auth="Container" type="javax.sql.DataSource"
        maxActive="100" maxIdle="30" maxWait="10000"
        username="root" password="Passw0rd" driverClassName="com.mysql.jdbc.Driver"
        url="jdbc:mysql://***10.132.0.2:3306***/MyNewDatabase"/>
</Context>
```


# Apache Installation
## Step 1: Install Apache Web Server

### Install apache on Ubuntu v16.04:

```
$ apt-get update && \
  apt-get install -yq \
  apache2 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
```
Enable the service to auto start at system reboot:

`$ sudo systemctl enable apache2`

## Step 2: Install Tomcat connector (mod_jk)

### Install mod_jk Tomcat connector on Ubuntu v16.04:

```
$ apt-get update && \
  apt-get install -yq \
  libapache2-mod-jk && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
```

## Step 3: Configure Apache and mod_jk

1.	Place the attached **jk.conf** file to /etc/apache2/mods-available directory:
2.	Place the attached **workers.properties** file to /etc/apache2/mods-available/workers.properties directory:
Edit this property **worker.router.host=192.0.1.6** in the file to IP address of the Tomcat server
```
#/etc/apache2/mods-available/workers.properties
# The dvanced router LB worker
  worker.list=router,worker1
  worker.router.type=ajp13
  worker.router.host=10.128.0.3
  worker.router.port=8009

  
  # Define the first member worker
  worker.worker1.type=ajp13
  worker.worker1.host=10.128.0.3
  worker.worker1.port=8009
  # Define preferred failover node for worker1
#  worker.worker1.redirect=worker2
```

3.	Place the attached **000-default.conf** file to /etc/apache2/sites-enabled/000-default.conf directory:
 
Restart apache webserver:

`$ sudo systemctl restart apache2`

Verify whether its started successfully:

`$ sudo systemctl status apache2`

Access the application on IP address of Apache server with following URL

`http://<apache-web-server-IP>:80/SearchDB/index.jsp`


