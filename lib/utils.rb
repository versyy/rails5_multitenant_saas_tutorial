require 'benchmark'

module Utils
  class << self
    def say_with_time(text)
      say(text, :item)
      result = nil
      time = Benchmark.measure { result = yield }
      say(format('%.4fs', time.real))
      say("#{result} rows") if result.is_a?(Integer)
      say(result) if result.is_a?(String)
    end

    def say(text, level = :subitem)
      lead_in = level == :subitem ? '   ->' : "\n=="
      puts [lead_in, text].join(' ')
    end

    def process_result(result)
      raise result.errors.first || StandardError unless result.success?
      yield
    end
  end
end
