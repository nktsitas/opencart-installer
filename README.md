Command Line Opencart Installer
=====================

A command line installer for opencart.


Summary
-------

Can be used under linux, or windows with cygwin

Can also pre-install templates if specified

Ubuntu Install
----------
ubuntu version available as a ppa: https://launchpad.net/~mithereal/+archive/opencart-installer
		sudo add-apt-repository ppa:mithereal/opencart-installer

Windows Install
----------

1. run cygwin setup and add mysql
2. create a file at ~/.my.cnf containing:

		[client] 
		user=root 
		host=127.0.0.1 
		password= 

3. edit /etc/opencart-install.conf
4. Find your cygwin folder (C:/cygwin , C:/cygwin64, …)
5. create folder *&lt;cygwin_folder&gt;*/home/username/Projects/opencart/ if doesn’t exist
  alternatively create folder  *&lt;cygwin_folder&gt;*/home/username/Projects/opencart/ if doesn’t exist
6. copy paste opencart versions u work with in there so you end up with   

		<cygwin_folder>/home/username/Projects/opencart/opencart-1.5.5.1/upload/…
		<cygwin_folder>/home/username/Projects/opencart/opencart-1.5.6.1/upload/…
                 and optionally
                <cygwin_folder>/usr/src/opencart/opencart-1.5.5.1/upload/…
		<cygwin_folder>/usr/src/opencart/opencart-1.5.6.1/upload/…
		
		
6. Copy the working templates into a folder structure like below in this case stable is the branch this will change with release ex u could target 1.5.5.1 by adding a 1.5.5.1 dir under the theme name

		<cygwin_folder>/home/username/Projects/opencart/theme/Journal/stable/upload….
                and optionally
		<cygwin_folder>/usr/src/opencart/theme/Journal/stable/upload….

6. Copy paste base folder of working extensions  

		<cygwin_folder>/home/username/Projects/opencart/extension/extension-name/stable/upload….
                and optionally
		<cygwin_folder>/usr/src/opencart/extension/extension-name/stable/upload….

8. Copy **install\_opencart** into *&lt;cygwin_folder&gt;*/usr/local/bin
9. Run:  
	
   	        ln -s /usr/local/bin/install_opencart.sh /usr/local/bin/opencart-install

Usage
-----
 -h sets the hostname of the store, ie cheetasoft.gr 

1. navigate to the folder you wish to install opencart
2. run:  

	        opencart-install -n <project_name> -u <user_name> -d <database_name> -m <domain_url> -h <host_url> -t <theme1,theme2,theme3> -e <extension1,extension2,extension3> -v <version>
	  
versions: stable = fetch the latest stable branch via wget | origin = clone the latest from your git repo | upstream = clone the main opencart git repo 

1.5.5.1 = fetch a local branch located in ~./Projects/opencart/opencart-VERSION  

you can change the location of opencart base in /etc/opencart-install.conf
		  
extensions and modules: these files follow a common naming convention see source for more info

3. Base opencart should be installed and accessible through __&lt;domain\_url&gt;__ & __&lt;domain\_url&gt;/admin__ with admin:admin123
4. Database &lt;user\_name&gt;\_&lt;database\_name&gt; should have been created in mysql server specified inside install_opencart.sh


5. Sync Online-Production (git & git-ftp)
-----

 Connect to production with ssh
 install opencart online
 setup git-ftp  

		git config git-ftp.production.url <production_path>
		git config git-ftp.production.user <user>
		git config git-ftp.production.password <password>
		or
		git config git-ftp.production.key <path to key>

	eg for cheetasoft (change user & project_name)  

		git config git-ftp.production.url sftp://cheetasoft.gr/home/<user>/public_html/<project_name>
		git config git-ftp.production.user panospcm
		git config git-ftp.production.password <password>
		git config git-ftp.production.key ~/.ssh/id_rsa

 create file .git-ftp.log and write inside the commit hash from local folder (enter following command to add it to clipboard)

		git log --pretty=oneline | awk 'NR==1{print $1}' | clip

 if ssh keys are installed in local machine, you can use scp to upload .git-ftp.log with one command (change user & project_name):  

		git log --pretty=oneline | awk 'NR==1{print $1}' >> .git-ftp.log && scp .git-ftp.log root@cheetasoft.gr:/home/<user>/public_html/<project_name> && rm .git-ftp.log


