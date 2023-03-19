# Require all files in the lib/increase/resources directory
Dir[File.expand_path("resources/*.rb", __dir__)].sort.each do |file|
  require file
end
