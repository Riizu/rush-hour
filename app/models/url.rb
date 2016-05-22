class Url < ActiveRecord::Base
  has_many :payload_requests
  has_many :request_types, through: :payload_requests
  has_many :referrers, through: :payload_requests
  has_many :clients, through: :payload_requests
  has_many :responded_ins, through: :payload_requests

  validates :name, presence: true

  def self.get_name_by_relative_path(path)
    pluck("name").find do |name|
      name.split("/")[3] == path
    end
  end

  def associated_verbs
    request_types.group("verb").count
  end

  def top_three_referrers
    referrer_id_count = payload_requests.group("referrer_id").count
    sorted_id = referrer_id_count.sort_by { |k, v| -v }.first(3)
    find_referrer_object(sorted_id)
  end

  def find_referrer_object(sorted_id)
    sorted_id.map {|id| Referrer.find(id[0])}
  end

  def top_three_user_agents
    user_agent_id_count = payload_requests.group("user_agent_id").count
    sorted_id = user_agent_id_count.sort_by { |k, v| -v }.first(3)
    find_user_agent_object(sorted_id)
  end

  def find_user_agent_object(sorted_id)
    sorted_id.map {|id| PayloadUserAgent.find(id[0])}
  end

  def max_response_time
    responded_ins.maximum("time")
  end

  def min_response_time
    responded_ins.minimum("time")
  end

  def response_times_longest_to_shortest
    responded_ins.order("time").reverse_order.pluck("time")
  end

  def average_response_time
    responded_ins.average("time").round
  end
end
