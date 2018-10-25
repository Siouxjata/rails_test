class Group < ActiveRecord::Base
  belongs_to :user
  has_many :signups
  has_many :users, through: :signups

	validates :name, presence: true,
	    length: { in: 5..200 }
	validates :description, presence: true, length: { in: 10..300 }

	after_create :successfully_created

	after_update :successfully_updated

    private
       
        def successfully_created
            puts "Successfully created a new group"
        end

        def successfully_updated
            puts "Successfully updated an existing group"
        end
end
