require "plainrouter"

class PlainRouter::Method
  def initialize
    @router
    @data = {}
    @path = []
    @path_seen = {}
  end

  def add(methods, path, opaque = nil)
    router = nil
    if @path_seen[path].nil?
      @path.push(path)
      @path_seen[path] = true
    end
    @data[path] ||= []
    methods = [methods] unless methods.instance_of?(Array)
    methods.each do |method|
      @data[path].push([method, opaque])
    end
  end

  def match(request_method, path)
    router ||= self.build_router
    if response = router.match(path)
      patterns, captured = nil, nil
      if response.last.instance_of?(Array)
        patterns = response
      else
        patterns = response[0]
        captured = response[1]
      end
      patterns.each do |pattern|
        if pattern[0].nil? || request_method == pattern[0]
          if captured.nil?
            return pattern[1]
          else
            return pattern[1], captured
          end
        end
      end
    end
    return
  end

  def build_router
    router = PlainRouter.new
    @path.each do |path|
      router.add(path, @data[path])
    end
    return router
  end
end
