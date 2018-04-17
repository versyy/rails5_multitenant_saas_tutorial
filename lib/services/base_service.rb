module Services
  class BaseService
    attr_accessor :logger, :errors, :success

    def initialize(logger:)
      @logger = logger
      @errors = []
      @success = false
    end

    protected

    def log_error(err)
      errors << err
      @logger.fatal "#{self.class}: #{err.class}: #{err.message}"
    end
  end
end
