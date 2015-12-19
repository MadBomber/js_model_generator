module JsModelGenerator
class Migration
  using Refinements

class << self

  def default_type(column_name)
    type = 'Sequelize.'
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
        type = JsModelGenerator::TYPES[type][:sequelize]
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
        filename       = options[:migration][:filename]
        header         = options[:migration][:header]

        @transforms    = options[:transforms]
        @converter     = options[:converter]

        # TODO: complete the method

        mig_file  = File.open(filename.to_s,'w')

mig_file.puts <<EOS
// =========================================================
// == File: $PROJ_ROOT/db/migrate/#{filename}

'use strict';
var Promise = require('bluebird');

module.exports = {
  up: function (queryInterface, Sequelize) {
    return new Promise(function (resolve, reject) {
      queryInterface.createTable(
        '#{title.variablize('snake_case')}',
        {
          id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
          },
          unique_id: {
            type: Sequelize.STRING,
            unique: true
          },
EOS


column_names.each do |col_name|
  mig_file.puts "          #{col_name}: #{get_type(col_name)},"
end


mig_file.puts <<EOS
          report_date: Sequelize.DATE,
          created_at: Sequelize.DATE,
          updated_at: Sequelize.DATE
        })
        .then(function () {
          queryInterface.sequelize.query("ALTER TABLE #{title.variablize('snake_case')} OWNER TO insighter;")
            .then(resolve)
            .catch(reject);
        })
        .catch(reject);
    });
  },

  down: function (queryInterface) {
    return new Promise(function(resolve, reject) {
      queryInterface.dropTable("#{title.variablize('snake_case')}")
        .then(resolve)
        .catch(reject);
    });
  }
};


EOS

mig_file.close



end # def generate

end # class << self
end # class Migration
end # module JsModelGenerator
