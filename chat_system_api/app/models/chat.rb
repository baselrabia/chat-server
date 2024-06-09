class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy

  validates :number,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 },
            uniqueness: { scope: :application_id }

  before_validation :set_number, on: :create

  private

  def set_number

    # job send app id -- 
    #
    # 1000 chat - 1 application
    # 1000 job 
    #
    self.number = (application.chats.maximum(:number) || 0) + 1 # TODO: create a single chat job 
  end
end
