module JsModelGenerator
  # Generate SQL to create the table
  class Sql
    using Refinements

    @@add_columns = configatron.to_h[:params][:add_columns]

    class << self

  def add_column?(column_name)
    @@add_columns[column_name]
  end

  def default_type(column_name)
    lc_column_name = column_name.downcase
    if lc_column_name.end_with?('date') ||
       lc_column_name.start_with?('date')
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

        sql_file.puts <<~EOS
          -- ==============================================================
          -- == File: #{filename}

          DROP TABLE IF EXISTS #{title.variablize('snake_case')};

          CREATE TABLE "public"."#{title.variablize('snake_case')}" (
        EOS

        if add_column? :id
          sql_file.puts %Q[  "id"        INTEGER DEFAULT nextval('#{title.variablize('snake_case')}_id_seq'::regclass) NOT NULL UNIQUE,]
        end

        if add_column? :unique_id
          sql_file.puts %Q[  "unique_id" CHARACTER VARYING( 255 ) COLLATE "pg_catalog"."default",]
        end

        sql_file.puts '--'
        column_names.each do |col_name|
          spaces = " " * (max_size - col_name.size + 2)
          sql_file.print %Q'  "#{col_name}" ' + spaces + get_type(col_name)
          # SMELL: must we always mod the source when new additional columns are added after spreadsheet?
          # TODO: need to have some kind of before and after feature for the added columns.
          if  !(col_name == column_names.last) ||
              add_column?(:report_date)  ||
              add_column?(:created_at)   ||
              add_column?(:updated_at)
            sql_file.puts ','
          else
            sql_file.puts
          end
        end
        sql_file.puts '--'

        # SNELL: the last column name does not get a comma; but don't know which is last

        if add_column? :report_date
          sql_file.print '"report_date" Date'
          if add_column?(:created_at)  ||  add_column?(:updated_at)
            sql_file.puts ","
          else
            sql_file.puts
          end
        end


        if add_column? :created_at
          sql_file.print '"created_at"  Date'
          if add_column?(:updated_at)
            sql_file.puts ","
          else
            sql_file.puts
          end
        end


        if add_column? :updated_at
          sql_file.puts '"updated_at"  Date'
        end

        if add_column? :id
          sql_file.puts '  PRIMARY KEY ( "id" )'
        end

        sql_file.print ");\n\n"

        sql_file.close


ap  @@add_columns  if verbose? || debug?


      end # def generate

    end # class << self
  end # class Sql
end # module JsModelGenerator
