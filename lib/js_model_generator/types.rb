# TODO: Consider wither or not the column_type value for the transorm is to be
#       error checked or not.  If so then a file like this might be needed.

# Nothing fancy; if necessary the user is expected to hand modify the generated files.
module JsModelGenerator
  TYPES = {
  # valid type     converted to these
  	'boolean'  => {sql: 'BOOLEAN', model: 'DataTypes.BOOLEAN', migration: 'Sequelize.BOOLEAN'},
  	'date'     => {sql: 'DATE',    model: 'DataTypes.DATE',    migration: 'Sequelize.DATE'},
  	'float'    => {sql: 'FLOAT',   model: 'DataTypes.FLOAT',   migration: 'Sequelize.FLOAT'},
  	'integer'  => {sql: 'INTEGER', model: 'DataTypes.INTEGER', migration: 'Sequelize.INTEGER'},
  	'string'   => {sql: 'STRING',  model: 'DataTypes.STRING',  migration: 'Sequelize.STRING'},
  	'text'     => {sql: 'TEXT',    model: 'DataTypes.TEXT',    migration: 'Sequelize.TEXT'},
  }

  SQL_TYPES       = TYPES.map{|k,v| v[:sql]}
  MODEL_TYPES     = TYPES.map{|k,v| v[:model]}
  SEQUELIZE_TYPES = TYPES.map{|k,v| v[:migration]}
end