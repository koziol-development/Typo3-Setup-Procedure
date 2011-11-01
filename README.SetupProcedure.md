# Setup Procedure #

The steps described here aim at being an universal setup guide for Typo3. Starting from scratch we check prerequisites, create an empty directory to work in, copy all needed files, set correct file/directory permissions, adapt Apache settings etc.

1.	[Prerequisites](#prerequisites)
*	[Security](#security)
*	[Configuration](#configuration)




## Prerequisites<a id="prerequisites" /> ##

**200MB or more** of disk space

-	**Apache 2.x** with the following extensions enabled:
	-	``mod_expires``
	-	``mod_rewrite``
	-	``AllowOverride`` includes ``Indexes`` and ``FileInfo``
	
-	**PHP 5.2.0** or newer
	-	**php.ini**: ``memory_limit`` set to 128MB or more
	-	**Extensions**: Some extensions can be optionally compiled into PHP. A list of loaded extensions can be checked using the ``phpinfo()`` function.
	
		<table>
			<tr><th>Extension</th><th colspan="3">Package(s)</th></tr>
			<tr><td>mysql</td><td>php5-mysql</td></tr>
			<tr><td>cURL</td><td>php5-curl</td></tr>
			<tr><td>GD2</td><td>php5-gd</td></tr>
			<tr><td>JSON</td><td>libapache2-mod-php5</td><td>php5-cli</td><td>php5-cgi</td></tr>
			<tr><td>mbstring</td><td>libapache2-mod-php5</td><td>php5-cli</td><td>php5-cgi</td></tr>
			<tr><td>pcre</td><td>libapache2-mod-php5</td><td>php5-cli</td><td>php5-cgi</td></tr>
			<tr><td>session</td><td>libapache2-mod-php5</td><td>php5-cli</td><td>php5-cgi</td></tr>
			<tr><td>SPL</td><td>libapache2-mod-php5</td><td>php5-cli</td><td>php5-cgi</td></tr>
			<tr><td>standard</td><td>libapache2-mod-php5</td><td>php5-cli</td><td>php5-cgi</td></tr>
			<tr><td>xml</td><td>libapache2-mod-php5</td><td>php5-cli</td><td>php5-cgi</td></tr>
		</table>


-	**Server-Binaries** needed by **DAM**

	<table>
		<tr><th>Binary</th><th colspan="2">Package(s)</th><tr>
		<tr><td>exiftags</td><td>exiftags</td></tr>
		<tr><td>exiftool</td><td>libimage-exiftool-perl</td></tr>
		<tr><td>pdfinfo</td><td>poppler-utils</td><td>xpdf-utils</td></tr>
		<tr><td>pdftotext</td><td>poppler-utils</td><td>xpdf-utils</td></tr>
		<tr><td>catdoc</td><td>catdoc</td></tr>
		<tr><td>xls2csv</td><td>catdoc</td></tr>
	</table>	




## Security<a id="security" />

The following is taken from the [Typo3 Security Cookbook](http://typo3.org/fileadmin/security-team/typo3_security_cookbook_v-0.5.pdf)

> ### Secure the install Tool ###
> 
> **Explanation of Backgrounds**: The TYPO3 Install Tool is the powerful center of your TYPO3 system. As a basic rule, it should never be accessible from the Web unless you actually need it.
>   
> **Measures:**
>   
> -	disable the Install Tool (remove the comment in front of the “die()” line in ``typo3/install/index.php``) **OR**
> -	move away the ``typo3/install/`` directory or make it inaccessible for the web server **OR**
> -	limit access to ``typo3/install`` to specific hosts / networks / domains (using ``.htaccess``) **DEPRECATED!**
> -	you may want to add ``.htaccess`` authentication (though also not considered secure)
> -	at **LEAST** make sure to change the Install Tool password to a non-trivial value
>
> ---
>
> ### Change “admin” Password, Rename “admin” User ###
>
> **Explanation of Backgrounds**:  The default admin user and –password is always a first try for hacker
>
> **Measures:**
>
> -	change the password of the “admin” user immediately after install
> -	replace the “admin” user by other admins – preferably personalized ones (see “Choose Personal User Names”)
>
> ---
>
> ### Do not use “Quickstart“, “Testsite” et al. for Live Systems ###
>
> **Explanation of Backgrounds**:  The “Quickstart” package – like other demo packages - is intended to provide a read-to-run demo system. It contains a lot of code and content that you would have to clean up prior to use the installation for production purposes. It is much better to start with a “clean” system and install (maybe import) only what you really need.
>
> **Measures:**
>
> -	use the “dummy” package for live sites
> -	at **LEAST** make sure to remove all FE and BE users
>
> ---
>
> ### File System Access Rights ###
>
> **Explanation of Backgrounds**: Least privileges should be given in the TYPO3 and htdocs directories
> 
> **Measures:**
> 
> -	make sure to revoke all WRITE privileges in ``typo3_src`` for the web server’s user account
> -	set ownership and umask in htdocs to appropriate values (differs for the various subdirectories!)
> -	paranoid’s setting: Place ``localconf.php`` outside of htdocs by changing ``typo3conf/localconf.php`` to the following:
>
>			<?php
>				require("<directory outside htdocs>/localconf.php");
>			?>
> 
> ---
>
> ### Remove unneeded code ###
> 
> **Explanation of Backgrounds**: Depending on your base package (esp. if you use CVS code – depreciated anyway!), it may contain extra code that is not needed for production and therefore should not be accessible for potential offenders.
> 
> **Measures:**
> 
> -	Delete the ``./misc``, ``./cvs`` and the ``./dev`` directory if present, or at least make them inaccessible for the web server’s user account
> -	if you have live server separate from your editors’ production system, remove the BE from the live servers
> -	Only install required Extension
> 
> ---
>
> ### Configure TYPO3 Security Options<a id="configure-typo3-security-options" /> ###
> 
> **Explanation of Backgrounds**: TYPO3 provides numerous configuration options that increase system security. Check them out and use what makes sense in your situation!
> 
> **Measures / Install Tool** (see Install Tool sections for latest options and detailed descriptions):
> 
> -	``[strictFormmail]`` – set to "1"
> -	``[encryptionKey]`` – should be set (e.g. in "Basic Configuration")
> -	``[warning_email_addr]``
> -	``[lockIP]``
> -	``[lockRootPath]``
> -	``[fileCreateMask]``
> -	``[fileDenyPattern]`` – should at least contain ``\.php$|\.php.$``
> -	``[folderCreateMask]``
> -	``[warning_mode]``
> -	``[IPmaskList]``
> -	``[lockBeUserToDBmounts]``
> -	``[lockSSL]``
> -	``[enabledBeUserIPLock]``
> -	``[disable_exec_function]``
> -	``[usePHPFileFunctions]``
> -	``[noPHPscriptInclude]`` – consider this if others have access to your template files
> -	``[lockHashKeyWords]``
> -	``[devIPmask]``
> 	
> **Measures / BE GUI**
> 
> -	Add ``lockToDomain`` in be\_users/be\_groups record
> 
> ---
>
> ### Avoid config.baseURL=1 ###
> 
> **Explanation of Backgrounds**: In older versions, your cache may be poisoned, resulting in foreign pages being displayed instead of your own.
> 
> **Measures:**
> 
> -	use the absolute URL instead **OR**
> -	make sure the website can only be accessed with the correct URL (i.e. use name based virtual hosts in your web server)
> 
> ---
>
> ### Consider Using SSL for Backend Access ###
> 
> **Explanation of Backgrounds**: Although BE login itself is encrypted, the follow-up BE access is unprotected unless you use SSL. Since that may affect sensitive information, you are advised to use SSL for all BE access.
> 
> **Measures:**
> 
> -	configure HTTPS for your server
> -	redirect HTTP access to ``/typo3`` to HTTPS in your web server
> -	use the ``lockSSL`` Install Tool option see [Configure TYPO3 Security Options](#configure-typo3-security-options)
> 
> ---
>
> ### Restrict Special Content Elements usage ###
> 
> **Explanation of Backgrounds**: Some low-level content elements may let backend users gain system access beyond the level you intended, or may enable them to create security breaches without knowing. Therefore, the following restrictions are recommended for all users that all not fully aware or capable of understanding the
> security implications, or are simply not fully trusted.
> 
> **Measures:**
> 
> - Do not allow Content Element "HTML"
> - Do not allow plain HMTL in Text Content Elements
> - Do not allow plugins that let the user insert PHP code
> 	
> ---
>
> ### Choose Personal User Names for Backend Access ###
> 
> **Explanation of Backgrounds**: “john.doe” is better then “bigboss” - avoid using shared accounts in general. You should always be able to keep track on who is doing what, and backend users should be aware of that fact.
> 
> **Measures:**
> 
> -	give personal user names
> -	inform your BE users about the logging
> -	educate them not to share accounts
> 	
> ---
>
> ### Logging / Auditing ###
> 
> **Explanation of Backgrounds**: Know your log files, and be sure they are configured to audit all information you need.
> 
> **Measures:**
> 
> -	The ``sys_log`` table is your default BE user log (accessible via Tools->Log)
> -	you can enable additional logging using the ``[logfile_dir]`` and ``[logfile_write]`` Keywords
> -	The ``[trackBeUser]`` setting is intended for debug purposes
> -	The ``[enable_DLOG]`` (in conjunction with constant ``TYPO3_DLOG``)
> 	
> ---
>
> ### Subscribe to TYPO3-Announce, Apply Fixes ###
> 
> **Explanation of Backgrounds**: In case a security issue with TYPO3 or one of its extensions occurs, a "TYPO3 Security Bulletin" will be communicated through the "TYPO3-Announce" Mailing list. A fix or workaround will come along.
> 
> **Measures:**
> 
> -	Subscribe to TYPO3-Announce (goto xxxxxxxxxxxxx)
> -	Read the Bulletins, and implement the measures if you are affected.
> -	Make sure to do the same for future installations!
> -	All TYPO3 Security Bulletins can be found on xxxxxxxxxxxxxxxx
> 	
> ---
>
> ### FE User Security ###
> 
> **Explanation of Backgrounds**: Please take your FE users security concerns seriously, i.e. protect their sensitive data.
> 
> **Measures:**
> 
> -	Use SSL for FE logon											  
> -	Use SSL for FE user self-registration and password change		  
> -	Use SSL for all sensitive data like forms (not only credit card data…) or personal output
> -	do not store FE user passwords in clear - use an extension like [kb\_md5fepw](http://typo3.org/extensions/repository/view/kb_md5fepw/current/), or use secure external password storage like LDAP (preferably via SSL) with MD5								  
> 	
> ---
>
> ### Error Handling ###
> 
> **Explanation of Backgrounds**: Even if you try to avoid it – your system may run into one (or more :-) errors one day - so "be prepared". Make sure errors are tracked, and user output is convenient and does not expose any internal information.
> 
> **Measures:**
> 
> PHP errors should be handled, but normally through PHP means (see below). Thus ``[displayErrors]`` should be set to 0.
> More a cosmetical thing: TYPO3-internal "Page not Found" errors can be configured using the ``[pageNotFound_handling]`` and ``[pageNotFound_handling_statheader]`` setting.
> 	
> ---
>
> ### Use Trusted / Reviewed Extensions ###
> 
> **Explanation of Backgrounds**: Every extension can potentially expose your entire system, whether by a security bug or even intentionally.
> **Measures:**
> 
> -	Use extensions that have undergone the extension review process.
> -	If an extension is not reviewed yet, think about sponsoring its review.
> -	Remember to have your own extensions quality-assured as well.
> 
> ---
> 	
> ### Non TYPO3 Settings ###
> #### PHP ####
> These settings should b e done in php.ini
> 
> -	log errors to an error file – needed to reproduce any problems
> -	Display errors  off – do not display any errors through the webserver – dont'push people to possible leaks
> -	use safemode, or at least open basedir to prevent webs from accessing other directories or execute things, they mustn't – again: less is more.
> -	Use a CGI/PHP wrapper (suPHP?) ???
> -	compile your PHP with minimum compile options, or install only needed extentions - what is not included, is not vulnerable.
> -	``register_globals = Off``. If this is really required, it could be switched on for single webs in the .htaccess file.
> -	verify and use ``.htaccess`` !
> 
> #### Apache ####
> -	In ``httpd.conf`` don't load modules, you don't need. Best is not to even install them. Directory listing for example is not needed. This can be done via php script if needed
> -	Only install required modules.
> -	disable version info in error pages, tell possible attackers as little as possible
> 
> #### MySQL ####
> -	dissallow network connections to MySQL. If needed, tunnel it through a secure connection (``stunnel``)
> -	don't use the mysql root user, use one user per database
> -	set an own password for mysql root user, don't use the server root password
> 
> ### General ###
> 
> **problems according to shared hosting**
> 
> -	requirements to the isp
> -	activate ``su_exec``
> -	don't store passwords on servers ! If you need a ``password.txt`` file: store it on a sheet of paper, or on a box which is not connected to the web. (i know, this one is nagging, but ...)
> -	subscribe to the security lists of your distribution / Operating System Vendor. (OS, ssh, apache, php, mysql, openssl, …) 
> -	if possible, run updates daily through a cron job
> -	try to use secured connections for all protocols (sftp, etc)
> -	restrict acces for users only to needed directories ( i.e. Proftpd: ``users home = htdocs ; DefaultRoot = ~``)
> -	monitor your servers to see, if something unusual happens (i.e. nagios, tripwire, tiger, logsurfer, ...)
> -	harden system (disabel unneeded services, remove compilers, ...)
> -	protect phpMyAdmin with ``.htaccess``
> -	don't do dumps or backups to ``fileadmin`` or ``htdocs``, if you use backup extensions, delete the backups after downloading them.

The following parts are taken from <http://typo3.org/documentation/document-library/core-documentation/doc_core_inside/4.2.0/view/2/10/>

>	**Additional security measures you can take:** 
>	
>	1.	Add a ``.htaccess`` file to the ``typo3/`` source code directory. This will “webserver protect” the backend interface. Backend users will have to type in two passwords: First the general webserver password, then the user-specific TYPO3 password.The authenticated web-server user is not used by TYPO3 in any way. It just adds another gate in the authorization process.Notice: This solution will not work if you are using file resources (such as images) from extensions in your frontend! That might be the case if your site uses frontend plugins from extensions installed as "system" or "global". If an image is referenced on the site it will trigger an authorization box to pop up! The solution could be to install the extension as "local" (in ``typo3conf/ext/``) where the directory is not password protected.
>	-	Add IP-filtering (see ``TYPO3_CONF_VARS[BE][IPmaskList]``) - this enables you to lock out any backend users which are not coming from a certain IP number range.
>	-	Add ``lockToDomain`` in be\_users/be\_groups records (makes sure that users are logging in only from certain URL's - maybe some secret admin-url you make?)
>	-	Change name of the "typo3/" backend directory (makes it harder to guess the administration URL).
>	-	Set the ``TYPO3_CONF_VARS[BE][warning_mode]`` and ``TYPO3_CONF_VARS[BE][warning_email_addr]`` - that will inform you of logins and failed attempts in general.
>	-	Use https for all backend activity. That will make sure that your passwords and data communication with the server are truely encrypted. ``TYPO3_CONF_VARS[BE][lockSSL]=1`` will force users to use https.
>	-	Make sure your PHP-scripts does not output the path on the server if they are called directly. If you use the testsite package there are example scripts in ``fileadmin/`` directory which will do so. That is called "path disclosure" and poses a security threat (some argues).
>	-	SQL-dumps: Don't store SQL-dumps of the database in the webroot - that provides direct access to all database content if the file position is known or guessed.
>	-	Disable "Directory listing" in the webserver or alternatively add blank ``index.html`` to subdirectories like ``uploads/*``, ``typo3conf/*`` or ``fileadmin/*``. Most likely you don't want people to browse freely in your subdirectories to TYPO3.
>	-	Use salted passwords.




## <a id="configuration" />Configuration ##
#### UTF-8 ####
##### Database #####
MySQL **up to 5.5.3**

	[client]
	default-character-set = utf8
	[mysqld]
	default-character-set = utf8

MySQL **from 5.5.3 upwards**

	[client]
	default-character-set = utf8
	[mysqld]
	character-set-server = utf8
	collation-server = utf8_unicode_ci

	mysql> create database typo3_db default character set utf8;

Backend (``typo3conf/localconf.php``)

	$TYPO3_CONF_VARS['BE']['forceCharset'] = 'utf-8';

Frontend (TypoScript)

	config.renderCharset = utf-8

DB-Verbindung umstellen (``typo3conf/localconf.php``)

	$TYPO3_CONF_VARS['SYS']['setDBinit'] = 'SET NAMES utf8;\' . LF . \'SET SESSION character_set_server=utf8;';

PHP: ``php.ini``

	default_charset = "utf-8"

#### GraphicsMagick ####
-	Remove ImageMagick **(necessary? recheck!)**
-	Check symlinks in ``/usr/bin/`` *(s. <http://wiki.typo3.org/GraphicsMagick>)*

		$TYPO3_CONF_VARS['GFX']['im_version_5'] = 'gm';
		$TYPO3_CONF_VARS['GFX']['TTFdpi']='96';
		$TYPO3_CONF_VARS['GFX']['im_imvMaskState'] = '1';
		$TYPO3_CONF_VARS['GFX']['gif_compress'] = '1';

#### ImageMagick ####
	['GFX']['im_version_5'] = 'im6';
	['GFX']['TTFdpi'] = 96;
	['GFX']['im_combine_filename'] = 'composite';
	['GFX']['im_negate_mask'] = 0;
	['GFX']['im_invMaskState'] = 1;

## Extensions ##
-	[dam_index	  ](http://typo3.org/extensions/repository/view/dam_index/current/)
-	[dam_catedit  ](http://typo3.org/extensions/repository/view/dam_catedit/current/)
-	[dam_ttcontent](http://typo3.org/extensions/repository/view/dam_ttcontent/current/)
-	[cc_metaexif  ](http://typo3.org/extensions/repository/view/cc_metaexif/current/)
-	[cc_metaexec  ](http://typo3.org/extensions/repository/view/cc_metaexec/current/)
-	[cc_txtextexec](http://typo3.org/extensions/repository/view/cc_txtextexec/current/)