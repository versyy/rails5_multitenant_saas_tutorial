require 'active_record/errors'

module ActiveRecordHelpers
  class MockRelation < Array
    def build(_args)
      first
    end

    def joins(_args)
      self
    end

    def where(params)
      key = params.keys.first
      value = params.values.first
      arr = MockRelation.new
      each { |x| arr << x if x.send(key) == value }
      arr
    end

    def find(value)
      find_by!({ id: value })
    end

    def find_by!(params)
      record = find_by(params)
      raise ActiveRecord::RecordNotFound, "Couldn't find #{params}" if record.nil?
      record
    end

    def find_by(params)
      where(params).first
    end
  end
end
