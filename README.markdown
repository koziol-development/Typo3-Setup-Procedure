# Typo3 Setup procedure README
This project aims at providing a thorough procedure to set up a Typo3 installation from scratch. Although most of the information collected here can be found all around the web, it consumes a fair amount of time picking the needed cherries.

In the 1st phase a fair amount of information will be organized in the file [``README.SetupProcedure.md``](https://github.com/koziol-development/Typo3-Setup-Procedure/blob/master/README.SetupProcedure.md) to identify the results we want to achieve, so we can develop the needed scripts from there.

## Filesystem ##

### Setting up the webroot directory<a id="webroot-setup" /> ###

- ``~/typo3_src -> <your-typo3-src-dir>``
- ``webroot/``
	- ``fileadmin``
	- *``index.php -> typo3_src/index.php``*
	- *``t3lib -> typo3_src/t3lib``*
	- *``typo3 -> typo3_src/typo3``*
	- *``typo3_src -> ~/typo3_src``*
	- ``typo3conf``
	- ``typo3temp``
	- ``uploads``