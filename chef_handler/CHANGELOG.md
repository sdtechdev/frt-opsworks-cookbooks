chef_handler cookbook CHANGELOG
===============================

v1.1.7 (2015-05-14)
-------------------
Updated Contribution and Readme docs.
Fix ChefSpec matchers.
Allow handler to load classes when no source is provided.

v1.1.6 (2014-04-09)
-------------------
[COOK-4494] - Add ChefSpec matchers


v1.1.5 (2014-02-25)
-------------------
- [COOK-4117] - use the correct scope when searching the children class name


v1.1.4
------
- [COOK-2146] - style updates

v1.1.2
---------
- [COOK-1989] - fix scope for handler local variable to the enable block

v1.1.0
------

- [COOK-1645] - properly delete old handlers
- [COOK-1322] - support platforms that use 'wheel' as root group'

v1.0.8
------
- [COOK-1177] - doesn't work on windows due to use of unix specific attributes

v1.0.6
------
- [COOK-1069] - typo in chef_handler readme

v1.0.4
------
- [COOK-654] dont try and access a class before it has been loaded
- fix bad boolean check (if vs unless)

v1.0.2
------
- [COOK-620] ensure handler code is reloaded during daemonized chef runs
  
