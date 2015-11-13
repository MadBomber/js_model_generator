############################################
## sample_config.rb
#

# You may define shared converter methods
def xyzzy(a_value)
  "#{a_value} is now " + a_value.downcase
end

JsModelGenerator::Config.new do

  source   "sample_data.xls"   # required, absolute or relative to this file; supports: xls

  #title "Sample Data"  # optional, generated from file_name

  # conventions supported: lowerCamelCase, CamelCase, snake_case, tall-snake-case

             # Defaults ...........
  #model      #filename: 'sampleData',  convention: 'lowerCamelCase'
  #migration  #filename: 'sample-data', convention: 'tall-snake-case', prefix: 'create', ts: true
  csv        #filename: 'sampleData',  convention: 'lowerCamelCase', header: false
  sql        #filename: 'sample_data', convention: 'snake_case'


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
      a_value.to_f * 8.0
    }

end # JsModelGenerator::Config.new do

