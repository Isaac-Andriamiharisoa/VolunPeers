# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Reseting records"
User.destroy_all
Event.destroy_all
Participation.destroy_all

puts "creating users"
@bob = User.create(first_name: "Bob", last_name: "Sullivan", username: "Monster Bob", contact: 1234566789, email: "Bob@email.com", password: "123456", role: 'admin')
@alice = User.create(first_name: "Alice", last_name: "Wonder", username: "Wonder Alice", contact: 0123123013, email: "Alice@email.com", password: "123456", role: "normal")
@john = User.create(first_name: "John", last_name: "Doe", username: "John Doe", contact: 1234123412, email: "John@email.com", password: "123456", role: "normal")

puts "creating events"
@event1 = Event.create(
  title: "Community Cleanup Day",
  description: "Join us for a day of environmental stewardship! Help clean up our community parks, streets, and public spaces. Together, we can make a lasting impact.",
  start_time: "09:00",
  end_time: "17:00",
  country: "US",
  address: "Miami",
  contact: 12345678,
  start_date: "2023-11-08",
  end_date: "2023-12-07",
  user_id: @bob.id,
  action: "Trees to Plant",
  quantity: 40
)

@event2 = Event.create(
  title: "Food Drive for the Needy",
  description: "Be part of something bigger! Contribute to our food drive, ensuring that no one in our community goes hungry. Your generosity can make a significant difference.",
  start_time: "10:00",
  end_time: "18:00",
  country: "IN",
  address: "Goa",
  contact: 12345678,
  start_date: "2023-11-09",
  end_date: "2023-12-08",
  user_id: @bob.id,
  action: "Batiment to Build",
  quantity: 12
)

@event3 = Event.create(
  title: "Youth Mentorship Program",
  description: "Empower the next generation! Volunteer as a mentor in our youth program. Share your knowledge and experiences to inspire and guide young minds toward success.",
  start_time: "11:00",
  end_time: "19:00",
  country: "FR",
  address: "Paris",
  contact: 12345678,
  start_date: "2023-11-10",
  end_date: "2023-12-09",
  user_id: @john.id,
  action: "Litter to Clean",
  quantity: 35
)


@event4 = Event.create(
  title: "Senior Companionship Project",
  description: "Connect with seniors in our community! Join our companionship project to spend quality time with older adults. Your friendship can bring joy and warmth to their lives.",
  start_time: "12:00",
  end_time: "20:00",
  country: "AU",
  address: "Perth",
  contact: 12345678,
  start_date: "2023-12-11",
  end_date: "2023-12-21",
  user_id: @alice.id,
  action: "Trees to Plant",
  quantity: 35
)

puts "creating partitipations"
@partitipation1 = Participation.create(user_id: @bob.id, event_id: @event1.id)
@partitipation2 = Participation.create(user_id: @alice.id, event_id: @event4.id)
@partitipation3 = Participation.create(user_id: @john.id, event_id: @event1.id)
@partitipation4 = Participation.create(user_id: @bob.id, event_id: @event2.id)
@partitipation5 = Participation.create(user_id: @alice.id, event_id: @event2.id)

puts "creating testimonials"
@testimonial = Testimonial.create(content: "Community Cleanup Day was a fantastic experience! Working together to spruce up our shared spaces was not only rewarding but also created a strong sense of community. It's incredible what we can achieve when we come together. Proud to be part of a community that cares about keeping our neighborhoods clean and vibrant.", participation_id: @partitipation1.id)
@testimonial = Testimonial.create(content: "I am truly grateful to have been part of the Food Drive for the Needy. Witnessing the collective efforts of our community to bring essential nourishment to those facing food insecurity has been incredibly inspiring. This initiative goes beyond filling plates; it fills hearts with hope and reminds us of the strength in unity. Seeing the smiles on the faces of those who received the support reassures me that together, we can make a meaningful impact. The Food Drive for the Needy is more than just a campaign; it's a testament to the compassion and generosity that bind us together. Proud to be part of a community that cares.", participation_id: @partitipation5.id)
