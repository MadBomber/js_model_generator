module JsModelGenerator
class CSV
class << self

def generate

  # TODO: complete the method
  
##############################################################
## Generating a csv file

file_name = variable_name_of(table_title, :snake_case) + '.csv'
csv_file  = File.open(file_name, 'w')

# Header
# SMELL: The ops-review startup seed process does not use a header row.  It
#        gets its column order from the table_name.model.js file.
#csv_file.puts (leader_names+column_names+follower_names).join(',')

expected_columns_base   = column_names.size
number_of_added_columns = 5 # id, unique_id, report_date, created_at, updated_at
expected_columns    = expected_columns_base + number_of_added_columns

debug_me{[  :expected_columns_base, 
      :number_of_added_columns, 
      :expected_columns, 
      :column_names ]}


id = -1

c1 = 13 # zero-based 'N'
c2 = 18 # 'S'
lsize = 2

sheet1.each do |row|
  id += 1

  raw_d  = row.to_a
  debug_me{[ 'raw_d[c1]', 'raw_d[c2]' ]} if 0 == id
  ap raw_d if 0 == id

  next if 0 == id
  a_line = ''


  data   = [ id, UUIDTools::UUID.random_create.to_s ] + # id and unique_id
         transform(raw_d, column_names) +         # transformed row values
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
    if v.respond_to?(:downcase)
      v = v.chomp.gsub("\n",' ').strip.downcase.gsub('"',"'")
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


end # def generate

end # class << self
end # class CSV
end # module JsModelGenerator
