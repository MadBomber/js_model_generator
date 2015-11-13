#!/usr/bin/env ruby
# encoding: utf-8
##########################################################
###
##  File: js_model_generator_cli.rb
##  Desc: Create JavaScript-baed Sequelized models and migrations from XLS file
##  By:   Dewayne VanHoozer (dvanhoozer@gmail.com)
#

require_relative 'js_model_generator/refinements'
using JsModelGenerator::Refinements

require 'awesome_print'

require 'debug_me'
include DebugMe

require 'cli_helper'
include CliHelper

configatron.version = '0.0.1'

HELP = <<EOHELP
Important:

  The path to the *.xls file in the config file can be
  over-written by including the path on the command line.

EOHELP

cli_helper("Create JavaScript-baed Sequelized models and migrations from XLS file") do |o|
  o.bool    '-b', '--bool',   'example boolean parameter',   default: false
  o.path    '-c', '--config', 'Path to config file'
end

# Display the usage info
if  ARGV.empty?
  show_usage
  exit
end


# Error check you stuff; use error('some message') and warning('some message')


if configatron.config.nil?
  error 'A config file is required.  See --help'
else
  unless configatron.config.exist?
    error "Your config file does not exist: #{configatron.config}"
  else
  	unless '.rb' == configatron.config.extname.to_s.downcase
      error "Config file must be *.rb"
  	end
  end
end




configatron.input_files = get_pathnames_from( configatron.arguments, '.xls')

error "Only one over-ride file is allowed." if configatron.input_files.size > 1

abort_if_errors

def eval_script(pathname)
  proc = Proc.new {}
  result = eval(pathname.read, proc.binding, pathname.to_s) 
end

require_relative('js_model_generator/config')

configatron.params = eval_script(configatron.config).params

abort_if_errors




######################################################
# Local methods

def extend_filename(a_hash)
  filename    = a_hash[:filename]
  extension   = a_hash[:extension]
  prefix      = a_hash[:prefix]

  filename += a_hash[:extension] unless filename.end_with? extension

  sep = case a_hash[:convention]
          when 'snake_case'
            '_'
          when 'tall-snake-case'
            '-'
          else
            ''
        end

  unless prefix.nil?
    filename = a_hash[:prefix] + sep + filename unless filename.start_with? prefix
  end

  if a_hash[:ts]
    timestamp = DateTime.now.strftime("%Y%m%d%H%M%S")
    filename  = timestamp + sep + filename
  end

  return filename
end # def extend_filename(a_hash)


def check_filename(a_string)
  param_key = a_string.to_sym
  param     = configatron.params[param_key]
  unless param.nil?
    if param[:filename].nil?
      # TODO: build the filename from :model_title and convention
      # SMELL: :model_title may not exist
      if configatron.params[:model_title].nil?
        error "#{a_string} requested but filename was not provided"
      else
        model_title = configatron.params[:model_title]
        param[:filename] = model_title.variablize(param[:convention])
        configatron.params[param_key][:filename] = extend_filename(param)
        warning "Defaulting #{a_string} filename as: #{configatron.params[param_key][:filename]}"
      end
    else
      configatron.params[param_key][:filename] = extend_filename(param)
    end
  end
end


%w[ model migration sql csv ].each do |feature_request|
  check_filename(feature_request)
end

abort_if_errors

######################################################
# Main

at_exit do
  puts
  puts "Done."
  puts
end

ap configatron.to_h  if verbose? || debug?

stub = <<EOS


   d888888o. 8888888 8888888888 8 8888      88 8 888888888o
 .`8888:' `88.     8 8888       8 8888      88 8 8888    `88.
 8.`8888.   Y8     8 8888       8 8888      88 8 8888     `88
 `8.`8888.         8 8888       8 8888      88 8 8888     ,88
  `8.`8888.        8 8888       8 8888      88 8 8888.   ,88'
   `8.`8888.       8 8888       8 8888      88 8 8888888888
    `8.`8888.      8 8888       8 8888      88 8 8888    `88.
8b   `8.`8888.     8 8888       ` 8888     ,8P 8 8888      88
`8b.  ;8.`8888     8 8888         8888   ,d8P  8 8888    ,88'
 `Y8888P ,88P'     8 8888          `Y88888P'   8 888888888P


EOS

puts stub

configatron.params[:transforms].each_pair do |k,v|
  unless v[:converter].nil?
    puts "Test #{k} converter ...."
    puts v[:converter].call("HELLO WORLD")
  end
end


