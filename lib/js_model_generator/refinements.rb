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
    end # refine String

  end # module Refinements
end # module JsModelGenerator
