############################################
## sample_config.rb
#

# You may define shared converter methods
def xyzzy(a_value)
  "#{a_value} is now " + a_value.downcase
end

JsModelGenConfig.new do

  file_name   "sample.xls"   # required, absolute or relative to this file; supports: xls
  model_title "Sample Data"  # optional, generated from file_name
  model_name  "sampleData"   # optional, generated from model_title

  # Defaults
  model       true         # all optional
  migration   true
  csv         true
  csv_header  false
  sql         true

  # optional, only columns which require special attention need a transform
  transform "Heading Title", 
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


end # end of JsModelGenConfig.new do

