#!/usr/bin/env ruby
APP_ROOT = File.dirname(__FILE__)
$:.unshift( File.join(APP_ROOT, 'lib'))
require 'net/https'
require 'controller'
require 'nmap/program'
require 'socket'
require 'crawler.rb'
require 'enumerate.rb'
require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'host'

system("clear")
console_loop()
