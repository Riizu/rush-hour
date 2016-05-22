class PayloadUserAgent < ActiveRecord::Base
  self.table_name = "user_agents"

  has_many :payload_requests
  has_many :clients, through: :payload_requests

  validates :browser, presence: true
  validates :platform, presence: true

  def self.web_browser_breakdown
    group("browser").count
  end

  def self.web_platform_breakdown
    group("platform").count
  end

end
