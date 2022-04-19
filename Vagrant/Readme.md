# Base Docker Development VM

Provisions an Ubuntu server with Docker Compose. 

- Creates an Ubuntu VM running Docker
- Allows for configuration using a docker-compose.yml file


## How do i use it? 

Step 1. Install vagrant and virtualbox

[https://www.vagrantup.com/]

If using a mac homebrew casks is probably the easiest way:

To install homebrew

```
$> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```
$> brew doctor && brew update
$> brew install virtualbox --cask
$> brew install vagrant --cask
$> vagrant autocomplete install
$> brew install --cask virtualbox-extension-pack
```
Please Go to System Preferences / Security & Privacy > Click “Allow” to give permission to the virtualbox

If needed assistance please follow both the article:

1. https://formulae.brew.sh/cask/virtualbox 

2. https://medium.com/@Aenon/mac-virtualbox-kernel-driver-error-df39e7e10cd8

If you are using windows:

1. Install virtualbox: https://www.virtualbox.org/wiki/Downloads 
2. Install vagrant: https://www.vagrantup.com


Step 2. 
Go to the directory where the Vagrant file is. 

If you want to validate the Vagrant file

```vagrant validate```

Go to .env file as it has config file to set up the containers using docker compose. Please change accordingly.

```
POSTGRES_PASSWORD=password123
POSTGRES_USER=postgres
VTT_DBUSER="postgres"
VTT_DBPASSWORD="password123"
VTT_DBNAME="app"
VTT_DBPORT="5432"
VTT_DBHOST="postgresql"
VTT_LISTENHOST="0.0.0.0"
VTT_LISTENPORT="3000"
PGADMIN_DEFAULT_EMAIL=admin@admin.com
PGADMIN_DEFAULT_PASSWORD=root
```
Now we can bring the vm an resources

```vagrant up```

You now have a working dev environment you can play with. 

To check the resources:

1. Let's check all 3 docker containers are running or not
    ```
    vagrant ssh -c "docker ps -a"
    ```
2. Let's do a health check
    ```
    curl http://127.0.0.1:8080/healthcheck/      
    ```
3. Let's check the api
   ```
   curl http://127.0.0.1:8080/api/task/ 
   ```
4. To access the app go to browser: http://127.0.0.1:8080 
   

```vagrant ssh``` will take you into the machine where you can work with docker once inside: 

```
docker ps
docker exec -it <containerid> /bin/sh
```


If you want to destroy the vm (delete):

```vagrant destroy```

If you want to pause the vm: 

```vagrant halt```

Step 3. Whenever you change the file, you need to run: `vagrant reload` to redefine the box.
