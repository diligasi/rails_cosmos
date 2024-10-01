# frozen_string_literal: true

# Base class for operation objects that provides a standard interface and error handling.
# Operation objects should inherit from this class and implement their own logic in the `call` method.
#
# Example usage:
#   # Defining a successful operation
#   class MySuccessOperation < ApplicationOperation
#     def initialize(some_param, log_uuid: nil)
#       super(log_uuid: log_uuid)
#       @some_param = some_param
#     end
#
#     def call
#       # Custom operation logic that succeeds
#       success('Operation successful!', additional_info: 'Processed correctly')
#     end
#   end
#
#   # Defining a failing operation
#   class MyFailingOperation < ApplicationOperation
#     def initialize(some_param, log_uuid: nil)
#       super(log_uuid: log_uuid)
#       @some_param = some_param
#     end
#
#     def call
#       # Custom operation logic that fails
#       raise StandardError, 'Something went wrong!'
#     end
#   end
#
# Success example:
#   result = MySuccessOperation.call(some_param)
#   => [true, 'Operation successful!', additional_info: 'Processed correctly']
#
# Failure example:
#   result = MyFailingOperation.call(some_param)
#   => [false, #<StandardError: Something went wrong!>]
#
class ApplicationOperation
  # Entry point for the operation object. Initializes the object and calls the `call_with_rescue` method.
  #
  # @param args [Array] Positional arguments to be passed to the initializer.
  # @param kwargs [Hash] Keyword arguments to be passed to the initializer.
  #
  # @return [Array] A standardized result array where the first element is a boolean indicating success,
  #                 the second element is either nil or the error object, and additional elements contain extra data.
  def self.call(*args, **kwargs)
    new(*args, **kwargs).call_with_rescue
  end

  # Initializes the operation object with an optional log_uuid.
  # If no log_uuid is provided, a new UUID is generated automatically.
  #
  # @param log_uuid [String, nil] An optional UUID to associate with the operation.
  # If not provided, a new UUID is generated.
  def initialize(log_uuid: nil)
    self.log_uuid = log_uuid || SecureRandom.uuid
  end

  # Standardized method to invoke the operation object with exception handling.
  # Captures any unexpected errors and returns a standardized failure response.
  #
  # @return [Array] A standardized result array where the first element is a boolean indicating success,
  #                 the second element is either nil or the error object, and additional elements contain extra data.
  def call_with_rescue
    log_start
    result = call
    log_success
    result
  rescue StandardError => e
    log_failure(e)
    handle_unexpected_error(e)
  end

  # The core logic of the operation object should be implemented in this method by the subclass.
  # This method must be overridden in any subclass that inherits from ApplicationOperation.
  #
  # @raise [NotImplementedError] If the method is not overridden by a subclass.
  def call
    raise NotImplementedError, "Subclasses must implement the call method"
  end

  protected

  # Returns a standardized success response.
  # The first element of the response is `true`, followed by any additional data provided.
  #
  # @param additional_data [Array] Extra data to be included in the success response.
  #
  # @return [Array] An array with `true` as the first element and optional additional data.
  def success(*additional_data)
    [true, *additional_data]
  end

  # Returns a standardized failure response.
  # The first element of the response is `false`, followed by the error and any additional data provided.
  #
  # @param error [Exception] The error object that caused the failure.
  # @param additional_data [Array] Extra data to be included in the failure response.
  #
  # @return [Array] An array with `false` as the first element, the error object as the second element,
  #                 and optional additional data.
  def failure(error, *additional_data)
    [false, error, *additional_data]
  end

  private

  # Retrieves the log_uuid associated with the current thread.
  # This ensures thread-safe access to the UUID used for logging.
  #
  # @return [String] The UUID associated with the current thread.
  def log_uuid
    Thread.current[:log_uuid]
  end

  # Sets the log_uuid for the current thread.
  # This ensures that each thread has its own UUID for logging purposes, providing thread-safe storage.
  #
  # @param value [String] The UUID to be assigned to the current thread.
  def log_uuid=(value)
    Thread.current[:log_uuid] = value
  end

  # Returns the start time of the operation. If not already set, it initializes the start time to the current time.
  # This is useful for tracking the duration of the operation.
  #
  # @return [DateTime] The start time of the operation.
  def start_time
    Thread.current[:start_time] ||= Time.zone.now
  end

  # Logs the start of the operation.
  def log_start
    Rails.logger.info "[#{self.class.name} - #{log_uuid}] Started at #{start_time.strftime("%Y-%m-%d %H:%M:%S")}"
  end

  # Logs the successful completion of the operation, including its duration.
  def log_success
    end_time = Time.zone.now
    converted_time = end_time.strftime("%Y-%m-%d %H:%M:%S")
    duration = end_time - start_time
    Rails.logger.info "[#{self.class.name} - #{log_uuid}] Completed at #{converted_time}. Duration: #{duration} seconds"
  end

  # Logs a failure, including the error message and stack trace.
  #
  # @param error [StandardError] The error object that was raised.
  def log_failure(error)
    Rails.logger.error "[#{self.class.name} - #{log_uuid}] Failed with error: #{error.message}"
  end

  # Handles unexpected errors by returning a standardized failure response. This method is
  # automatically called by `call_with_rescue` when an unexpected exception occurs.
  #
  # @param error [StandardError] The error object that was raised unexpectedly.
  #
  # @return [Array] A standardized failure response array with `false` as the first element,
  #                 and the error object as the second element.
  def handle_unexpected_error(error)
    [false, error]
  end
end
