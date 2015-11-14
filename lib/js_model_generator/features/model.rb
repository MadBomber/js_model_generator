
module JsModelGenerator
class Model
class << self
  
# String ........... table_title
# Array[Strings] ... column_names
def generate(table_title, column_names)

file_name = "#{table_title.variablize('lowerCamelCase')}.model.js"
mod_file  = File.open(file_name,'w')

mod_file.puts <<EOS

// ==================================================================
// File: $PROJ_ROOT/server/models/#{file_name}

module.exports = function(sequelize, DataTypes) {
  return sequelize.define("#{table_title.variablize('CamelCase')}", {
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
    tableName: '#{table_title.variablize('snake_case')}',
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
end # module JsModelGenerator
