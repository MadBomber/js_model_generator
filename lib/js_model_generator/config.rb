############################################
## config.rb
##
## Establish the Configuration DSL
#

require_relative 'refinements'

module JsModelGenerator

  class Config
    using Refinements

    TRANSFORM_HASH_KEYS = { # array of valid value classes
      null:        [TrueClass, FalseClass],
      name:        [String],
      type:        [Class],
      converter:   [Proc]
    }

    FEATURE_DEFAULTS = {
      add_columns: {
        id:         false,  # sequential integer
        unique_id:  false,  # uuid
        created_at: false,  # date
        updated_at: false   # date
      },
      model:       {
        generate:   false,
        convention: 'lowerCamelCase',
        extension:  '.js'
      },
      migration:   {
        ts:         true,
        prefix:     'create',
        generate:   false,
        convention: 'tall-snake-case',
        extension:  '.js'
      },
      csv:         {
        gemerate:   false,
        convention: 'lowerCamelCase',
        header:     false,
        extension:  '.csv'
      },
      sql:         {
        generate:   false,
        convention: 'snake_case',
        extension:  '.sql'
      }
    }

    FEATURES = FEATURE_DEFAULTS.keys.map{|k| k.to_s}

    def initialize( &block )
      @params = {
        column_name_convention: 'snake_case',
        converter:   lambda(&method(:default_converter)),
        transforms:  {}
      }.merge FEATURE_DEFAULTS

      evaluate(&block) if block_given?
    end


    def evaluate(&block)
      @self_before_instance_eval = eval "self", block.binding
      instance_eval &block
    end


    def method_missing(method, *args, &block)
      @self_before_instance_eval.send method, *args, &block
    end


    # SMELL: not documented - not used
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


    # specify the naming convention to be used to column names.
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


    # identify the *.xls file which is the source of data
    # can be over-riden on the command line
    # TODO: add support for *.xlsx and *.csv files
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

    # A title to use when generating filenames.
    # optional.  Can be derived from source
    def title(a_string)
      get_location
      unless String == a_string.class
        error "Expected a String #{location}"
      else
        @params[:title] = a_string
      end
    end

    def outdir(a_string, options={})
      get_location
      options = {create: false}.merge options
      unless String == a_string.class
        error "Expected a String #{location}"
      else
        a_string = a_string.gsub('$','Nenv.')
        a_string = a_string.split('/').map do |sd|
          sd.start_with?('Nenv.') ? sd : "\"#{sd}\""
        end.join('/')

        a_path = Pathname.new( eval(a_string) )
        `mkdir -p #{a_path}` if options[:create] && !a_path.exist?

        unless a_path.exist?
          error "Directory does not exist: #{a_path} #{location}"
        else
         @params[:outdir] = a_path
       end
      end

    end


    # add additional columns not found in the spreadsheet
    def add_columns(*new_columns)
      options = Hash.new
      new_columns.each {|c| options[c] = true}
      @params[:add_columns] = FEATURE_DEFAULTS[:add_columns].merge(options)
    end

    # generate a model definition file
    def model(options={})
      get_location
      # TODO: validate options
      @params[:model] = FEATURE_DEFAULTS[:model].merge(options)
      @params[:model][:generate] = true
    end


    # generate a migration file
    def migration(options={})
      get_location
      # TODO: validate options
      @params[:migration] = FEATURE_DEFAULTS[:migration].merge(options)
      @params[:migration][:generate] = true
    end


    # generate a CSV file
    def csv(options={})
      get_location
      # TODO: validate options
      @params[:csv] = FEATURE_DEFAULTS[:csv].merge(options)
      @params[:csv][:generate] = true
    end


    # generate an SQL file for create table
    def sql(options={})
      get_location
      # TODO: validate options
      @params[:sql] = FEATURE_DEFAULTS[:sql].merge(options)
      @params[:sql][:generate] = true
    end


    # establish a user-supplied default converter procedure
    def converter(a_lamda=nil, &block)
      if a_lamda.nil?
        if block_given?
          # TODO: same the block in such a way that it can be called
          @params[:converter] = block
        else
          error "converter statement without a procedure #{location}"
        end
      else
        unless Proc == a_lamda.class
          error "converter expects a proc/lamda but got a #{a_lamda.class} #{location}"
        else
          @params[:converter] = a_lamda
        end
      end
    end


    # specify a column-specific transformation
    # support for null, name, type, converter procedure
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
            error_cnt  = configatron.errors.size
            valid_keys = TRANSFORM_HASH_KEYS.keys
            a_hash.keys.each do |a_key|
              unless valid_keys.include? a_key
                error "#{a_key} is not one of #{valid_keys.join(', ')} #{location}"
              else
                unless TRANSFORM_HASH_KEYS[a_key].include?(a_hash[a_key].class)
                  error "Expected type #{TRANSFORM_HASH_KEYS[a_key]} for #{a_key} value; got #{a_hash  [  a_key].class} #{location}"
                end
              end
            end
            unless configatron.errors.size > error_cnt
              @params[:transforms][a_string] = a_hash
            end
          end
        end
      end
    end


    # SMELL: don't think this is used
    def convert_naming_convention(a_string)
      a_string.to_sym
    end


    # get the location within the config file that is current being
    # processed
    def get_location
      parts = caller[1].split(':')
      @location = "Near Line # #{parts[1]} in file #{parts[0]}"
    end


    # return the last config file location processed
    def location
      @location
    end


    # return the params hash
    def params
      @params
    end


    # the default converter is used for all columns that do not
    # have a column-specific converter
    def default_converter(v)
      if v.respond_to?(:downcase)
        v = v.chomp.gsub("\n",' ').strip.downcase.gsub('"',"'")
      end
      return v
    end

  end # class Config
end # module JsModelGenerator
