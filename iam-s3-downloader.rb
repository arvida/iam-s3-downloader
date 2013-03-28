#!/usr/bin/env ruby

require "rubygems"
require "aws-sdk"
require "optparse"
require "open-uri"
require "json"
require "fileutils"

options = {
  :role_url => "http://169.254.169.254/latest/meta-data/iam/security-credentials/s3access"
}

OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"
  opts.on("--bucket BUCKET", "Bucket to fetch file from. Required.") do |value|
    options[:bucket] = value
  end
  opts.on("--key KEY", "Key to fetch (name on S3). Required.") do |value|
    options[:key] = value
  end
  opts.on("--destination PATH", "Local path for saved key. Defaults to ./KEY.") do |value|
    options[:destination] = value
  end
  opts.on("--role-url URL", "URL for IAM role. Defaults to #{options[:role_url]}") do |value|
    options[:role_url] = value
  end
end.parse!

raise OptionParser::MissingArgument, "bucket" if options[:bucket].nil?
raise OptionParser::MissingArgument, "key" if options[:key].nil?

if options[:destination].nil?
  options[:destination] = "./#{File.basename(options[:key])}"
end

f = open options[:role_url]
credentials = JSON.parse(f.read)
f.close

AWS.config :access_key_id => credentials["AccessKeyId"],
           :secret_access_key => credentials["SecretAccessKey"],
           :session_token => credentials["Token"]

s3 = AWS::S3.new
myfile = s3.buckets[options[:bucket]].objects[options[:key]]

if File.exists? options[:destination]
  timestamp = Time.now.strftime("%Y%m%d%H%M%S")
  FileUtils.mv options[:destination], "#{options[:destination]}-backup-#{timestamp}"
end

File.open(options[:destination], "w") do |f|
  f.write myfile.read
end
