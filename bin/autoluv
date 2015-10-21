#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require_relative '../lib/autoluv'
require "pp"

program :version, '0.0.1'
program :description, 'Automatically schedule and check into Southwest flights 24 hours beforehand.'

command :lookup do |c|
  c.syntax = 'autoluv lookup [options]'
  c.description = 'Lookup departing flight info for a given Southwest confirmation number.'
  c.example 'Typical Usage', 'autoluv lookup -c ABCDEF -f John -l Doe'
  c.option '-c', '--confirmation-number NUMBER', 'Required'
  c.option '-f', '--first-name NAME', 'Required'
  c.option '-l', '--last-name NAME', 'Required'
  c.action do |args, options|
    raise OptionParser::MissingArgument, "Confirmation Number" if options.confirmation_number.nil?
    raise OptionParser::MissingArgument, "First Name" if options.first_name.nil?
    raise OptionParser::MissingArgument, "Last Name" if options.last_name.nil?

    sw = AutoLUV::Southwest.new options.confirmation_number, options.first_name, options.last_name
    results = sw.departing_flights

    if results[:success]
      results[:departing_flights].each { |flight| puts flight }
    else
      puts results[:message]
    end
  end
end

command :checkin do |c|
  c.syntax = 'autoluv checkin [options]'
  c.description = 'Immediately check into a Southwest flight.'
  c.example 'Check-in and get boarding passes via email', 'autoluv checkin -b email -e example@email.com -c ABCDEF -f John -l Doe'
  c.example 'Check-in and get boarding passes via text message', 'autoluv checkin -b text -p 800-555-1212 -c ABCDEF -f John -l Doe'
  c.example 'Check-in and print boarding passes later', 'autoluv checkin -c ABCDEF -f John -l Doe'
  c.option '-c', '--confirmation-number NUMBER', 'Required'
  c.option '-f', '--first-name NAME', 'Required'
  c.option '-l', '--last-name NAME', 'Required'
  c.option '-b', '--boarding-pass OPTION', String, ["print", "email", "text"], "Valid options are: print, email, or text. If the --boarding-pass switch is not specified, print is assumed."
  c.option '-p', '--phone NUMBER', "Required if --boarding-pass text is specified."
  c.option '-e', '--email ADDRESS', "Required if --boarding-pass email is specified."
  c.action do |args, options|
    options.default :boarding_pass => "print"

    raise OptionParser::MissingArgument, "--confirmation-number required" if options.confirmation_number.nil?
    raise OptionParser::MissingArgument, "--first-name required" if options.first_name.nil?
    raise OptionParser::MissingArgument, "--last-name required" if options.last_name.nil?
    raise OptionParser::MissingArgument, "--email required when using --boarding-pass email" if options.boarding_pass == "email" && options.email.nil?
    raise OptionParser::MissingArgument, "--phone required when using --boarding-pass text" if options.boarding_pass == "text" && options.phone.nil?

    case options.boarding_pass
    when "email"
      contact_info = options.email
    when "text"
      contact_info = options.phone
    end

    sw = AutoLUV::Southwest.new options.confirmation_number, options.first_name, options.last_name
    results = sw.checkin options.boarding_pass.to_sym, contact_info

    if results[:success]
      puts "Check-In Successful"
    else
      puts "Check-In Failed"
    end

    puts results[:message]
  end
end

command :schedule do |c|
  c.syntax = 'autoluv schedule [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--confirmation-number NUMBER'
  c.option '--first-name NAME'
  c.option '--last-name NAME'
  c.option '--boarding-pass [print, email, text]', String, [:print, :email, :text]
  c.option '--phone NUMBER'
  c.option '--email ADDRESS'
  c.action do |args, options|

  end
end

command :list do |c|
  c.syntax = 'autoluv list [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    # Do something or c.when_called Autoluv::Commands::List
  end
end

command :delete do |c|
  c.syntax = 'autoluv delete [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    # Do something or c.when_called Autoluv::Commands::Delete
  end
end

