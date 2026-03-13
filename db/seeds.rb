# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin User
FactoryBot.create(:admin_user, email: 'admin@example.com', password: 'password',
                               password_confirmation: 'password')

# Utilities
north_utility = FactoryBot.create(:north_utility, code: 1)
south_utility = FactoryBot.create(:south_utility, code: 2)

# Users
FactoryBot.create_list(:user, 20, utility: north_utility,
                                  password: '12345678', password_confirmation: '12345678')
FactoryBot.create_list(:user, 20, utility: south_utility,
                                  password: '12345678', password_confirmation: '12345678')

FactoryBot.create(:user, utility: south_utility, email: 'test_south@widergy.com',
                         password: '12345678', password_confirmation: '12345678')

FactoryBot.create(:user, utility: north_utility, email: 'test_north@widergy.com',
                         password: '12345678', password_confirmation: '12345678')

User.all.find_each do |user|
  random_books_amount = [1, 2, 3].sample
  FactoryBot.create_list(:book, random_books_amount, user: user, utility: user.utility)
end


# Get some users from each utility
north_users = User.joins(:utility).where(utilities: { type: 'NorthUtility' }).limit(5)
south_users = User.joins(:utility).where(utilities: { type: 'SouthUtility' }).limit(5)

# Create notes for North Utility users
north_users.each do |user|
  # Valid critique note
  Note.create!(
    title: 'Excellent Book Analysis',
    content: 'This book provides an in-depth analysis of modern literature trends and their impact on contemporary society.',
    note_type: :critique,
    user: user
  )
  
  # Valid short review (under 50 words for North)
  Note.create!(
    title: 'Quick Review',
    content: 'Great book with interesting characters and plot development. Highly recommended for fiction lovers.',
    note_type: :review,
    user: user
  )
  
  # Valid medium critique (51-100 words for North)
  Note.create!(
    title: 'Detailed Analysis',
    content: 'This comprehensive study examines the intricate relationships between character development and narrative structure in contemporary fiction. The author skillfully weaves together multiple storylines while maintaining coherence throughout the entire work. The thematic elements are particularly well-developed, offering readers multiple layers of interpretation and meaning that enhance the overall reading experience significantly.',
    note_type: :critique,
    user: user
  )
end

# Create notes for South Utility users  
south_users.each do |user|
  # Valid critique note
  Note.create!(
    title: 'Literary Critique',
    content: 'An outstanding work that challenges conventional narrative structures while maintaining accessibility for general readers.',
    note_type: :critique,
    user: user
  )
  
  # Valid short review (under 60 words for South)
  Note.create!(
    title: 'Book Review',
    content: 'Fascinating exploration of human nature through compelling storytelling. The author demonstrates exceptional skill in character development and world-building.',
    note_type: :review,
    user: user
  )
  
  # Valid long critique (over 120 words for South)
  Note.create!(
    title: 'Comprehensive Review',
    content: 'This remarkable literary achievement stands as a testament to the power of innovative storytelling techniques in modern fiction. The author demonstrates exceptional mastery of narrative voice, seamlessly transitioning between multiple perspectives while maintaining a cohesive and engaging storyline throughout the entire work. The character development is particularly noteworthy, with each protagonist displaying realistic growth and complexity that resonates with readers on multiple emotional levels. Furthermore, the thematic exploration of contemporary social issues is handled with remarkable sensitivity and insight, offering readers valuable perspectives on current societal challenges while avoiding heavy-handed moralizing that might detract from the overall narrative experience.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    note_type: :critique,
    user: user
  )
end
