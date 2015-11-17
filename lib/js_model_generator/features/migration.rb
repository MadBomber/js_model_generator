module JsModelGenerator
class Migration
  using Refinements

class << self

      def generate(options)
        title          = options[:title]
        leader_names   = options[:leader_names]
        column_names   = options[:column_names]
        headings       = options[:headings]
        follower_names = options[:follower_names]
        headings       = options[:headings]
        filename       = options[:migration][:filename]
        header         = options[:migration][:header]

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
  mig_file.print "          #{col_name}: Sequelize."
  if col_name.downcase.end_with?('date')
    mig_file.print "DATE"
  else
    mig_file.print "STRING"
  end
  mig_file.puts ','
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
