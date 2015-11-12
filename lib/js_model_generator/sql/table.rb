module JsModelGenerator
  module Sql
    class Table
      class << self

        # String ........... table_title
        # Array[Strings] ... column_names
        def generate(table_title, column_names)


          # TODO: complete the method

          file_name = "#{table_title.variablize('snake_case')}.sql"
          sql_file  = File.open(file_name, 'w')

sql_file.puts <<EOS
-- ==============================================================
-- == File: #{file_name}

DROP TABLE IF EXISTS #{table_title.variablize('snake_case')};


SMELL: table name is hardcoded


CREATE TABLE "public"."contingent_staffing_data" (
"id" INTEGER DEFAULT nextval('#{table_title.variablize('snake_case')}_id_seq'::regclass) NOT NULL UNIQUE,
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
