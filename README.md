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

[install]: https://docs.google.com/document/d/14GHVib5uDEse9umzujvx029XewbnuzGKrqpfv-TAwoM/edit