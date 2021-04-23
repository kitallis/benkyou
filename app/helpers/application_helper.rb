module ApplicationHelper
  def flash_message(type, text)
    flash.now[type] ||= []
    flash.now[type] << text
  end
end
