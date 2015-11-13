############################################
## config.rb
##
## Establish the Configuration DSL
#

require_relative 'refinements'

module JsModelGenerator 

class Config
  using Refinements

  TRANSFORM_HASH_KEYS = {
    column_name: String,
    column_type: String,
    converter:   Proc
  }

  FEATURES = %w[ model migration sql csv ]


  def initialize( &block )
    @params = {
	  file_name:   "",
	  model_title: "",
	  model:       {},
	  migration:   {},
	  csv:         {header: false},
	  sql:         {},
	  transforms:  {}
    }
    
    evaluate(&block) if block_given?

  end


  def evaluate(&block)
    @self_before_instance_eval = eval "self", block.binding
    instance_eval &block
  end


  def method_missing(method, *args, &block)
    @self_before_instance_eval.send method, *args, &block
  end


  def file_name_convention(a_string)
    # TODO: i dunnot know what I was thinking
    get_location
    unless String == a_string.class
      error "Expected a String #{location}"
    else
      unless a_string.valid_naming_convention?
        error "#{a_string} is not a supported naming convention #{location}"
      else
        @params[:file_name_convention] = a_string
      end
    end
  end


  def table_name_convention(a_string)
    # TODO: i dunnot know what I was thinking
    get_location
    unless String == a_string.class
      error "Expected a String #{location}"
    else
      unless a_string.valid_naming_convention?
        error "#{a_string} is not a supported naming convention #{location}"
      else
        @params[:table_name_convention] = a_string
      end
    end
  end

  
  def column_name_convention(a_string)
    # TODO: i dunnot know what I was thinking
    get_location
    unless String == a_string.class
      error "Expected a String #{location}"
    else
      unless a_string.valid_naming_convention?
        error "#{a_string} is not a supported naming convention #{location}"
      else
        @params[:column_name_convention] = a_string
      end
    end
  end


  def source(a_string)
  	get_location
  	unless String == a_string.class
      error "Expected a String #{location}"
    else
      a_path = Pathname.new(a_string.strip)
      unless a_path.absolute?
      	a_path = configatron.config.parent + a_path
      end
      unless a_path.exist?
        error "File does not exist #{location}"
      else
        unless '.xls' == a_path.extname.to_s.downcase
          error "File is not of type *.xls #{location}"
        else
          @params[:source] = a_path
        end
      end
    end
  end


  def title(a_string)
  	get_location
  	unless String == a_string.class
      error "Expected a String #{location}"
  	else
  	  @params[:title] = a_string
  	end
  end


  def model(options={})
  	get_location
    # TODO: validate options
    @params[:model] = {
        # TODO: add defaults
        convention: 'lowerCamelCase',
        extension:  '.js'
      }.merge(options)
  end


  def migration(options={})
    get_location
    # TODO: validate options
    @params[:migration] = {
        # TODO: add defaults
        ts:         true,
        prefix:     'create', 
        convention: 'tall-snake-case',
        extension:  '.js'
      }.merge(options)
  end


  def csv(options={})
    get_location
    # TODO: validate options
    @params[:csv] = {
        # TODO: add defaults
        convention: 'lowerCamelCase',
        header:     false,
        extension:  '.csv'
      }.merge(options)
  end


  def sql(options={})
    get_location
    # TODO: validate options
    @params[:sql] = {
        # TODO: add defaults
        convention: 'snake_case',
        extension:  '.sql'
      }.merge(options)
  end


  def transform(a_string, a_hash)
  	get_location
  	unless String == a_string.class
      error "Expected a String for the column heading; got #{a_string.class} #{location}"
  	else
  	  if @params[:transforms].include? a_string
        error "Duplicate transform for #{a_string} #{location}"
  	  else
        unless Hash == a_hash.class
          error "Expected a Hash; got #{a_hash.class} #{location}"
        else
          error_cnt  = errors.size
          valid_keys = TRANSFORM_HASH_KEYS.keys
          a_hash.keys.each do |a_key|
          	unless valid_keys.include? a_key
              error "#{a_key} is not one of #{valid_keys.join(', ')} #{location}"
            else
              unless TRANSFORM_HASH_KEYS[a_key] == a_hash[a_key].class
                error "Expected type #{TRANSFORM_HASH_KEYS[a_key]} for #{a_key} value; got #{a_hash  [  a_key].class} #{location}"
              end
            end
          end
          unless errors.size > error_cnt        
            @params[:transforms][a_string] = a_hash
          end
        end
      end
    end
  end


  def convert_naming_convention(a_string)
    a_string.to_sym
  end


  def get_location
    parts = caller[1].split(':')
    @location = "Near Line # #{parts[1]} in file #{parts[0]}"
  end


  def location
    @location
  end


  def params
    @params
  end


end # class Config

end # module JsModelGenerator 
