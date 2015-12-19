# TODO: Consider wither or not the column_type value for the transorm is to be
#       error checked or not.  If so then a file like this might be needed.

# SMELL: This data structure is not used.

# Nothing fancy; if necessary the user is expected to hand modify the generated files.
module JsModelGenerator
  TYPES = {
  # valid type     converted to these
  	'boolean'  => {sql: 'BOOLEAN', model: 'DataTypes.BOOLEAN', sequelize: 'Sequelize.BOOLEAN'},
  	'date'     => {sql: 'DATE',    model: 'DataTypes.DATE',    sequelize: 'Sequelize.DATE'},
  	'float'    => {sql: 'FLOAT',   model: 'DataTypes.FLOAT',   sequelize: 'Sequelize.FLOAT'},
  	'integer'  => {sql: 'INTEGER', model: 'DataTypes.INTEGER', sequelize: 'Sequelize.INTEGER'},
  	'string'   => {sql: 'STRING',  model: 'DataTypes.STRING',  sequelize: 'Sequelize.STRING'},
  	'text'     => {sql: 'TEXT',    model: 'DataTypes.TEXT',    sequelize: 'Sequelize.TEXT'},
  }

  SQL_TYPES       = TYPES.map{|k,v| v[:sql]}
  MODEL_TYPES     = TYPES.map{|k,v| v[:model]}
  SEQUELIZE_TYPES = TYPES.map{|k,v| v[:sequelize]}
end # module JsModelGenerator