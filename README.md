# JsModelGenerator

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
js_model_generator -c path_to_your_config_file.rb
```

## Config File Format

What the heck.  I decided to use a ruby file as a config file.  See
the sample in the example directory.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MadBomber/js_model_generator.

## License

You want it?  Its yours.

