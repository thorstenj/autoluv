#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require_relative '../lib/autoluv'
require "pp"

program :version, '0.0.1'
program :description, 'Automatically schedule and check into Southwest flights 24 hours beforehand.'

command :lookup do |c|
  c.syntax = 'autoluv lookup [options]'
  c.summary = ''
  c.description = 'Lookup departing flight info for a given Southwest confirmation number.'
  c.example 'description', 'command example'
  c.option '--confirmation-number NUMBER'
  c.option '--first-name NAME'
  c.option '--last-name NAME'
  c.action do |args, options|
    while options.confirmation_number.to_s.strip.empty?
      options.confirmation_number = ask("Confirmation Number: ")
    end

    while options.first_name.to_s.strip.empty?
      options.first_name = ask("First Name: ")
    end

    while options.last_name.to_s.strip.empty?
      options.last_name = ask("Last Name: ")
    end

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
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    # Do something or c.when_called Autoluv::Commands::Checkin
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

