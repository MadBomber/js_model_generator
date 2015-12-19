module JsModelGenerator
  # Generate SQL to create the table
  class Sql
    using Refinements

    class << self


  def default_type(column_name)
    if column_name.downcase.end_with?('date')
      type = "Date"
    else
      type = 'CHARACTER VARYING( 255 ) COLLATE "pg_catalog"."default"'
    end
    return type
  end

  def get_type(column_name)
    type = @transforms[column_name]
    unless type.nil?
      type = type[:type].to_s.downcase
      begin
        type = JsModelGenerator::TYPES[type][:sql]
      rescue
        debug_me "))))) boom (((((("
        type = nil
      end
    end
    type = type.nil? ? default_type(column_name) : type
    return type
  end


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

        @transforms    = options[:transforms]
        @converter     = options[:converter]


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
          sql_file.puts %Q'  "#{col_name}" ' + spaces + get_type(col_name) + ','
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
