# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all
Event.destroy_all
Participation.destroy_all

@bob = User.create(first_name: "Bob", last_name: "Sullivan", username: "Monster Bob", contact: 1234566789, email: "Bob@email.com", password: "123456", role: 'admin')
@alice = User.create(first_name: "Alice", last_name: "Wonder", username: "Wonder Alice", contact: 0123123013, email: "Alice@email.com", password: "123456", role: "normal")
@john = User.create(first_name: "John", last_name: "Doe", username: "John Doe", contact: 1234123412, email: "John@email.com", password: "123456", role: "normal")

@event1 = Event.create(
  title: "event 1",
  description: "This is event one",
  latitude: 42.345,
  longitude: 8.354,
  start_date: "2023-11-08",
  end_date: "2023-12-07",
  user_id: @bob.id
)

@event2 = Event.create(
  title: "event 2",
  description: "This is event two",
  latitude: 40.123,
  longitude: 7.890,
  start_date: "2023-11-15",
  end_date: "2023-11-20",
  user_id: @bob.id
)

@event3 = Event.create(
  title: "event 3",
  description: "This is event three",
  latitude: 41.567,
  longitude: 9.012,
  start_date: "2023-12-01",
  end_date: "2023-12-10",
  user_id: @bob.id
)

@event4 = Event.create(
  title: "event 4",
  description: "This is event four",
  latitude: 39.876,
  longitude: 6.543,
  start_date: "2023-12-15",
  end_date: "2023-12-20",
  user_id: @alice.id
)

@partitipation1 = Participation.create(user_id: @bob.id, event_id: @event1.id)
@partitipation2 = Participation.create(user_id: @alice.id, event_id: @event4.id)
@partitipation3 = Participation.create(user_id: @john.id, event_id: @event1.id)
@partitipation4 = Participation.create(user_id: @bob.id, event_id: @event2.id)
@partitipation5 = Participation.create(user_id: @alice.id, event_id: @event2.id)

@testimonial = Testimonial.create(content: "great event 1", participation_id: @partitipation1.id)
@testimonial = Testimonial.create(content: "great event 2", participation_id: @partitipation4.id)
