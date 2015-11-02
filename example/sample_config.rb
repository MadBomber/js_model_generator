############################################
## sample_config.rb
#

# You may define shared converter methods
def xyzzy(a_value)
  "#{a_value} is now " + a_value.downcase
end

JsModelGenConfig.new do

  file_name   "sample.xls"   # required, absolute or relative to this file; supports: xls

# TODO: reconcile model_title and model_name with the new *_filename parameters

  model_title "Sample Data"  # optional, generated from file_name
  model_name  "sampleData"   # optional, generated from model_title

  # defaults
  file_name_convention   'lowerCamelCase'  # for the model filemame
  table_name_convention  'snake_case'
  column_name_convention 'snake_case'

  model_filename     'sampleData'         # extension .js added
  migration_filename 'create-sample-data' # extension .js added
  sql_filename       'create_sample_data' # extension .sql added
  csv_filename       'sampleData'         # extension .csv added

  # Defaults
  model       true         # all optional
  migration   true
  csv         true
  csv_header  false
  sql         true


  # TODO: Need more tests on heading title and column_name uniqueness

  # optional, only columns which require special attention need a transform
  transform "Heading Title",          # case is ignored; leading/trailing spaces are ignored
                                      #   multiple white-space runs converted to single space
    column_name: "a_string",          # optional, default generated snake_case
    column_type: "a_string",          # optional, default 'string', 'date' depending on name
    converter: Proc.new { |a_value|   # optional, default is lowercase everything
        a_value.downcase
      }

  transform "Heading Title Two", 
    column_name: "a_string",          # optional, default generated snake_case
    column_type: "a_string",          # optional, default 'string', 'date' depending on name
    converter: Proc.new { |a_value|   # optional, default is lowercase everything
        a_value.downcase
      }

  transform "Heading Title Three", 
    column_name: "a_string",           # optional, default generated snake_case
    column_type: "a_string",           # optional, default 'string', 'date' depending on name
    converter: lambda(&method(:xyzzy)) # you may use a shared converter

  transform "Heading Title Four", 
    column_name: "a_string",           # optional, default generated snake_case
    column_type: "a_string"            # optional, default 'string', 'date' depending on name

  transform 'billing rate (per hour)',
    column_name: 'day_rate',
    column_type: 'float',
    converter: Proc.new { |a_value|
      a_value * 8.0
    }

end # end of JsModelGenConfig.new do

