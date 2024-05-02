class ComponentsController < ApplicationController

  def chat_sidebar
    @chatrooms = current_user.participated_chatrooms
  end
end
