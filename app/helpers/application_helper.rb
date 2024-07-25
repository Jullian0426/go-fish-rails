module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.prepend 'flash', partial: 'layouts/flash'
  end

  def form_error_notification(object)
    return unless object.errors.any?

    tag.div class: 'error-message' do
      object.errors.full_messages.to_sentence.capitalize
    end
  end

  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join('_')
  end

  def format_time(seconds_played)
    if seconds_played >= 3600
      hours = (seconds_played / 3600).to_i
      minutes = ((seconds_played % 3600) / 60).to_i
      "#{hours}h:#{minutes}m"
    elsif seconds_played >= 60
      minutes = (seconds_played / 60).to_i
      remaining_seconds = (seconds_played % 60).to_i
      "#{minutes}m:#{remaining_seconds}s"
    else
      "#{seconds_played.to_i}s"
    end
  end
end
