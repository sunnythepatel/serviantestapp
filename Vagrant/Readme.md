#Base Docker Development VM

Provisions an Ubuntu server with Docker Compose. 

- Creates an Ubuntu VM running Docker
- Allows for configuration using a docker-compose.yml file

##How do i use it? 

Step 1. Install vagrant 

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
```
https://medium.com/@Aenon/mac-virtualbox-kernel-driver-error-df39e7e10cd8

If you are using windows:
https://www.vagrantup.com

Step 2. 
Go to the directory where the Vagrant file is. 

If you want to validate the file

```vagrant validate```

If you want to bring the vm

```vagrant up```

You now have a working dev environment you can play with. 

If you want to destroy the vm (delete):

```vagrant destroy```

If you want to pause the vm: 

```vagrant halt```


```vagrant ssh``` will take you into the machine where you can work with docker once inside: 

```
docker ps
docker exec -it <containerid> bash
```

Step 3. Whenever you change the file, you need to run: `vagrant reload` to redefine the box.