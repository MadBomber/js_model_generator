module JsModelGenerator
module Sequelize
class Migration
class << self

def generate

  # TODO: complete the method

fn_prefix = DateTime.now.strftime("%Y%m%d%H%M%S")

file_name = "#{fn_prefix}-create-#{variable_name_of(table_title, :snake_case).gsub('_','-')}.js"
mig_file  = File.open(file_name,'w')

mig_file.puts <<EOS
// =========================================================
// == File: $PROJ_ROOT/db/migrate/#{fn_prefix}-create-#{variable_name_of(table_title, :snake_case).gsub('_','-')}.js

'use strict';
var Promise = require('bluebird');

module.exports = {
  up: function (queryInterface, Sequelize) {
    return new Promise(function (resolve, reject) {
      queryInterface.createTable(
        '#{variable_name_of(table_title, :snake_case)}',
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
          queryInterface.sequelize.query("ALTER TABLE #{variable_name_of(table_title, :snake_case)} OWNER TO insighter;")
            .then(resolve)
            .catch(reject);
        })
        .catch(reject);
    });
  },

  down: function (queryInterface) {
    return new Promise(function(resolve, reject) {
      queryInterface.dropTable("#{variable_name_of(table_title, :snake_case)}")
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
end # module Sequelize
end # module JsModelGenerator
