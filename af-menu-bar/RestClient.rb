#
#  RestClient.rb
#  af-menu-bar
#
#  Created by Tim Santeford on 10/6/12.
#  Copyright 2012 AppFog. All rights reserved.
#
require 'json'

class RestDelegate

  def initialize(parent, &block)
    @parent = parent
    @block = block
  end

  def connectionDidFinishLoading(connection)
    @block.call(@response, NSString.alloc.initWithData(@data, encoding:NSUTF8StringEncoding))
  end

  def connection(connection, didReceiveResponse:response)
    @response = response
  end

  def connection(connection, didReceiveData:data)
    @data ||= NSMutableData.new
    @data.appendData(data)
  end

  def connection(conn, didFailWithError:error)
    puts "didFailWithError"
  end

end

class RestClient

  def get_json(url, headers, &block)
    headers ||= {}
    headers['Content-Type'] ||= 'application/json'
    headers['Accept']       ||= 'application/json'
    get(url, headers) do |response, data|
      block.call(response, JSON.parse(data))
    end
  end

  def get(url, headers, &block)
    request('GET', url, nil, headers, &block)
  end

  def post_json(url, payload, headers, &block)
    headers ||= {}
    headers['Content-Type'] ||= 'application/json'
    headers['Accept']       ||= 'application/json'
    post(url, payload, headers, &block)
  end

  def post(url, payload, headers, &block)
    request('POST', url, payload, headers, &block)
  end

  def request(method, url, payload, headers, &block)

    headers ||= {}

    headers['Cache-Control'] ||= 'no-cache'
    headers['Pragma']        ||= 'no-cache'
    headers['Connection']    ||= 'close'

    request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString(url), cachePolicy:NSURLRequestUseProtocolCachePolicy, timeoutInterval:60)
    request.HTTPMethod = method

    headers.each do |key, value|
      request.setValue(value, forHTTPHeaderField:key)
    end

    if !payload.nil?
      body = ""

      if NSJSONSerialization.isValidJSONObject(payload)
        body = NSJSONSerialization.dataWithJSONObject(payload, options:0, error:nil)
      else
        body = payload
      end

      request.setValue(body.length.to_s, forHTTPHeaderField:"Content-Length")
      request.HTTPBody = body
    end

    delegate = RestDelegate.new(self) do |response, data|
      block.call(response, data)
    end

    NSURLConnection.connectionWithRequest(request, delegate:delegate)
  end

end