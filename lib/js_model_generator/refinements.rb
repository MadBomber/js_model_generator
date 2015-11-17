module JsModelGenerator

  ACRONYMS = %w[ ops nps csc csra ].map &:upcase

  def acronym_regex
    /#{ACRONYMS.join('|')}/
  end

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

      def /(a_string)
        self + '/' + a_string
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


      # Capitalizes all the words and replaces some characters in the string to
      # create a nicer looking title. +titleize+ is meant for creating pretty
      # output. It is not used in the Rails internals.
      #
      # +titleize+ is also aliased as +titlecase+.
      #
      #   'man from the boondocks'.titleize   # => "Man From The Boondocks"
      #   'x-men: the last stand'.titleize    # => "X Men: The Last Stand"
      #   'TheManWithoutAPast'.titleize       # => "The Man Without A Past"
      #   'raiders_of_the_lost_ark'.titleize  # => "Raiders Of The Lost Ark"
      def titleize
        self.underscore.humanize.gsub(/\b(?<!['’`])[a-z]/) { $&.capitalize }
      end

      # Tweaks an attribute name for display to end users.
      #
      # Specifically, +humanize+ performs these transformations:
      #
      #   * Applies human inflection rules to the argument.
      #   * Deletes leading underscores, if any.
      #   * Removes a "_id" suffix if present.
      #   * Replaces underscores with spaces, if any.
      #   * Downcases all words except acronyms.
      #   * Capitalizes the first word.
      #
      # The capitalization of the first word can be turned off by setting the
      # +:capitalize+ option to false (default is true).
      #
      #   'employee_salary'.humanize()              # => "Employee salary"
      #   'author_id'.humanize()                    # => "Author"
      #   'author_id'.humanize(capitalize: false)   # => "author"
      #   '_id'.humanize()                          # => "Id"
      #
      # If "SSL" was defined to be an acronym:
      #
      #   'ssl_error'.humanize() # => "SSL error"
      #
      def humanize(options = {})
        result = self.dup

        #inflections.humans.each { |(rule, replacement)| break if result.sub!(rule, replacement) }

        result.sub!(/\A_+/, '')
        result.sub!(/_id\z/, '')
        result.tr!('_', ' ')

        #result.gsub!(/([a-z\d]*)/i) do |match|
        #  "#{inflections.acronyms[match] || match.downcase}"
        #end

        if options.fetch(:capitalize, true)
          result.sub!(/\A\w/) { |match| match.upcase }
        end

        result
      end

      # Makes an underscored, lowercase form from the expression in the string.
      #
      # Changes '::' to '/' to convert namespaces to paths.
      #
      #   'ActiveModel'.underscore         # => "active_model"
      #   'ActiveModel::Errors'.underscore # => "active_model/errors"
      #
      # As a rule of thumb you can think of +underscore+ as the inverse of
      # +camelize+, though there are cases where that does not hold:
      #
      #   'SSLError'.underscore.camelize # => "SslError"
      def underscore
        camel_cased_word = self.dup
        return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
        word = camel_cased_word.to_s.gsub(/::/, '/')
        word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)(#{acronym_regex})(?=\b|[^a-z])/) { "#{$1 && '_'}#{$2.downcase}" }
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

    end # refine String
  end # module Refinements
end # module JsModelGenerator
