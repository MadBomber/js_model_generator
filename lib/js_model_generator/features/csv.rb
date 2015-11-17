module JsModelGenerator
  class Csv
    using Refinements

    class GottaNull < Exception; end

    class << self

      def generate(options)
        title          = options[:title]
        leader_names   = options[:leader_names]
        column_names   = options[:column_names]
        headings       = options[:headings]
        follower_names = options[:follower_names]
        headings       = options[:headings]
        filename       = options[:csv][:filename]
        header         = options[:csv][:header]

        @transforms    = options[:transforms]
        @converter     = options[:converter]

##############################################################
## Generating a csv file

csv_file  = File.open(filename.to_s, 'w')

# Header
# SMELL: The ops-review startup seed process does not use a header row.  It
#        gets its column order from the table_name.model.js file.

csv_file.puts (leader_names+column_names+follower_names).join(',') if header

expected_columns_base   = column_names.size
number_of_added_columns = configatron.params[:leader_names].size +
                          configatron.params[:follower_names].size
expected_columns        = expected_columns_base + number_of_added_columns

id = -1

c1 = 13 # zero-based 'N'
c2 = 18 # 'S'
lsize = 2

options[:sheet].each do |row|
  id += 1

  raw_d  = row.to_a

  next if 0 == id
  a_line = ''


  data   = [ id, UUIDTools::UUID.random_create.to_s ] + # id and unique_id
         transform(id+1, raw_d, headings) +         # transformed row values
         ['2015-10-17', '2015-10-17', '2015-10-17']   # report_date, created_at, updated_at

  v1 = data[c1+lsize]
  v2 = data[c2+lsize]
  unless v1 == v2
    debug_me{[ :id, :v1, :v2 ]}
  end



  if data.size > expected_columns
    debug_me('ERROR'){[ :id, 'data.size' ]}
  end

  if 1100 == data.first
    field = data[expected_columns-3]
    field_size = field.size
    the_last_character = field[field_size-1,1]
    debug_me{[ :field, :field_size, :the_last_character,
      'the_last_character.size',
      'the_last_character.ord'
     ]}
  v1 = data[c1+lsize]
  v2 = data[c2+lsize]
  #unless v1 == v2
    debug_me{[ :id, :v1, :v2 ]}
  #end

  end





  data.each do |v|
    if String == v.class
      unless v.empty?
        v = "\"#{v}\""
      end
    else
      v = v.to_s
    end
    a_line += v + ','
  end

  x = a_line.size
  csv_file.puts a_line[0,x-1] # MAGIC: remove the last comma equals 2
end

csv_file.close

abort_if_errors

end # def generate


def transform(row_number, a_value_array, a_name_array, max_string_size=255)
  raise ArgumentError unless Array == a_value_array.class && Array == a_name_array.class
  raise "Size mismatch: v: #{a_value_array.size} N: #{a_name_array.size}" unless a_value_array.size == a_name_array.size

  a_name_array.size.times do |x|

    heading = a_name_array[x]
    value   = a_value_array[x]

    transformer = @transforms[heading]

    if transformer
      if transformer[:converter]
        value = transformer[:converter].call(value)
      else
        value = @converter.call(value)
      end
      if transformer[:type]
        begin
          value = cast(transformer[:type], value, transformer[:null])
        rescue GottaNull
          warning "Row: #{row_number} Col: '#{heading}' is nil."
        end
      end
    else
      value = @converter.call(value)
    end

    a_value_array[x] = value

  end # a_name_array.size.times do |x|

  return a_value_array
end # def transform(a_value_array, a_name_array)


def cast(klass, value, allow_nil=true)
  return(value) if klass == value.class
  return(value) if allow_nil && value.nil?

  raise GottaNull if value.nil?

  eval("#{klass}(#{value})")
end

=begin
def default_converter(v)
  if v.respond_to?(:downcase)
    v = v.chomp.gsub("\n",' ').strip.downcase.gsub('"',"'")
  end
  return v
end
=end

end # class << self
end # class Csv
end # module JsModelGenerator
