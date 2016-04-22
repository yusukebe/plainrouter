require "plainrouter"

class PlainRouter::Method
  def initialize
    @router = nil
    @data = {}
    @path = []
  end

  def add(method, path, opaque = nil)
    @router = nil
    @path.push(path)
    @data[path] = [] if @data[path].nil?
    @data[path].push([method, opaque])
  end

  def match(request_method, path)
    @router ||= self.build_router
    res = @router.match(path)
    if !res.nil?
      patterns, captured = nil, nil
      if res.last.instance_of?(Array)
        patterns = res
      else
        patterns = res[0]
        captured = res[1]
      end
      patterns.each do |pattern|
        if request_method == pattern[0]
          if captured.nil?
            return pattern[1]
          else
            return pattern[1], captured
          end
        end
      end
    end
    return nil
  end

  def build_router
    router = PlainRouter.new
    @path.each do |path|
      router.add(path, @data[path])
    end
    return router
  end
end
