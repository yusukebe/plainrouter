require "plainrouter/version"

class PlainRouter
  def initialize
    @routes = []
    @compiled_regexp
  end

  def add(path_info, stuff)
    nodes, captures = [], []
    regexp = Regexp.union(/{((?:\{[0-9,]+\}|[^{}]+)+)}/,
                          /:([A-Za-z0-9_]+)/,
                          /(\*)/,
                          /([^{:*]+)/)
    path_info.sub(/(^\/)/,'').split('/').each.with_index do |path, pos|
      match = {position: nil, value: nil}
      path.match(regexp).size.times do |index|
        last_match = Regexp.last_match(index)
        if last_match
          match[:value] = last_match
          match[:position] = index
        end
      end
      case match[:position]
      when 1 then
        captures[pos], pattern = match[:value].split(':')
        pattern = pattern ? "(#{pattern})" : "([^/]+)"
        nodes.push(pattern)
      when 2 then
        captures[pos] = match[:value]
        nodes.push("([^/]+)")
      when 3 then
        captures[pos] = '*'
        nodes.push("(.+)")
      else
        nodes.push(path)
      end
    end
    @routes.push({path: '/' + nodes.join('/'), stuff: stuff, captures: captures })
    self.compile
  end

  def compile
    regexps = @routes.map.with_index {|r, index| /(?<_#{index}>#{r[:path]})/}
    @compiled_regexp = /\A#{Regexp.union(regexps)}\z/
  end

  def match(path_info)
    return if @compiled_regexp.nil?
    match = path_info.match(@compiled_regexp)
    @routes.size.times do |i|
      if Regexp.last_match("_#{i}")
        response = {}
        stuff = @routes[i][:stuff]
        captures = @routes[i][:captures]
        path_info.gsub(/([^\/]+)/).with_index do |path, pos|
          response[captures[pos]] = path if captures[pos] != nil
        end
        if response.empty?
          return stuff
        else
          return stuff, response
        end
      end
    end
    return
  end
end
