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

require 'uuidtools'
require 'spreadsheet'


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

# over-ride embedded source statement from command line
unless configatron.input_files.empty?
  configatron.params[:source] = configatron.input_files.shift
end

if configatron.params[:source].nil?
  error "The required 'source' statment for the *.xls file was not found in the config file."
elsif configatron.params[:title].nil?
  manufactured_title = configatron.params[:source].basename.to_s.gsub(configatron.params[:source].extname,'').titleize
  configatron.params[:title] = manufactured_title
  warning "No title was given; defaulting to: #{manufactured_title}"
end

abort_if_errors


xls_path     = configatron.params[:source]
table_title  = configatron.params[:title]

Spreadsheet.client_encoding = 'UTF-8'
configatron.params[:book]   = Spreadsheet.open(xls_path)
configatron.params[:sheet]  = configatron.params[:book].worksheet(0)

configatron.params[:headings] = configatron.params[:sheet].first.to_a

configatron.params[:column_names] = configatron.params[:headings].map do |column_heading|
  transform = configatron.params[:transforms][column_heading]
  if transform  &&  transform[:name]
    # over-ride the calculated column_name
    column_name = transform[:name]
  else
    # SMELL: column variable name convention is hard coded.
    column_name = column_heading.variablize('snake_case')
  end
  column_name
end


configatron.params[:leader_names]   = %w[ id unique_id ]
configatron.params[:follower_names] = %w[ report_date created_at updated_at ]


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

  if param[:generate]
    if param[:filename].nil?
      # TODO: build the filename from :title and convention
      # SMELL: :title may not exist
      if configatron.params[:title].nil?
        error "#{a_string} requested but filename was not provided"
      else
        title = configatron.params[:title]
        param[:filename] = title.variablize(param[:convention])
        configatron.params[param_key][:filename] = extend_filename(param)
        warning "Defaulting #{a_string} filename as: #{configatron.params[param_key][:filename]}"
      end
    else
      configatron.params[param_key][:filename] = extend_filename(param)
    end
  end
end


JsModelGenerator::Config::FEATURES.each do |feature_request|
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

options = configatron.params.to_h

JsModelGenerator::Config::FEATURES.each do |feature|
  param_key = feature.to_sym
  if configatron.params[param_key][:generate]
    puts "Generating #{feature} ..."
    require_relative("js_model_generator/features/#{feature}")
    Feature = eval "JsModelGenerator::#{feature.titleize}"
    Feature.generate(options)
  end
end

