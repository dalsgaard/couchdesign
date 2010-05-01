require 'json'
require 'typhoeus'

module CouchDesign

  def self.update(file_name, database, host="localhost", port="5984")
    
    doc = File.open(file_name).read

    rev = nil
    dir_name = File.dirname file_name
    base_name = File.basename file_name
    rev_file = "#{host}__#{port}__#{database}__#{base_name}.rev".gsub('/', '__')
    if File.exist? "#{dir_name}/#{rev_file}"
      rev = File.open("#{dir_name}/#{rev_file}").read.strip
    end
    rev_assign = rev ? "doc._rev = \"#{rev}\"" : ""
    
    js = %Q{
var funToStr = function(obj) {
  for (var key in obj) {
    var value = obj[key];
    if (typeof value == "object") {
      funToStr(value);
    } else if (typeof value == "function") {
      obj[key] = value.toString();
    }
  }
}
var doc = #{doc};
#{rev_assign}
funToStr(doc);
print(JSON.stringify(doc));
}

    json = `js -f #{File.dirname(__FILE__)}/json2.js -e "#{js.gsub('"', '\\"')}"`

    rjson = JSON.parse json
    id = rjson["_id"]
    rev = rjson["_rev"]

    url = "http://#{host}:#{port}/#{database}/#{id}"
    response = Typhoeus::Request.put(url, :body => rjson.to_json)

    if response.code == 201
      rev = JSON.parse(response.body)["rev"]
      base_name = File.basename file_name
      rev_file = "#{host}__#{port}__#{database}__#{base_name}.rev".gsub('/', '__')
      File.open "#{dir_name}/#{rev_file}", 'w' do |f|
        f.print rev
      end
      puts rev
    else
      puts "#{response.code} #{response.body}"
    end
    
  end

  def self.force(file_name, database, host="localhost", port="5984")
    dir_name = File.dirname file_name
    base_name = File.basename file_name
    rev_file = "#{dir_name}/" + "#{host}__#{port}__#{database}__#{base_name}.rev".gsub('/', '__')
    puts rev_file
    File.delete rev_file if File.exist? rev_file
    doc = File.open(file_name).read
    js = "var doc = #{doc}; print(doc._id);"
    id = `js -e "#{js.gsub('"', '\\"')}"`.strip
    url = "http://#{host}:#{port}/#{database}/#{id}"
    response = Typhoeus::Request.get url
    if response.code == 200
      File.open rev_file, 'w' do |f|
        f.print JSON.parse(response.body)["_rev"]
      end
    end
  end

end
