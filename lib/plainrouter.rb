require "plainrouter/version"

class PlainRouter
  def initialize
    @routes = []
    @compiled_regexp
  end

  def add(path, stuff)
    nodes, captures = [], []
    regexp = Regexp.union(/{((?:\{[0-9,]+\}|[^{}]+)+)}/,
                          /:([A-Za-z0-9_]+)/,
                          /(\*)/,
                          /([^{:*]+)/)
    path.sub(/(^\/)/,'').split('/').each.with_index do |p, pos|
      position, match = nil, nil
      p.match(regexp).size.times do |i|
        if Regexp.last_match(i)
          match = Regexp.last_match(i)
          position = i
        end
      end
      case position
      when 1 then
        res = match.split(':')
        captures[pos] = res[0]
        pattern = res[1] ? "(#{res[1]})" : "([^/]+)"
        nodes.push(pattern)
      when 2 then
        captures[pos] = match
        nodes.push("([^/]+)")
      when 3 then
        captures[pos] = '*'
        nodes.push("(.+)")
      else
        nodes.push(p)
      end
    end
    @routes.push({path: '/' + nodes.join('/'), stuff: stuff, captures: captures })
    self.compile
  end

  def compile
    regexps = @routes.map.with_index {|r, index| /(?<_#{index}>#{r[:path]})/}
    @compiled_regexp = /\A#{Regexp.union(regexps)}\z/
  end

  def match(path)
    match = path.match(@compiled_regexp)
    @routes.size.times do |i|
      if Regexp.last_match("_#{i}")
        response = {}
        stuff = @routes[i][:stuff]
        captures = @routes[i][:captures]
        path.gsub(/([^\/]+)/).with_index do |p, pos|
          response[captures[pos]] = p if captures[pos] != nil
        end
        if response.empty?
          return stuff
        else
          return stuff, response
        end
      end
    end
    return nil
  end
end
