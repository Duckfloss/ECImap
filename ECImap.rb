#!/usr/bin/env ruby

# ecimap.rb FILE.csv IN/OUT
#			-h, --help, Prints help text
#			-v, --verbose, Verbose
#			-e FILE, Full path to alternative ECLink.ini file

# Require Gems
require 'csv'
require 'optparse'
require 'ostruct'
require 'inifile'

# TEMPS
ARGV << "C:/Documents and Settings/pos/desktop/test.csv"
ARGV << "IN"



def valid_file?(file,type)
	if type == "csv"
		if file.nil?
			puts "Please provide a source .csv file"
			exit 0
		end
	end
	if !File.exists?(file)
		puts "#{file} doesn't seem to exist. Please check\nyour file path and try again."
		if type == "ini"
			puts "The default location for this file is \"C:\/Documents and Settings\/pos\/Desktop\/Website\/Toolbox\/ECImap\/data\/ECLink.INI\""
		end
		exit 0
	end
	true
end

def parse_args

	options = OpenStruct.new
	options.file = nil
	options.direction = nil
	options.eci = "C:/Documents and Settings/pos/Desktop/Website/Toolbox/ECImap/data/ECLink.INI"
	options.verbose = false

	if ARGV.include?("-h")
		print_help
	end

	if ARGV.include?("-v")
		ARGV.delete("-v")
		options.verbose = true
	end

	file = ARGV.select {|i| i=~/\.csv$/}[0]
	if valid_file?(file,"csv")
		options.file = File.absolute_path(file)
	end

	options.direction = ARGV.select {|i| i=~/[IN|OUT]/}[0]
	if options.direction.nil?
		puts "Please indicate either \"IN\" or \"OUT\".\nType \"ecimap.rb -h\" for more information"
		exit 0
	end

	options
end

def print_help
	puts "\nECIMAP.RB\n"
	puts "Command takes a CSV-formated file with two columns: \"Attr\" and \"Color\"\n"
	puts "It parses the file and compares it to ECI\'s mapping file. Then it either\n"
	puts "fills IN the \"Color\" column from the ECI file, or it OUTputs color maps\n"
	puts "to the ECI file.\n"
	puts "\n"
	puts "Usage: leemd.rb FILE IN/OUT [options]\n"
	puts "\n"
	puts "  FILE - is a csv-file with two columns: Attr and Color\n"
	puts "  IN/OUT - IN fills IN the csv file from ECI\n"
	puts "\t\tOUT copies OUT the map from the csv to ECI\n"
	puts "\n"
	puts "Options:\n"
	puts "\t-v\t\tRuns verbosely\n"
	puts "\t-h\t\tPrints this help\n"
	puts "\t-e FILE\t\tFull path to alternative ECLink.ini file\n"
	puts "\t\t\tdefault is \'Website\/Toolbox\/ECImap\/data\/ECLink.INI\'\n"
	puts "\t\t\tYou'll have to manually copy the ECLink.INI file to\n"
	puts "\t\t\tRPro's directory: \'R:\/RETAIL\/RPRO\/EC\'.\n"
	puts "\t\t\tI didn't feel like effing around with RPro's system.\n\n"
	exit 0
end


def get_csv(csv)
	# Build the converter
	csv_data = CSV.read(csv, :headers=>true,:skip_blanks=>false,:header_converters=>:symbol)
end

def get_eci(eci)
	$eci = IniFile.load(eci, :encoding=>'Windows-1252')['WordMapping']
	map = {}

	$eci.each do |k,v|
		if k.match /^ATTR/
			map[k.sub('ATTR<_as_>','')] = v
		end
	end
	map
end


def in_it
	# Build intermediary hash from CSV file
	$map_hash = {}
	$csv.each do |row|
		$map_hash[row[:attr]] = row[:color]
	end
	$map_hash.delete nil

	# Get map definitions from ECI file
	$map_hash.each_key do |col|
		$map_hash[col] = $wordmapping[col] unless $wordmapping[col].nil?
	end

	# Write map definitions back to CSV file
	CSV.open(options.file, 'w') do |csv_obj|
		csv_obj << ['Attr','Color']
		$csv.each do |row|
			if !row[:attr].nil? && $map_hash.has_key?( row[:attr] )
				this_arry = [row[:attr], $map_hash[row[:attr]]]
				csv_obj << this_arry
			else
				this_arry = [ row[:attr], nil ]
				csv_obj << this_arry
			end
		end
	end

end

def out_it


end




$options = parse_args
$csv = get_csv($options.file)
$wordmapping = get_eci($options.eci)

if $options.direction == "IN"
	in_it
elsif $options.direction == "OUT"
	out_it
end

#exit 0

if __FILE__ == $0

	options = parse_args

	puts options

#	path = options.source.slice(0,options.source.index(/\/[A-Za-z0-9\-\_]+\.csv$/)+1)
#	file = options.source.slice(/[A-Za-z0-9\-\_]+\.csv$/)
#	csv_target = "#{path}FILTERED#{file}"

#	doit(options.source, csv_target)

end
