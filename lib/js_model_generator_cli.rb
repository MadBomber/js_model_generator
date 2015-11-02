#!/usr/bin/env ruby
# encoding: utf-8
##########################################################
###
##  File: js_model_generator_cli.rb
##  Desc: Create JavaScript-baed Sequelized models and migrations from XLS file
##  By:   Dewayne VanHoozer (dvanhoozer@gmail.com)
#

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

require_relative('js_model_generator/js_model_gen_config')

configatron.params = eval_script(configatron.config).params

abort_if_errors

######################################################
# Local methods

=begin
puts  file_name  #= "a_string"     # required, supports: xls
puts  model_title#= "a_string"     # optional, generated from file_name
puts  model_name #= "a_string"     # optional, generated from model_title
puts
puts  # Defaults
puts  model      #= true         # all optional
puts  migration  #= true
puts  csv        #= true
puts  csv_header #= false
puts  sql        #= true
puts
puts  transforms #= {
=end


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


