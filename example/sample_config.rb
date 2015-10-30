
JsModelGenConfig.new{ |c|

  c.file_name  = a_string     # required, supports: xls
  c.model_title= a_string     # optional, generated from file_name
  c.model_name = a_string     # optional, generated from model_title

  # Defaults
  c.model      = true         # all optional
  c.migration  = true
  c.csv        = true
  c.csv_header = false
  c.sql        = true

  c.transforms = {
    "Heading Title" => {      # optional, only columns which require special attention
      column_name: a_string,  # optional, default generated snake_case
      column_type: a_string,  # optional, default 'string', 'date' depending on name
      converter: Proc.new do |a_value|  # optional, default is lowercase everything
        a_value.downcase
      end
    }
  }

} # end of JsModelGenConfig.new{ |c|

