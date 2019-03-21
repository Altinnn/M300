# **Modul 300 LB1 Dokumentation** 

# Inhaltsverzeichnis
  - [01 - Umgebung](#01---umgebung)
  - [02 - Verwendetet Tools](#02---verwendetet-tools)
  - [03 - Wissenstand](#02---wissenstand)
    - [03.1 - Linux](#03.1---linux)
    - [03.2 - Virtualisierung](#03.2---virtualisierung)
    - [03.3 - Vagrant](#03.3---vagrant)
    - [03.4 - Versionverwaltung/Git](#03.4---versionverwaltunggit)
    - [03.5 - Markdown](#03.5---markdown)
    - [03.6 - Systemsicherheit](#03.6---systemsicherheit)
  - [04 - Lernschritte](#04---lernschritte)
    - [04.1 - Vagrant](#04.1---Vagrant)
    - [04.2 - Netzwerkplan](#04.1---netzwerkplan)
    - [04.3 - Installation - Webserver - und -Datenbank](#04.1---installation - Webserver - und - Datenbank)
  - [05 - Sicherheitsaspekte](#04.1---Sicherheitsaspekte)
    - [05.1 - UFW - Firwall](#04.1---UFW-Firewall)
    - [05.2 - Reverse-Proxy](#04.1---Reverse-Proxy)
    - [05.3 - SSH-Tunnel](#04.1---SSH-Tunnel)
    - [05.4 - Webserver per HTTPS sichern](#04.1---Webserver per HTTPS sichern)
  - [06 - Wissenzuwachs](#04.1---Wissenzuwachs)
  - [07 - Reflektion](#04.1---Reflektion)

## 01 - Umgebung
* Vagrant
* Visual Studio
* Virtual Box 6.0
* Git-Client
* VM

## 02 - Verwendetet Tools
* Virtualbox 6.0
* Vagrant
* Visual Studio Code
* Git-Client (SSH-Key)

## 03 - Wissenstand
### 03.1 - Linux
Linux Grundkenntnisse sind vorhanden jedoch im Betrieb eher gelegentlich zu tun.

### 03.2 - Virtualisierung
Erfahrung in Virtualisierung mit ESXi, VMware und Virtual Box. Server Umgebungen Virtualisierung im Betrieb geplant und ausgeführt. 

### 03.3 - Vagrant
Noch keine Vorkenntnisse vorhanden.

### 03.4 - Versionverwaltung/Git
Erfahrung im Betrieb mit Versionverwaltung Document Management Systemen und Cloud. Mit GitHub noch wenige Erfahrungen gemacht. Grundsätzlich sollte es mir nicht schwer fallen mit GitHub zu arbeiten. 

### 03.5 - Markdown
Noch keine Vorkenntnisse vorhanden.

### 03.4 - Systemsicherheit
Firewalls im Betrieb konfiguriert Linux Basierend SonicWall, ZyWALL, Cisco. Planung von Sicherheitskonzepten schon in der TBZ realsiert. Diese Kenntnisse sollen für die LB1 ausreichen. 

## 04 - Lernschritte

### 04.1 - Vagrant

**Befehle**

  *vagrant init* - Damit wird im aktuellen Verzeichnis die Vagant-Umgebung initialisiert
  *vagrant up* - Das Vagrantfile wird gelesen und die VMs werden erstellt
  *vagrant ssh* - Baut eine SSH-Verbindung zur gewünschten VM auf
  *vagrant status* - Zeigt den aktuellen Status der VM an
  *vagrant port* - Zeigt die Weitergeleiteten Ports der VM an
  *vagrant halt* - Stoppt die laufende Virtuelle Maschine
  *vagrant destroy* - Stoppt die Virtuelle Maschine und zerstört sie.

**Bestehende VM aus Vagrant Cloud erstellen (Webserver und Datenbank)**
1. Mit *vagrant init* Vagrantfile im gewünschten Verzeichnis erstellt.
2. OS auswhlen von der Cloud https://app.vagrantup.com/boxes/search Ubuntu/xenial64 für meine VM usgewählt.
3. Vagrantfile mit den entsprechenden Parameter erstellen
4. Mit dem Befehl *vagrant up* werden nun die Virtuellen Maschinen erstellt

### 04.2 - Netzwerkplan


    +---------------------------------------------------------------+
    ! Notebook - Schulnetz 10.x.x.x und Privates Netz 192.168.10.1  !                 
    ! Port: 443 (192.158.10.101:443)                                !	
    !                                                               !	
    !    +--------------------+          +---------------------+    !
    !    ! Web Server         !          ! Datenbank Server    !    !       
    !    ! Host: webserver01  !          ! Host: database01    !    !
    !    ! IP: 192.168.10.101 ! <------> ! IP: 192.168.10.100  !    !
    !    ! Port: 443          !          ! Port 3306           !    !
    !    ! Nat: -             !          ! Nat: -              !    !
    !    +--------------------+          +---------------------+    !
    !                                                               !	
    +---------------------------------------------------------------+


### 04.3 - Installation Webserver und Datenbank
Web Server mit Apache und MySQL User Interface Adminer und Datenbank Server mit MySQL.
Für die Installation der beiden VMs wurde ein Vagrantfile erstellt, in dem alle Angaben wie IP, Hostname, OS etc. befindet. Ausserdem befindet sich ein Shellscript das auf der Datenbankserver MySQL installiert. Auf dem Webserver wurde Apache installiert und auf dem Datenbankserver «Adminer SQL» um die Dantebank über das Web zu verwalten. 
Das Userinterface ist über https://192.168.10.101/adminer.php erreichbar mit dem User 'admin' anmelden. 

### 05 - Sicherheitsaspekte
Beim Sicherheitsaspekt wurde folgende Einstellungen gemacht.

### 05.1 - UFW Firewall

Ausgabe der offenen Ports
    $ netstat -tulpen

Installation
    $ sudo apt-get install ufw

Start / Stop
    $ sudo ufw status
    $ sudo ufw enable
    $ sudo ufw disable

Firewall-Regeln
    # Port 80 (HTTP) öffnen für alle
    vagrant ssh web
    sudo ufw allow 80/tcp
    exit

    # Port 443 (HTTPS) öffnen für alle
    vagrant ssh web
    sudo ufw allow 443/tcp
    exit
    
    # Port 22 (SSH) nur für den Host (wo die VM laufen) öffnen
    vagrant ssh web
    sudo ufw allow to any port 22
    exit
    
    # Port 3306 (MySQL) nur für den web Server öffnen
    vagrant ssh database
    sudo ufw allow from 192.168.10.100 to any port 3306
    exit

Zugriff testen
    $ curl -f 192.168.10.101
    $ curl -f 192.168.10.100:3306

### 05.2 - Reverse-Proxy

    Installation Dazu müssen folgende Module installiert werden:
    $ sudo apt-get install libapache2-mod-proxy-html
    $ sudo apt-get install libxml2-dev

Anschliessend die Module in Apache aktivieren:
    $ sudo a2enmod proxy
    $ sudo a2enmod proxy_html
    $ sudo a2enmod proxy_http

Die Datei /etc/apache2/apache2.conf wie folgt ergänzen:
    ServerName 192.168.10.101 

Apache-Webserver neu starten:
    $ sudo service apache2 restart

**Weiterleitung einrichten** 

Die Weiterleitungen sind z.B. in sites-enabled/001-reverseproxy.conf eingetragen:

    # Allgemeine Proxy Einstellungen
    ProxyRequests Off*
    <Proxy>
        Order deny,allow
        Allow from all
    </Proxy>
    
    # Weiterleitungen master
    ProxyPass /master http://master
    ProxyPassReverse /master http://master


### 05.3 - SSH-Tunnel




### 05.4 - Webserver per HTTPS sichern

    # Default Konfiguration in /etc/apache2/sites-available freischalten (wird nach sites-enabled verlinkt
    sudo a2ensite default-ssl.conf
    
    # SSL Modul in Apache2 aktivieren
    sudo a2enmod ssl
    
    # Optional HTTP deaktivieren
    sudo a2dissite 000-default.conf 
    
    # Datei /etc/apache2/ports.conf editieren und <Listen 80> durch Voranstellen von # deaktivieren
    sudo nano /etc/apache2/ports.conf
    
    # Unter default-ssl.conf die Server IP eintragen 
    sudo nano /etc/apache2/sites-available/default-ssl.conf
    <IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerName 192.168.10.101
    
                DocumentRoot /var/www/html
    
                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined
    
                SSLEngine on
    
                SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
    
                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>
    
        </VirtualHost>
  </IfModule>

    # Apache Server neustarten
    sudo service apache2 restart



### 06 - Wissenszuwachs

**Linux**
Hat sich mit ein paar Recherche gesteigert 

**Virtualisierung**
Bei der Virtualisierung war mein Vorwissen schon recht gut das konnte ich noch im Bericht Linux verbessern.

**Vagrant**
Vagrant war für mich neu Land das mir im Verlauf der LB01 

**Versionverwaltung/Git**
Die Versionsverwaltung hat sich sehr positiv bewährt, weil ich jede Veränderung im Vagrantfile sofort erkennen konnte. 

**Markdown**
Mit den Erstellen von Markdown funktionierte es von Anfang an gut. 

**Systemsicherheit**

### 07 - Reflektion
Die LB01 verlief im Grossen ganzen recht gut. Das Erstellen der beiden VM mit Vagrant funktionierte ohne grosse Probleme. 

ich fand die LB01 äusserst spannend. ich versuchte mich somit der Informatik zu geben und habe es seht interessant gefunden.

Ich hatte im persönlichen leben einen Rückstoss der mit meiner Gesundheit zu tun hatte.

Ich habe gesehen das ich vieles machen kann nur wen ich es sehe und auch versuche zu meistern. Ich fand im allgemeinem sehr toll so etwas zu machen und zu sehen wieviel man mit einem Vagrant File alles anstellen kann.

Ich kann VMs kreieren, laufen lassen und der Rest funktioniert. Danach habe ich das Konzept "Multi-VMs" mir genauer angeschaut und dies gefolgt. Jetzt funktioniert mein Skript immer noch, doch Fehler hat es da ich nicht mehr viel Zeit hatte.



