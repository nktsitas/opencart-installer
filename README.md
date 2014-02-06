Command Line Opencart Installer
=====================

A command line installer for opencart.


Summary
-------

Can be used under linux, or windows with cygwin

Can also pre-install templates if specified


Known Issues
------------

* Only Journal template supported so far


Install
----------

1. run cygwin setup and add mysql
2. create a file at ~/.my.cnf containing:

		[client] 
		user=root 
		host=127.0.0.1 
		password= 

3. Find your cygwin folder (C:/cygwin , C:/cygwin64, …)
4. go to *&lt;cygwin_folder&gt;*/var/local (create folder local if doesn’t exist)
5. copy paste opencart versions in there so you end up with  

		<cygwin_folder>/var/local/opencart-1.5.5.1/upload/…
		<cygwin_folder>/var/local/opencart-1.5.6.1/upload/…
		.
		.
6. Copy paste base folder of working templates  

		<cygwin_folder>/var/local/Journal/Journal_v.1.2.0/….

7. Copy **install\_opencart.sh** into *&lt;cygwin_folder&gt;*/usr/local/bin
8. Run:  

		ln -s /usr/local/bin/install_opencart.sh /usr/local/bin/opencart

Usage
-----
1. navigate to the folder you wish to install opencart
2. run:  

		opencart -n <project_name> -u <user_name> -d <database_name> -m <domain_url>

3. Base opencart should be installed and accessible through __&lt;domain\_url&gt;__ & __&lt;domain\_url&gt;/admin__ with admin:admin123
4. Database &lt;user\_name&gt;\_&lt;database\_name&gt; should have been created in mysql server specified inside install_opencart.sh

Install/Sync Online-Production (git & git-ftp)
-----
1. navigate to project base folder.  
2. initialize git & submit first commit

		cd <install_folder>
		git init
		git add .
		git commit -m 'first commit'

3. Connect to production with ssh
4. install opencart online (see Usage)
5. setup git-ftp  

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

6. create file .git-ftp.log and write inside the commit hash from local folder (enter following command to add it to clipboard)

		git log --pretty=oneline | awk 'NR==1{print $1}' | clip

	if ssh keys are installed in local machine, you can use scp to upload .git-ftp.log with one command (change user & project_name):  

		git log --pretty=oneline | awk 'NR==1{print $1}' >> .git-ftp.log && scp .git-ftp.log root@cheetasoft.gr:/home/<user>/public_html/<project_name> && rm .git-ftp.log


[install]: https://docs.google.com/document/d/14GHVib5uDEse9umzujvx029XewbnuzGKrqpfv-TAwoM/edit