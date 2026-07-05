ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # --- Test data builders ---
    # These models have no YAML fixtures, so tests build their own records.
    def create_user(email: "user-#{SecureRandom.hex(4)}@example.com", password: "password123")
      User.create!(email: email, password: password, username: "user#{SecureRandom.hex(3)}")
    end

    def create_event(owner: create_user)
      Event.create!(
        title: "Beach Cleanup",
        description: "Join us to clean up the beach together.",
        contact: 123_456_789,
        start_date: Date.current,
        end_date: Date.current + 1,
        start_time: "09:00",
        end_time: "12:00",
        user: owner
      )
    end

    # Returns the chatroom (auto-created by Event) that `user` participates in.
    def create_chatroom_with_participant(user)
      event = create_event
      event.participations.create!(user: user)
      event.reload.chatroom
    end
  end
end
