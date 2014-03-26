require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'simple-rss'
require 'mechanize'

class GarminConnectr
  
  def initialize
  end
  
  def load_activity( opts )
    id = opts[:id]
    activity = GarminConnectrActivity.new( :id => id )
    activity.load!
  end
  
  def load_activity_list( opts )
    username = opts[:username]
    password = opts[:password]
    limit = opts[:limit] || 50
    
    activity_list = []
    
    agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    page = agent.get('https://sso.garmin.com/sso/login?service=http%3A%2F%2Fconnect.garmin.com%2Fpost-auth%2Flogin&webhost=olaxpw-connect00.garmin.com&source=http%3A%2F%2Fconnect.garmin.com%2Fen-US%2Fsignin&redirectAfterAccountLoginUrl=http%3A%2F%2Fconnect.garmin.com%2Fpost-auth%2Flogin&redirectAfterAccountCreationUrl=http%3A%2F%2Fconnect.garmin.com%2Fpost-auth%2Flogin&gauthHost=https%3A%2F%2Fsso.garmin.com%2Fsso&locale=en_US&id=gauth-widget&cssUrl=https%3A%2F%2Fstatic.garmincdn.com%2Fcom.garmin.connect%2Fui%2Fsrc-css%2Fgauth-custom.css&clientId=GarminConnect&rememberMeShown=true&rememberMeChecked=false&createAccountShown=true&openCreateAccount=false&usernameShown=true&displayNameShown=false&consumeServiceTicket=false&initialFocus=true&embedWidget=false')
    form = page.forms.first
    form.username = username
    form.password = password
    form.submit

    page = agent.get('http://connect.garmin.com/activities')

    doc = Nokogiri::HTML( page.body )
    activities = doc.search('.activityNameLink')
    activities[0, limit].each do |act|
      name = act.search('span').inner_html
      act[:href].match(/\/([\d]+)$/)
      aid = $1
      activity = GarminConnectrActivity.new( :id => aid, :name => name )
      activity_list << activity
    end
    activity_list    
  end
  
end

class GarminConnectrActivity
  attr_accessor :id, :data, :splits, :split_summary, :loaded

  def initialize( opts )
    @id = opts[:id]
    @splits = []
    @data = {}
    @data[:name] = opts[:name]
    @data[:url] = "http://connect.garmin.com/activity/#{ @id }"
    @loaded = false
    @splits_loaded = false
  end
    
  def load!
    url = "http://connect.garmin.com/activity/#{ @id }"
    doc = Nokogiri::HTML(open(url))
    
    # HR cell name manipulation
    ['bpm', 'pom', 'hrZones'].each do |hr|
      doc.css("##{ hr }Summary td").each do |e|
        e.inner_html = "Max HR #{ hr.upcase }:" if e.inner_html =~ /Max HR/i
        e.inner_html = "Avg HR #{ hr.upcase }:" if e.inner_html =~ /Avg HR/i
      end
    end
    
    @scrape = {
      :details => {
        :name          => doc.css('#activityName').inner_html,
        :activity_type => doc.css('#activityTypeValue').inner_html.gsub(/[\n\t]+/,''),
        :event_type    => doc.css('#eventTypeValue').inner_html.gsub(/[\n\t]+/,''),
        :timestamp     => doc.css('#timestamp').inner_html.gsub(/[\n\t]+/,''),
        :embed         => doc.css('.detailsEmbedCode').attr('value').value,
        :device        => doc.css('.addInfoDescription a').inner_html
      },
      :summaries => {
        :overall     => { :css => '#detailsOverallBox' },
        :timing      => { :css => '#detailsTimingBox' },
        :elevation   => { :css => '#detailsElevationBox' },
        :heart_rate  => { :css => '#detailsHeartRateBox' },
        :cadence     => { :css => '#detailsCadenceBox' },
        :temperature => { :css => '#detailsTemperatureBox' },
        :power       => { :css => '#detailsPowerBox' }
      }
    }
    
    @scrape[:details][:split_count] = doc.css('.detailsLapsNumber')[0].inner_html.to_i rescue 0
    
    @scrape[:details].each do |k,v|
      v = v.strip if v.is_a?(String)
      @data[k] = v
    end
    @scrape[:summaries].each do |k,v|
      doc.css("#{ v[:css] } td").each do |e|
        if e.inner_html =~ /:[ ]?$/
          key = e.inner_html.downcase.gsub(/ $/,'').gsub(/:/,'').gsub(' ','_').to_sym
          @data[key] = e.next.next.inner_html.strip
        end
      end
    end

    ## Splits
    @splits_loaded = true if self.split_count == 0

    @loaded = true
    self
  end

  def fields
    @data.keys
  end
  
  def splits
    self.load! unless @loaded
    self.load_splits! unless @splits_loaded
    @splits
  end

  def load_splits!
    doc = open("http://connect.garmin.com/csvExporter/#{ @id }.csv")

    keys = []
    csv = CSV.parse( doc.read )
    csv[0].each do |key|
      keys.push key.downcase.gsub(' ','_') if key.is_a?(String)
    end

    csv[1, csv.length-1].each_with_index do |row, index|
      split = GarminConnectrActivitySplit.new
      keys.each_with_index do |key, key_index|
        value = row[ key_index ]
        value.strip! if value.is_a? String
        split.data[ key.to_sym ] = value
      end
      index < csv.length - 2 ? @splits << split : @split_summary = split
    end
    @splits_loaded = true
  end

  private
  
  def method_missing(name)
    
    self.load! if !@data[name.to_sym] and !@loaded  # lazy loading
    ret = @data[name.to_sym]

    ## Got nothing? Try a variation: Garmin changed a few fields:
    ## =>   min_elevation => minelevation, max_elevation => maxelevation
    ret = @data[name.to_s.gsub('_','').to_sym] if ret == nil

    ret
  end

end

class GarminConnectrActivitySplit
  
  attr_reader :index, :data
  
  def initialize( opts={} )
    @index = opts[:index]
    @data = {}
  end
  
  def fields
    @data.keys
  end
  
  private
  
  def method_missing(name)
    ## backwards compatibility 
    name = 'avg_temperature' if name.to_s == 'avg_temp'
    
    ret = @data[name.to_sym]
    ret
  end
  
end
