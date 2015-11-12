
module JsModelGenerator
module Sequelize
class Model
class << self
  
def generate

file_name = "#{variable_name_of(table_title, :lowerCamelCase)}.model.js"
mod_file  = File.open(file_name,'w')

mod_file.puts <<EOS

// ==================================================================
// File: $PROJ_ROOT/server/models/#{variable_name_of(table_title, :lowerCamelCase)}.model.js

module.exports = function(sequelize, DataTypes) {
  return sequelize.define("#{variable_name_of(table_title, :CamelCase)}", {
    id:        {type: DataTypes.INTEGER, unique: true},
    unique_id: {type: DataTypes.STRING,  unique: true},
EOS

=begin
# Basic javascript/serialize data types are:
	DataTypes.BOOLEAN
	DataTypes.DATE
	DataTypes.DECIMAL
	DataTypes.FLOAT
	DataTypes.INTEGER
	DataTypes.JSON
	DataTypes.STRING
	DataTypes.TEXT
	DataTypes.VIRTUAL
=end

column_names.each do |col_name|
  mod_file.print "    #{col_name}: DataTypes."
  if col_name.downcase.end_with?('date')
  	mod_file.print "DATE"
  else
  	mod_file.print "STRING"
  end
  mod_file.puts ','
end

mod_file.puts <<EOS
    report_date: DataTypes.DATE,
    created_at: DataTypes.DATE,
    updated_at: DataTypes.DATE
  }, {
    underscored: true,
    tableName: '#{variable_name_of(table_title, :snake_case)}',
    indexes: [
      {fields: ['report_date']}
    ]
  })
};


EOS

mod_file.close

end # def generate

end # class << self
end # class Model
end # module Sequelize
end # module JsModelGenerator
