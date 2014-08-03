A Serious-Toolkit
===================

The Serious Toolkit to make static webapps with all your love.

**Including**

- Flask
- Jade
- Knockout.js
- Widget.js
- Less
- Clevercss
- Coffee-script
- Bootstrap

## Kind of Doc

http://vied12.github.io/serious-toolkit/

## Commands

### Requirements

- pip
- virtualenv
- npm

### Install

	make install

Will install python dependances with pip in a virtualenv and nodejs dependances with npm in the directory node_modules

### Run the Web Application

	make run

### Generate the Static Files

	make freeze

Will greate a `build` folder with the static files inside

### Update the I18n Files

	make update_i18n

### Compile the I18n Files

	make compile_i18n


## TODO

- [ ] Versioning the built packages
- [ ] Set the i18n optionable
- [ ] Command to generate the i18n files
