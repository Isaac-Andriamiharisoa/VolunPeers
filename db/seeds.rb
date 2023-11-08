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

@bob = User.create(first_name: "Bob", last_name: "Sullivan", username: "Monster Bob", contact: 1234566789, email: "Bob@email.com", password: "123456")
@alice = User.create(first_name: "Alice", last_name: "Wonder", username: "Wonder Alice", contact: 0123123013, email: "Alice@email.com", password: "123456")
@john = User.create(first_name: "John", last_name: "Doe", username: "John Doe", contact: 1234123412, email: "John@email.com", password: "123456")

@event1 = Event.create(
  title: "Event 1",
  description: "This is event 1",
  start_time: "09:00",
  end_time: "17:00",
  country: "Country Name",
  # address: "Street Name, City, State, Zip",
  contact: 1234567890,
  start_date: "2023-11-08",
  end_date: "2023-12-07",
  user_id: @bob.id
)

@event2 = Event.create(
  title: "Event 2",
  description: "This is event 2",
  start_time: "10:00",
  end_time: "18:00",
  country: "Country Name",
  # address: "Street Name, City, State, Zip",
  contact: 1234567891,
  start_date: "2023-11-09",
  end_date: "2023-12-08",
  user_id: @bob.id
)

@event3 = Event.create(
  title: "Event 3",
  description: "This is event 3",
  start_time: "11:00",
  end_time: "19:00",
  country: "Country Name",
  # address: "Street Name, City, State, Zip",
  contact: 1234567892,
  start_date: "2023-11-10",
  end_date: "2023-12-09",
  user_id: @john.id
)

@event4 = Event.create(
  title: "Event 4",
  description: "This is event 4",
  start_time: "12:00",
  end_time: "20:00",
  country: "Country Name",
  # address: "Street Name, City, State, Zip",
  contact: 1234567893,
  start_date: "2023-11-11",
  end_date: "2023-12-10",
  user_id: @alice.id
)

@partitipation1 = Participation.create(user_id: @bob.id, event_id: @event1.id)
@partitipation2 = Participation.create(user_id: @alice.id, event_id: @event1.id)
@partitipation3 = Participation.create(user_id: @john.id, event_id: @event1.id)
@partitipation4 = Participation.create(user_id: @bob.id, event_id: @event2.id)
@partitipation5 = Participation.create(user_id: @alice.id, event_id: @event2.id)
