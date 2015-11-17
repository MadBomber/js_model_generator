############################################
## sample_config.rb
#

# You may define shared converter methods
def xyzzy(a_value)
  a_value.upcase
end

JsModelGenerator::Config.new do

  # value of putdir is scanned to replace $XXX with Nenv.XXX
  # value of putdir is pre-pended to all relative out filenames.
  # value of global outdir is pre-pended to all relative feature outdir
  # if outdir does not exist AND create: is true then creat the outdir

  outdir '$HOME/temp/jsmodgen_output', create: true

  source   "sample_data.xls"   # required, absolute or relative to this file; supports: xls

  title "Sample Data"  # optional, generated from source

  # conventions supported: lowerCamelCase, CamelCase, snake_case, tall-snake-case
  column_name_convention 'snake_case' # default: 'snake_case'

             # Defaults ...........
  model      # outdir: `pwd`, filename: 'sampleData',  convention: 'lowerCamelCase'
  migration  # outdir: `pwd`, filename: 'sample-data', convention: 'tall-snake-case', prefix: 'create', ts: true
  csv        # outdir: `pwd`, filename: 'sampleData',  convention: 'lowerCamelCase', header: false
  sql        # outdir: `pwd`, filename: 'sample_data', convention: 'snake_case'

  # default converter is used for every column that does not have
  # a specific converter.  The value of the block will be the value
  # of the value returned. This is what the default converter does:
  # converter do |value|
  #   if value.respond_to?(:downcase)
  #     value = value.chomp.gsub("\n",' ').strip.downcase.gsub('"',"'")
  #   end
  #   return value
  # end

  # optional, only columns which require special attention need a transform
  transform "An Interger Title",      # case is ignored; leading/trailing spaces are ignored
                                      #   multiple white-space runs converted to single space
    name:      "id_times_100",        # optional, default generated snake_case
    type:      Integer,               # optional, default 'string', 'date' depending on name
    null:      true,
    converter: Proc.new { |a_value|   # optional, default converter is lowercase everything
        a_value.nil? ? a_value : a_value * 100
      }

  transform "store open",
    converter: Proc.new { |a_value|
        'yes' == a_value ? true : false
      }

  transform "Day of the Week",
    name:      "a_string",             # optional, default generated snake_case
    type:      String,                 # optional, default 'string', 'date' depending on name
    converter: lambda(&method(:xyzzy)) # you may use a shared converter

  transform "Heading Title Four",
    name: "a_string",           # optional, default generated snake_case
    type: String                # optional, default 'string', 'date' depending on name

  transform 'billing rate',
    name:      'day_rate',
    type:      Float,
    converter: Proc.new { |a_value|
      a_value.to_f * 8.0
    }

end # JsModelGenerator::Config.new do

