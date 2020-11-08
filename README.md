# iotproject
- classes/base.bbclass
	It has definitions and basic tasks related to bitbake operations.

- conf/bblayer.conf
	File which contains the different layers details. whenever we create new layer
	we should add in this file to fetch .bb files.

- iotcode
	This is a layer in bitbake, which has recipes and configurations.
- iotcode/conf/bitbake.conf
	File which has global definitions required for bitbake.
- iotcode/conf/layer.conf
	File which has details of recipes from which paths it should pick.
