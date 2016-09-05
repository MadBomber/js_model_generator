# JsModelGenerator

This thing is in major churn mode.  Don't use it without adult supervision.

Its overall purpose seems to be morphing into some thing that handles the
generic task of extract/transform/load for spreadsheet files into databases.
Don't know if the migrations part of its nature will survive.


I found myself having to work with javascript on a node project.  YUCK!

Part of what we had to do is ingest lots of MS Excel spreadsheets into a
postgresql database.  Everytime we got a new spreadhseet report-format we
would have to generate a sequelize javascript model, migration, csv seed file,
some sql and lots of chicken bone chants.

This is my attempt of a labor-saving device.

## Installation

    $ gem install js_model_generator

## Usage

* create a config file for each XLS file to process
* then execute

```shell
jsmodgen -c path_to_your_config_file.rb
```

## Config File Format

What the heck.  I decided to use a ruby file as a config file.  See
the sample in the example directory.


## License

You want it?  Its yours.

