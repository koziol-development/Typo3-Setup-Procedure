# Setup Procedure #

The steps described here aim at being an universal setup guide for Typo3. Starting from scratch we check prerequisites, create an empty directory to work in, copy all needed files, set correct file/directory permissions, adapt Apache settings etc.

## Prerequisites ##
	
#### **200MB or more** of disk space ####
#### **Apache 2.x** with the following extensions enabled: ####
- mod\_expires
- mod\_rewrite
- AllowOverride includes "Indexes" and "FileInfo"

#### **PHP 5.2.0** or newer ####
- php.ini: memory\_limit set to 128MB or more
- Extensions:
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
	
	Some extensions can be optionally compiled into PHP. A list of loaded extensions can be checked using the phpinfo() function.

#### Server-Binaries needed by DAM ####
<table>
	<tr><th>Binary</th><th colspan="2">Package(s)</th><tr>
	<tr><td>exiftags</td><td>exiftags</td></tr>
	<tr><td>exiftool</td><td>libimage-exiftool-perl</td></tr>
	<tr><td>pdfinfo</td><td>poppler-utils</td><td>xpdf-utils</td></tr>
	<tr><td>pdftotext</td><td>poppler-utils</td><td>xpdf-utils</td></tr>
	<tr><td>catdoc</td><td>catdoc</td></tr>
	<tr><td>xls2csv</td><td>catdoc</td></tr>
</table>	

## Setting up the Webserver root directory ##

#### Dateisystem-Layout ####
-	typo3\_xxx/ (repo)
	-	fileadmin/ (repo)
		-	...
	-	t3lib -> typo3\_src/t3lib/ (ignore)
	-	typo3 -> typo3\_src/typo3/ (ignore)
	-	typo3conf (repo/submodule?)
		-	ext/
		-	l10n/
	-	typo3\_src -> ../typo3\_src-4.x.y/ (ignore)
	-	typo3temp/ (ignore)
	-	uploads/

## Configuration ##
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

DB-Verbindung umstellen (typo3conf/localconf.php)

	$TYPO3_CONF_VARS['SYS']['setDBinit'] = 'SET NAMES utf8;\' . LF . \'SET SESSION character_set_server=utf8;';

PHP: php.ini

	default_charset = "utf-8"

#### GraphicsMagick ####
-	Remove ImageMagick **(necessary? recheck!)**
-	Check symlinks in /usr/bin/ *(s. <http://wiki.typo3.org/GraphicsMagick>)*

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
-	dam_index
-	dam_catedit
-	dam_ttcontent
-	cc_metaexif
-	cc_metaexec
-	cc_txtextexec