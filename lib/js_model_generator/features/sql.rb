module JsModelGenerator
  # Generate SQL to create the table
  class Sql
    using Refinements

    class << self
      # String ........... table_title
      # Array[Strings] ... column_names
      def generate(options)
        title          = options[:title]
        # leader_names   = options[:leader_names]
        column_names   = options[:column_names]
        # headings       = options[:headings]
        # follower_names = options[:follower_names]
        # headings       = options[:headings]
        filename       = options[:sql][:filename]
        # header         = options[:sql][:header]

        max_size = -1
        column_names.each { |cn| max_size = cn.size if cn.size > max_size }

        sql_file  = File.open(filename.to_s, 'w')

sql_file.puts <<EOS
-- ==============================================================
-- == File: #{filename}

DROP TABLE IF EXISTS #{title.variablize('snake_case')};

CREATE TABLE "public"."#{title.variablize('snake_case')}" (
  "id"        INTEGER DEFAULT nextval('#{title.variablize('snake_case')}_id_seq'::regclass) NOT NULL UNIQUE,
  "unique_id" CHARACTER VARYING( 255 ) COLLATE "pg_catalog"."default"
--
EOS

        column_names.each do |col_name|
          spaces = " " * (max_size - col_name.size + 2)
          sql_file.print %Q'  "#{col_name}" ' + spaces
          if col_name.downcase.end_with?('date')
            sql_file.print 'Date'
          else
            sql_file.print 'CHARACTER VARYING( 255 ) COLLATE "pg_catalog"."default"'
          end
          sql_file.puts ','
        end


sql_file.puts <<EOS
--
  "report_date" Date,
  "created_at"  Date,
  "updated_at"  Date
  PRIMARY KEY ( "id" )
);

EOS

        sql_file.close

      end # def generate

    end # class << self
  end # class Sql
end # module JsModelGenerator
