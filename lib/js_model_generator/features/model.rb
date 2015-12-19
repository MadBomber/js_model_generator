
module JsModelGenerator
class Model
  using Refinements

class << self

  def default_type(column_name)
    type = 'DataTypes.'
    if column_name.downcase.end_with?('date')
      type += "DATE"
    else
      type += "STRING"
    end
    return type
  end

  def get_type(column_name)
    type = @transforms[column_name]
    unless type.nil?
      type = type[:type].to_s.downcase
      begin
        type = JsModelGenerator::TYPES[type][:model]
      rescue
        debug_me "))))) boom (((((("
        type = nil
      end
    end
    type = type.nil? ? default_type(column_name) : type
    return type
  end

      def generate(options)
        title          = options[:title]
        leader_names   = options[:leader_names]
        column_names   = options[:column_names]
        headings       = options[:headings]
        follower_names = options[:follower_names]
        headings       = options[:headings]
        filename       = options[:model][:filename]
        header         = options[:model][:header]

        @transforms    = options[:transforms]
        @converter     = options[:converter]



mod_file  = File.open(filename.to_s,'w')

mod_file.puts <<EOS

// ==================================================================
// File: $PROJ_ROOT/server/models/#{filename}

module.exports = function(sequelize, DataTypes) {
  return sequelize.define("#{title.variablize('CamelCase')}", {
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
  mod_file.puts "    #{col_name}: #{get_type(col_name)},"
end

mod_file.puts <<EOS
    report_date: DataTypes.DATE,
    created_at: DataTypes.DATE,
    updated_at: DataTypes.DATE
  }, {
    underscored: true,
    tableName: '#{title.variablize('snake_case')}',
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
