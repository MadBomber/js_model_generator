module JsModelGenerator
module Sql
class Table
class << self

def generate

  # TODO: complete the method

file_name = "#{variable_name_of(table_title, :snake_case)}.sql"
sql_file  = File.open(file_name, 'w')

sql_file.puts <<EOS
-- ==============================================================
-- == File: #{variable_name_of(table_title, :snake_case)}.sql

DROP TABLE IF EXISTS #{variable_name_of(table_title, :snake_case)};

CREATE TABLE "public"."contingent_staffing_data" ( 
  "id" INTEGER DEFAULT nextval('#{variable_name_of(table_title, :snake_case)}_id_seq'::regclass) NOT NULL UNIQUE, 
  "unique_id" CHARACTER VARYING( 255 ) COLLATE "pg_catalog"."default"
EOS


column_names.each do |col_name|
  sql_file.print "  \"#{col_name}\" "
  if col_name.downcase.end_with?('date')
    sql_file.print "Date"
  else
    sql_file.print "CHARACTER VARYING( 255 ) COLLATE \"pg_catalog\".\"default\""
  end
  sql_file.puts ','
end


sql_file.puts <<EOS
  "report_date" Date,
  "created_at" Date,
  "updated_at" Date
 PRIMARY KEY ( "id" )
 );

EOS

sql_file.close




end # def generate

end # class << self
end # class Table
end # module Sql
end # module JsModelGenerator
