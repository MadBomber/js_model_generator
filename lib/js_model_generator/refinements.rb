module JsModelGenerator 
  module Refinements
    
    refine String do
      VALID_NAMING_CONVENTIONS = %w[
        lowerCamelCase
        CamelCase
        snake_case
        tall-snake-case
      ]
  
      def valid_naming_convention?
        VALID_NAMING_CONVENTIONS.include?(self)
      end


      # Takes an optional convention and returns a
      # string suitable as a variable name in the convention.
      # The support conventions are:
      #   snake_case (default)
      #   tall-snake-case
      #   CamelCase
      #   lowerCamelCase
      #  Any text between parans is removed.
      #  Any non-alphanumberic is removed.

      def variablize(convention = 'snake_case')
        unless convention.valid_naming_convention?
          error "Invalid naming convention: #{convention}; supported: #{VALID_NAMING_CONVENTIONS.join(', ')}"
          return nil  # SMELL: is this check just paranoid
        end
        if include?('(')
          p_start = index('(')
          p_end   = index(')')
          self[p_start..p_end] = ''
        end
        parts = self.downcase.gsub(/[^0-9a-z ]/, ' ').squeeze(' ').split
        case convention
          when 'lowerCamelCase' 
            parts.size.times do |x|
              next unless x>0
              parts[x][0] = parts[x][0].upcase
            end
            variable_name = parts.join
          when 'CamelCase' 
            parts.size.times do |x|
              parts[x][0] = parts[x][0].upcase
            end
            variable_name = parts.join    
          when 'snake_case' 
            variable_name = parts.join('_')
          when 'tall-snake-case'
            variable_name = parts.join('-')
          else
            raise ArgumentError, "Invalid Convention: #{convention}"
        end

        return variable_name
      end # def variablize(convention = 'snake_case')

    end # refine String





  end # module Refinements
end # module JsModelGenerator
