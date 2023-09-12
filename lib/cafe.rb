# frozen_string_literal: true
=begin
Kiara is a Shopify merchant who owns a Board Game Cafe.
The cafe is open from 8 am until 10 pm every day and
charges according to the following table:

Hours (24 hour)    | Rate per person per hour
------------------ | ------------------------
8 - 9              | $2
10 - 15            | $4
16 - 22            | $2

Rates are calculated at the start of each hour, so
if someone arrived at 9 and stayed for three hours,
they would be charged $2 / hour for the first hour
and $4 / hour for the remaining two hours.

If someone stays for more than 4 hours, a $1
discount is applied to each additional hour. For
example, if a session lasts for 6 hours, the last
two hours will be reduced by $1 each.

Write a function `calculateRevenue` which calculates
the revenue made by the business for a day, given
a list of sessions. A session consists of the number
of people in a group, the hour they arrived, and
the number of hours they stayed.

Input / output diagram

calculateRevenue([
   +------------ number of people in the group
   |   +-------- arrival hour of group (24 hour format)
   |   |  +----- number of hours the group stayed
  [2, 10, 3], ᐊ---- a single session
  [7, 14, 5],
])

Examples

calculateRevenue([
  [1, 8, 2],  // 1 person * 2 hours * $2 = $4
  [2, 9, 4],  // 2 people * (1 hour * $2 + 3 hours * $4) = $28
]) => 32

calculateRevenue([
  [3, 14, 1], // 3 people * 1 hour * $4 = $12
  [4, 10, 3], // 4 people * 3 hours * $4 = $48
  [1, 9, 9],  // 1 person * (1 hour * $2 + 6 hours * $4 + 2 hours * $2 - (9 - 4) hours * $1) = $25
]) => 85
=end

require_relative "cafe/version"

module Cafe
  RATES = {
    8..9 => 2,
    10..15 => 4,
    16..22 => 2
  }

  class Session
    attr_reader :people, :arrival, :hours

    def initialize(session)
      @people, @arrival, @hours = session
    end

    def calculate_revenue
      calculate_rates(arrival, hours) * people
    end

    def calculate_rates(arrival, hours)
      (arrival...(arrival + hours)).map do |hour|
        calculate_rate(hour)
      end.sum - discount(hours)
    end

    def calculate_rate(hour)
      RATES.find { |range, _| range.include?(hour) }[1]
    end

    def discount(hours)
      if hours > 4
        hours - 4
      else
        0
      end
    end
  end

  class Revenue
    def calculate(sessions)
      sessions.map { |session| Session.new(session).calculate_revenue() }.sum
    end
  end
end
